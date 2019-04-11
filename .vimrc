filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
" Plugin 'w0rp/ale'
Plugin 'tpope/commentary.vim'
" Plugin 'rhysd/vim-clang-format'
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
Plugin 'google/vim-glaive'

Plugin 'lervag/vimtex'
Bundle 'ron89/thesaurus_query.vim'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'itchyny/lightline.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'dracula/vim'
Plugin 'jeetsukumaran/vim-indentwise'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'tmhedberg/simpylfold'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'terryma/vim-expand-region'
" All of your Plugins must be added before the following line
call vundle#end()            " required
call glaive#Install()
set autoindent
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
if has('mac') && ($TERM == 'xterm-256color' || $TERM == 'screen-256color')
		map <Esc>OP <F1>
		map <Esc>OQ <F2>
		map <Esc>OR <F3>
		map <Esc>OS <F4>
		map <Esc>[16~ <F5>
		map <Esc>[17~ <F6>
		map <Esc>[18~ <F7>
		map <Esc>[19~ <F8>
		map <Esc>[20~ <F9>
		map <Esc>[21~ <F10>
		map <Esc>[23~ <F11>
		map <Esc>[24~ <F12>
endif
set term=builtin_ansi
syntax on
set backspace=2
set exrc
set secure
set expandtab
set tabstop=4
set shiftwidth=4
set cursorline
set number
set laststatus=2
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END
set t_Co=256
autocmd FileType c,cpp setlocal expandtab shiftwidth=2 softtabstop=2 cindent 
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 autoindent
" set background=dark
color dracula
" highlight Normal ctermbg=NONE
" highlight nonText ctermbg=NONE
" highlight Pmenu ctermfg=10 ctermbg=128 guifg=#000000 guibg=#0000ff
map <C-l> :NERDTreeToggle<CR>

let g:ycm_server_python_interpreter = '/usr/local/bin/python'
let g:ycm_global_ycm_extra_conf = "~/.ycm_extra_conf.py"
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
" let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_python_binary_path = '/usr/local/bin/python'
let g:ycm_semantic_triggers =  {
  \ 'c' : ['re!\w{2}'],
  \ 'cpp' : ['re!\w{2}'],
  \ 'python' : ['re!\w{2}'],
  \ }





" setup for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']

" autoformat
augroup autoformat_settings
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType python AutoFormatBuffer yapf
augroup END
" use google style for clang-format
Glaive codefmt clang_format_style='google' 

" let g:clang_format#code_style='google' 
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'skim'
nnoremap <C-P> :YcmCompleter GoTo<CR>
