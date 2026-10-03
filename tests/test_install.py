import contextlib
import io
import importlib.util
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('dotfiles', Path(__file__).resolve().parents[1] / 'scripts/dotfiles.py')
dotfiles = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dotfiles)


class InstallTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles test ')
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.config = self.home / 'custom config'

    def install(self, **kwargs):
        with contextlib.redirect_stdout(io.StringIO()):
            dotfiles.install(self.home, self.config, **kwargs)

    def test_install_is_idempotent(self):
        self.install()
        self.install()
        for src, dst in dotfiles.links(self.home, self.config):
            self.assertTrue(dst.is_symlink())
            self.assertEqual(dst.resolve(), src.resolve())
        self.assertEqual(list(self.home.rglob('*.backup-*')), [])

    def test_conflicts_abort_before_any_changes(self):
        target = self.config / 'ghostty'
        target.mkdir(parents=True)
        (target / 'config').write_text('local settings')
        with self.assertRaises(RuntimeError):
            self.install()
        self.assertFalse((self.home / '.zshrc').exists())
        self.assertEqual((target / 'config').read_text(), 'local settings')

    def test_backup_preserves_files_directories_and_broken_links(self):
        (self.home / '.zshrc').write_text('private shell settings')
        (self.home / '.tmux.conf').symlink_to('missing target')
        (self.config / 'nvim').mkdir(parents=True)
        (self.config / 'nvim/init.lua').write_text('local editor settings')
        self.install(backup=True)
        saved = next(self.home.glob('.zshrc.backup-*'))
        self.assertEqual(saved.read_text(), 'private shell settings')
        saved_link = next(self.home.glob('.tmux.conf.backup-*'))
        self.assertEqual(saved_link.readlink(), Path('missing target'))
        saved_dir = next(self.config.glob('nvim.backup-*'))
        self.assertEqual((saved_dir / 'init.lua').read_text(), 'local editor settings')

    def test_dry_run_does_not_write(self):
        (self.home / '.zshrc').write_text('private settings')
        self.install(backup=True, dry_run=True)
        self.assertEqual((self.home / '.zshrc').read_text(), 'private settings')
        self.assertFalse(self.config.exists())
        self.assertEqual(list(self.home.glob('*.backup-*')), [])


if __name__ == '__main__':
    unittest.main()
