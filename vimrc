" ADAL's Productive Vim (.vimrc) - cleaned and robust

set nocompatible
" keep filetype off until plugin init
filetype off

" -------------------------
" Plugins (lightweight & essential)
" -------------------------
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'                           " File explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder native installer
Plug 'junegunn/fzf.vim'                             " FZF integration
Plug 'tpope/vim-obsession'                          " Session manager
Plug 'preservim/vim-indent-guides'                  " Visual indent lines
Plug 'benmills/vimux'                               " Run shell commands via tmux
Plug 'christoomey/vim-tmux-navigator'               " Navigate between vim and tmux panes easily
Plug 'catppuccin/vim'

call plug#end()


" =====================================================================
" Vim persistent undo and sensible backups
" =====================================================================
set undofile
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//


" =====================================================================
" Mouse behaviour and Copy Paste
" =====================================================================
" Enable mouse in Vim
set mouse=a

" High confidence copy workflow
vnoremap <C-c> "+y
nnoremap <C-c> "+yy


" =====================================================================
" Basic UI
" =====================================================================
syntax on
set number
set relativenumber
set signcolumn=yes
set hlsearch
set ignorecase
set smartcase

" =====================================================================
" True colour if supported
" =====================================================================
if (has("termguicolors"))
  set termguicolors
endif

" =====================================================================
" Editor preferences
" =====================================================================
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set backspace=indent,eol,start
set encoding=utf-8
set fileencoding=utf-8
filetype plugin indent on

" =====================================================================
" Visual indentation with safe fallbacks
" =====================================================================
set list
" Unicode glyphs may not render on all terminals, so provide safe ASCII fallback
if &term =~# '256color'
  set listchars=tab:┊\ ,trail:·,extends:>,precedes:<
else
  set listchars=tab:>-,trail:-,extends:>,precedes:<
endif

" =====================================================================
" Colours - try gruvbox, else fall back to desert
" =====================================================================
try
  colorscheme catppuccin
catch
  colorscheme desert
endtry



" =====================================================================
" Leader key
" =====================================================================
let mapleader = " "

" =====================================================================
" Plugin Settings and Mappings
" =====================================================================

" --- NERDTree ---
nnoremap <silent> <leader>n :NERDTreeToggle<CR>

" --- FZF ---
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>

" --- Vimux (run commands in tmux split) ---
" Use shellescape to safely handle filenames with spaces
nnoremap <silent> <leader>r :call VimuxRunCommand("python3 " . shellescape(expand("%"), 1))<CR>
nnoremap <silent> <leader>t :VimuxPromptCommand<CR>

" --- Obsession ---
nnoremap <silent> <leader>s :Obsession<CR>

" --- Obsession Save Rule ---
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winpos,winsize

" --- [ESC] Remove Search Highlights ---
nnoremap <Esc> :nohlsearch<CR><Esc>

" --- vim-indent-guides ---
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=236
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=238


" =====================================================================
" Cheatsheet (press <Space> ?)
" =====================================================================
function! ShowCheatsheetFull() abort
  silent! tabnew __VIM_CHEATSHEET__
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nowrap
  setlocal nonumber norelativenumber
  setlocal modifiable

  call setline(1, [
        \ '  ┌───────────────────────────────────────────────────────────────┐',
        \ '  │      Vim Cheatsheet - quick reference (q or <Space> to exit)  │',
        \ '  │                                                               │',
        \ '  │  Modes:                                                       │',
        \ '  │    i -> insert mode           ESC -> normal mode              │',
        \ '  │    v -> visual mode                                           │',
        \ '  │                                                               │',
        \ '  │  Undo / redo:                                                 │',
        \ '  │    u -> undo                 <C-r> -> redo                    │',
        \ '  │                                                               │',
        \ '  │  Copy & paste:                                                │',
        \ '  │    y -> yank (copy)          p -> paste                       │',
        \ '  │    yy -> yank (copy line)                                     │',
        \ '  │    dd -> delete line         x -> delete character            │',
        \ '  │                                                               │',
        \ '  │  Move around:                                                 │',
        \ '  │    h j k l -> left / down / up / right                        │',
        \ '  │    gg / G  -> top / bottom                                    │',
        \ '  │    w / b   -> next / previous word                            │',
        \ '  │                                                               │',
        \ '  │  Search:                                                      │',
        \ '  │    /pattern -> search forward   n / N -> next / previous      │',
        \ '  │                                                               │',
        \ '  │  Find and Replace                                             │',
        \ '  │    :%s/<old>/<new>/g                                          │',
        \ '  │                                                               │',
        \ '  │  Splits & Windows:                                            │',
        \ '  │    :split / :vsplit -> create split                           │',
        \ '  │    <C-w>w -> switch windows                                   │',
        \ '  │                                                               │',
        \ '  │  Plugins (leader = <Space>):                                  │',
        \ '  │    <Space>n -> Toggle NERDTree (file explorer)                │',
        \ '  │    <Space>f -> FZF file search                                │',
        \ '  │    <Space>b -> FZF buffer list                                │',
        \ '  │    <Space>r -> Vimux: run current file in tmux pane           │',
        \ '  │    <Space>t -> Vimux: prompt for command to run in tmux pane  │',
        \ '  │    <Space>s -> Obsession: start/stop session tracking         │',
        \ '  │    <Space>? -> Open this cheatsheet                           │',
        \ '  │                                                               │',
        \ '  │  Quit:                                                        │',
        \ '  │    :q -> quit               :wq -> save & quit                │',
        \ '  └───────────────────────────────────────────────────────────────┘',
        \ ])

  setlocal nomodifiable
  nnoremap <silent><buffer> <Space> :tabclose<CR>
  nnoremap <silent><buffer> q       :tabclose<CR>
endfunction

nnoremap <silent> <leader>? :call ShowCheatsheetFull()<CR>

