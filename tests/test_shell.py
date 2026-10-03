import os
from pathlib import Path
import subprocess
import tempfile
import unittest

RC = Path(__file__).resolve().parents[1] / '.zshrc'


class ShellTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles shell ')
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.bin = self.home / 'bin'
        self.bin.mkdir()
        self.zinit = self.home / 'zinit'
        self.zinit.mkdir()
        (self.zinit / 'zinit.zsh').write_text('zinit() { :; }\n')
        self.env = dict(os.environ, HOME=str(self.home), ZINIT_HOME=str(self.zinit),
                        PATH=str(self.bin) + ':/usr/bin:/bin')

    def tool(self, name, body):
        path = self.bin / name
        path.write_text('#!/bin/sh\n' + body + '\n')
        path.chmod(0o755)

    def shell(self, code):
        result = subprocess.run(['/bin/zsh', '-dfi', '-c', 'source "$1"; ' + code,
                                 'test', str(RC)], env=self.env, capture_output=True,
                                text=True, timeout=30)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn('command not found', result.stderr)
        return result

    def test_missing_optional_tools_and_local_settings(self):
        (self.home / '.zshrc.local').write_text('export DOTFILES_LOCAL_LOADED=yes\n')
        result = self.shell('[[ "$DOTFILES_LOCAL_LOADED" == yes ]] && '
                            '(( ! $+functions[node] )) && (( ! $+functions[sdk] ))')
        self.assertEqual(result.stderr, '')

    def test_node_shims_initialize_once_without_fnm_usage(self):
        log = self.home / 'fnm.log'
        self.env['DOTFILES_FNM_LOG'] = str(log)
        self.tool('fnm', 'echo "$*" >> "$DOTFILES_FNM_LOG"\n'
                         'if [ "$1" = env ]; then echo "export DOTFILES_FNM_READY=yes"; fi')
        for tool in ('node', 'npm', 'npx'):
            self.tool(tool, '[ "$DOTFILES_FNM_READY" = yes ] || exit 7\necho "$*"')
        result = self.shell('node "argument with spaces" && npm --version && npx --version && fnm --version')
        self.assertEqual(result.stdout.splitlines(), ['argument with spaces', '--version', '--version'])
        self.assertEqual(log.read_text().splitlines(), ['env --shell=zsh', '--version'])

    def test_failed_fnm_init_does_not_run_node_and_can_retry(self):
        self.tool('fnm', '[ "$DOTFILES_FNM_RETRY" = yes ] || exit 9\necho "export DOTFILES_FNM_READY=yes"')
        self.tool('node', '[ "$DOTFILES_FNM_READY" = yes ] || exit 7\necho ready')
        result = self.shell('node; result=$?; [[ "$result" == 9 ]] || exit 1; '
                            '(( $+functions[node] )) || exit 1; export DOTFILES_FNM_RETRY=yes; node')
        self.assertEqual(result.stdout.strip(), 'ready')


if __name__ == '__main__':
    unittest.main()
