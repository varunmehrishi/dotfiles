#!/usr/bin/env python3
"""Install symlinks safely, or validate the tracked development environment."""
import argparse
import ast
from datetime import datetime
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import tomllib

ROOT = Path(__file__).resolve().parents[1]
# Legacy Vim/Yabai/Skhd and app database exports remain opt-in/manual.
HOME_FILES = ('.zshrc', '.tmux.conf', '.vifm')
CONFIG_FILES = ('nvim', 'ghostty', 'starship.toml')
TOOLS = ('nvim', 'tmux', 'fzf', 'rg', 'eza', 'bat', 'starship', 'atuin', 'zoxide', 'fnm', 'jq', 'delta')


def links(home, config):
    return [(ROOT / name, home / name) for name in HOME_FILES] + [
        (ROOT / '.config' / name, config / name) for name in CONFIG_FILES
    ]


def install(home, config, *, backup=False, dry_run=False):
    plan = links(home, config)
    conflicts = [dst for src, dst in plan
                 if (dst.exists() or dst.is_symlink()) and dst.resolve() != src.resolve()]
    if conflicts and not backup:
        raise RuntimeError('Existing files differ; use --backup to preserve them before linking:\n' +
                           '\n'.join(map(str, conflicts)))
    stamp = datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    for src, dst in plan:
        if dst.is_symlink() and dst.resolve() == src.resolve():
            print(f'OK     {dst}')
            continue
        if dst in conflicts:
            saved = dst.with_name(dst.name + '.backup-' + stamp)
            print(f'BACKUP {dst} -> {saved}')
            if not dry_run:
                dst.rename(saved)
        print(f'LINK   {dst} -> {src}')
        if not dry_run:
            dst.parent.mkdir(parents=True, exist_ok=True)
            dst.symlink_to(src, target_is_directory=src.is_dir())


