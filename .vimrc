" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Plug 'jeetsukumaran/vim-indentwise'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'obreitwi/vim-sort-folds'
" Plug 'paulhybryant/foldcol'
" Plug 'pseewald/vim-anyfold'
" Plug 'terryma/vim-expand-region'
" Plug 'tmhedberg/simpylfold'
" Plug 'vim-scripts/argtextobj.vim'
" Plug 'vim-scripts/indentpython.vim'

Plug 'dracula/vim'
Plug 'chrisbra/NrrwRgn'
Plug 'dhruvasagar/vim-table-mode'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'google/vim-maktaba'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'"
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'mechatroner/rainbow_csv'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'scrooloose/nerdtree'
Plug 'thinca/vim-visualstar'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/AdvancedSorters'
Plug 'wellle/targets.vim'
Plug 'rust-lang/rust.vim'

if has('nvim')
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    " Plug 'glepnir/lspsaga.nvim'
    Plug 'ray-x/lsp_signature.nvim'
    Plug 'hrsh7th/nvim-compe'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'metakirby5/codi.vim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
    Plug 'ray-x/lsp_signature.nvim'
    Plug 'simrat39/rust-tools.nvim'
    " Plug 'simrat39/symbols-outline.nvim'
    Plug 'mfussenegger/nvim-jdtls'
endif

" All of your Plugins must be added before the following line
call plug#end()            " required
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
" set term=builtin_ansi
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
set mouse=a
set foldlevel=99
" set scrolloff=3
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END
set t_Co=256
autocmd FileType c,cpp setlocal expandtab shiftwidth=2 softtabstop=2 cindent 
autocmd FileType vim setlocal expandtab shiftwidth=2 softtabstop=2 cindent 
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 autoindent

" Anyfold (anyfold) ------------------------------------------------------
" {{{"
" autocmd Filetype java AnyFoldActivate  " turn this on for Java"
" autocmd Filetype scala AnyFoldActivate " turn this on for Scala"
" " ------------------------------------------------------------------------
" }}}"

" set background=dark

let mapleader = "\<Space>"


let g:dracula_italic=0
color dracula
" highlight Normal ctermbg=NONE
" highlight nonText ctermbg=NONE
" highlight Pmenu ctermfg=10 ctermbg=128 guifg=#000000 guibg=#0000ff
map <C-l> :NERDTreeToggle<CR>

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } }

let g:EasyMotion_do_mapping = 1 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

nmap <leader>gf :diffget //2<CR>
nmap <leader>gj :diffget //3<CR>
nmap <leader>p :GFiles<CR>

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

let g:targets_nl = 'nl'

let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='

" autoformat
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,arduino AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  " autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType javascript,typescript,vue AutoFormatBuffer prettier
augroup END

" use google style for clang-format
Glaive codefmt clang_format_style='google' 
Glaive codefmt google_java_executable="java -jar /Users/mehrish/Developer/Formatter/google-java-format-1.3-all-deps.jar"
" let g:clang_format#code_style='google' 
" let g:tex_flavor = 'latex'
" let g:vimtex_view_method = 'skim'
" nnoremap <C-P> :YcmCompleter GoTo<CR>

" max colors for mark plugin
let g:mwDefaultHighlightingPalette = 'maximum'

let g:codi#interpreters = {
   \ 'python': {
       \ 'bin': 'python3',
       \ 'prompt': '^\(>>>\|\.\.\.\) ',
       \ },
   \ }

com! FormatJSON %!python -m json.tool

set hidden
set nobackup                  " Remove them pesky .swp files"
set nowritebackup
set updatetime=300            " ...so screen draws don't lag"
set shortmess+=c              " Don't pass messages to |ins-completion-menu|"
set signcolumn=yes            " Always show signedcolumn"

