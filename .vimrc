" Initialization Settings
" =======================
set shortmess+=I

" =======================
" UI and Display Settings
" =======================
set number
set relativenumber
set laststatus=2
set ignorecase
set smartcase
set incsearch
set conceallevel=2
set tags=./tags;,
  set noerrorbells visualbell t_vb=

colorscheme habamax

" =======================
" Editor Behavior
" =======================
set backspace=indent,eol,start
set hidden
set clipboard=unnamedplus
set shiftwidth=4

set foldmethod=syntax
set foldnestmax=10
set foldenable
set foldlevel=2
let g:javaScript_fold = 1

set expandtab        " Use spaces instead of tabs
set tabstop=2        " Number of spaces that a tab counts for
set shiftwidth=2     " Number of spaces to use for each step of (auto)indent
set softtabstop=2    " Number of spaces that a tab counts for while performing editing operations



" ===================
" vimwiki
" ==================

set nocompatible
syntax on
filetype plugin indent on
let g:vimwiki_global_ext = 0
" let g:vimwiki_list = [{'path': "~/code/chrislco/content",
" \ 'syntax': 'markdown', 'ext': '.md','index':"vw.md"}]

let wikiPath = getenv('VIMWIKI_PATH')
if wikiPath != ''
  let g:vimwiki_list = [{'path': wikiPath,
        \ 'syntax': 'markdown', 'ext': '.md', 'index': 'vw.md'}]
endif

"  The following will open a QuickFix window with incomplete tasks, 
"  but only those which are in a hyphenated (-) list. This is a 
"  simple way to filter only on tasks which are ready to be performed. 

function! VimwikiFindIncompleteTasks()
  lvimgrep /- \[ \]/ %:p
  lopen
endfunction

function! VimwikiFindAllIncompleteTasks()
  ALEDisable
  UnProse
  VimwikiSearch /- \[ \]/
  lopen
endfunction

nmap <Leader>wa :call VimwikiFindAllIncompleteTasks()<CR>
nmap <Leader>wx :call VimwikiFindIncompleteTasks()<CR>

" =======================
" Key Mappings
" =======================
nmap Q <Nop>
nnoremap <leader>b ciw**<C-R>"**<Esc>
nnoremap <leader>i ciw_<C-R>"_<Esc>
nnoremap <leader>q viws""<Esc>P
nnoremap ' :ALENext<CR>
nnoremap ; :ALEPrevious<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>
nnoremap <leader>ad :ALEDisable<CR>
nnoremap <leader>ae :ALEEnable<CR>
nnoremap <leader>p :Prose<CR>
nnoremap <leader>up :UnProse<CR>
nnoremap <leader>a vip:EasyAlign<CR>*|

nnoremap go }j
nnoremap gp {k

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" =======================
" Plugins
" =======================
call plug#begin()
Plug 'dense-analysis/ale'
Plug 'reedes/vim-pencil'
Plug 'michaeljsmith/vim-indent-object'
Plug 'github/copilot.vim'
Plug 'tpope/vim-commentary'
Plug 'arcticicestudio/nord-vim'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'prettier/vim-prettier'
Plug 'vimwiki/vimwiki'
Plug 'michal-h21/vim-zettel'
Plug 'dhruvasagar/vim-table-mode'
call plug#end()

" =======================
" Linter and Language Tools
" =======================
let g:ale_virtualtext_cursor=0
let g:ale_linters = {'markdown':['vale'], 'python':['pylint','pylsp']}
let g:ale_python_pylint_options = '--disable=E0401'
let g:ale_set_balloons = 1
let g:ale_completion_enabled = 1

" Markdown conceal
autocmd FileType markdown syntax match MarkdownLink '\v\([^ ]+\)' containedin=ALL conceal cchar=✦

" =======================
" Custom Functions
" =======================
let w:ProseModeOn = 0


function! NoConsole()
  %g/console\./norm I//
endfunction

function EnableProseMode()
  " setlocal spell spelllang=en_us
  Goyo 66
  SoftPencil
  echo "Prose Mode On"
endfu

function DisableProseMode()
  Goyo!
  NoPencil
  setlocal nospell
  echo "Prose Mode Off"
endfu

function ToggleProseMode()
  if w:ProseModeOn == 0
    call EnableProseMode()
    let w:ProseModeOn = 1
  else
    call DisableProseMode()
    let w:ProseModeOn = 0
  endif
endfu

command Prose call EnableProseMode()
command UnProse call DisableProseMode()
command ToggleProse call ToggleProseMode()
command NoConsole call NoConsole()

function ScratchBufferize()
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
endfu

" =======================
" Limelight 
" =======================

" Color name (:help cterm-colors) or ANSI code
" let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Color name (:help gui-colors) or RGB color
" let g:limelight_conceal_guifg = 'DarkGray'
" let g:limelight_conceal_guifg = '#777777'

" Default: 0.5
let g:limelight_default_coefficient = 0.1

" Number of preceding/following paragraphs to include (default: 0)
" let g:limelight_paragraph_span = 1

" Beginning/end of paragraph
"   When there's no empty line between the paragraphs
"   and each paragraph starts with indentation
let g:limelight_bop = '\n' " so it doesn't highlight two paragraphs when I'm on the blank line in between
" let g:limelight_eop = '\ze\n^\s'

" Highlighting priority (default: 10)
"   Set it to -1 not to overrule hlsearch
" let g:limelight_priority = -1

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