def validate():
    failures = []

    def run(label, args, **kwargs):
        try:
            result = subprocess.run(args, capture_output=True, text=True, timeout=60, **kwargs)
            if result.returncode:
                raise RuntimeError((result.stderr + result.stdout).strip())
            print(f'PASS {label}')
            return result
        except (OSError, RuntimeError, subprocess.TimeoutExpired) as error:
            failures.append(label)
            print(f'FAIL {label}: {error}')

    # Parse data without starting any applications or touching their databases.
    for pattern, parser in [('*.json', json.loads), ('*.toml', tomllib.loads),
                            ('*.py', ast.parse)]:
        for path in sorted(ROOT.rglob(pattern)):
            if '.git' in path.parts:
                continue
            try:
                parser(path.read_text())
            except (ValueError, SyntaxError) as error:
                failures.append(str(path.relative_to(ROOT)))
                print(f'FAIL {path.relative_to(ROOT)}: {error}')
    print('PASS data and Python syntax' if not failures else 'FAIL data and Python syntax')
    run('Zsh syntax', ['zsh', '-n', str(ROOT / '.zshrc')])
    run('Yabai shell syntax', ['sh', '-n', str(ROOT / 'config/yabai/yabairc')])
    seen = {}
    for number, line in enumerate((ROOT / 'config/skhd/skhdrc').read_text().splitlines(), 1):
        match = re.match(r'^([a-z0-9 +]+)\s*-\s*([a-z0-9]+)\s*:', line)
        if not match:
            continue
        key = tuple(sorted(match[1].replace(' ', '').split('+'))) + (match[2],)
        if key in seen:
            failures.append('Skhd shortcuts')
            print(f'FAIL Skhd duplicate shortcut on lines {seen[key]} and {number}')
        seen[key] = number
    if 'Skhd shortcuts' not in failures:
        print('PASS Skhd shortcut uniqueness')
    for tool in TOOLS:
        found = shutil.which(tool)
        print(f'{"OK  " if found else "WARN"} {tool}: {found or "not installed (optional shell integrations skip it)"}')

    nvim = shutil.which('nvim')
    if nvim:
        # Compile every Lua module first, without plugin downloads or startup side effects.
        env = dict(os.environ, DOTFILES_ROOT=str(ROOT))
        lua = '''local root = vim.env.DOTFILES_ROOT .. '/.config/nvim'
for _, p in ipairs(vim.fn.globpath(root, '**/*.lua', false, true)) do
  local fn, err = loadfile(p); if not fn then error(err) end
end'''
        run('Neovim Lua syntax', [nvim, '--clean', '--headless', '-c',
                                 'lua ' + lua, '-c', "lua if vim.v.errmsg ~= '' then vim.cmd('cquit') end", '-c', 'qa'], env=env)
        lua = "lua if vim.v.errmsg ~= '' then io.stderr:write(vim.v.errmsg); vim.cmd('cquit') end"
        run('Neovim startup', [nvim, '--headless', '--cmd',
                              "lua vim.opt.rtp:prepend(vim.env.DOTFILES_ROOT .. '/.config/nvim')",
                              '-u', str(ROOT / '.config/nvim/init.lua'), '-c', lua, '-c', 'qa'], env=env)
        run('Neovim behavior', [nvim, '--headless', '--cmd',
                               "lua vim.opt.rtp:prepend(vim.env.DOTFILES_ROOT .. '/.config/nvim')",
                               '-u', str(ROOT / '.config/nvim/init.lua'), '-c',
                               "lua dofile(vim.env.DOTFILES_ROOT .. '/tests/nvim.lua')"], env=env, cwd=ROOT)
    else:
        failures.append('Neovim unavailable')

    ghostty = shutil.which('ghostty') or next((str(path) for path in (
        Path('/Applications/Ghostty.app/Contents/MacOS/ghostty'),
        Path.home() / 'Applications/Ghostty.app/Contents/MacOS/ghostty',
    ) if path.is_file() and os.access(path, os.X_OK)), None)
    if ghostty:
        run('Ghostty config', [ghostty, '+validate-config', '--config-file=' + str(ROOT / '.config/ghostty/config')])
    else:
        print('WARN Ghostty config validation unavailable')

    tmux = shutil.which('tmux')
    if tmux:
        # Dedicated server and temporary home avoid user sessions and TPM jobs.
        socket = 'dotfiles-check-' + str(os.getpid())
        with tempfile.TemporaryDirectory(prefix='dotfiles-tmux-') as home:
            env = dict(os.environ, HOME=home)
            try:
                result = run('Tmux config', [tmux, '-L', socket, '-f', '/dev/null',
                                            'new-session', '-d', '-s', 'check',
                                            'sleep 30', ';', 'set-option', '-g', 'default-shell', '/bin/sh',
                                            ';', 'source-file', str(ROOT / '.tmux.conf')], env=env)
                if result and result.stderr.strip():
                    failures.append('Tmux config diagnostics')
                    print('FAIL Tmux diagnostics: ' + result.stderr.strip())
            finally:
                subprocess.run([tmux, '-L', socket, 'kill-server'], capture_output=True, env=env)
    else:
        failures.append('Tmux unavailable')
    if failures:
        print(f'Failed: {", ".join(failures)}')
        return 1
    print('All available configuration checks passed.')
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    setup = sub.add_parser('install', help='link active configs; refuse conflicts unless --backup is used')
    setup.add_argument('--home', type=Path, default=Path.home())
    setup.add_argument('--config-home', type=Path)
    setup.add_argument('--backup', action='store_true')
    setup.add_argument('--dry-run', action='store_true')
    sub.add_parser('check', help='validate syntax and run isolated application checks')
    args = parser.parse_args()
    if args.action == 'check':
        return validate()
    home = args.home.expanduser().resolve()
    config = args.config_home or Path(os.environ.get('XDG_CONFIG_HOME', str(home / '.config')))
    try:
        install(home, config.expanduser().absolute(), backup=args.backup, dry_run=args.dry_run)
    except (OSError, RuntimeError) as error:
        parser.exit(1, f'{error}\n')
    return 0


if __name__ == '__main__':
    sys.exit(main())
