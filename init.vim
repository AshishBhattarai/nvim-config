" Load plugins with plug
call plug#begin('~/.config/nvim/plugged')
" Project director explorer
Plug 'scrooloose/nerdtree'
" GLSL highlight
Plug 'tikhomirov/vim-glsl'
" ClangFormat
Plug 'rhysd/vim-clang-format'
" Vim multi cursor
Plug 'terryma/vim-multiple-cursors'
" Auto save
Plug '907th/vim-auto-save'
" Dox generator
Plug 'vim-scripts/DoxygenToolkit.vim'
" ale - linter / autocompletion / formatter
Plug 'AshishBhattarai/ale'
" tabline theme
Plug 'itchyny/lightline.vim'
" fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
" colorscheme
Plug 'sainnhe/gruvbox-material'
Plug 'ayu-theme/ayu-vim'
" project local config
Plug 'LucHermitte/local_vimrc'
Plug 'LucHermitte/lh-vim-lib'
" Comment shortcut
Plug 'preservim/nerdcommenter'
" AutoComplete+
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Semantic Highlight
Plug 'jackguo380/vim-lsp-cxx-highlight'
" Surround
Plug 'tpope/vim-surround'
" Fast Fold
Plug 'Konfekt/FastFold'
" Better Fold
Plug 'pseewald/vim-anyfold'
" Get history and commit messages
Plug 'rhysd/git-messenger.vim'
" rust
Plug 'rust-lang/rust.vim'
" debugger
Plug 'puremourning/vimspector'
call plug#end()

" ################ Plugin configs ################################

" vim-lsp-cxx-highlight
let g:lsp_cxx_hl_use_text_props = 1

" ALE - linter
let g:ale_completion_enabled = 0
let g:ale_cpp_clangtidy_executable = 'clang-tidy'
let g:ale_linters = {'cpp': ['clangtidy'], 'c': ['clangtidy']}
let g:ale_cpp_clangtidy_checks = ['clang-analyzer-*','modernize-*','performance-*']
let g:ale_cpp_clangtidy_options = '-std=c++20 -Wall -Wextra -Wpedantic -Wmove'
"let g:ale_cpp_cpplint_options = ''
"let g:ale_cpp_gcc_options = ''
"let g:ale_cpp_clangcheck_options = ''
"let g:ale_cpp_cppcheck_options = '--project=build/compile_commands.json --enable=all'

" Clang format - auto formatting
let g:clang_format#command = 'clang-format'
let g:clang_format#style_options = {
            \ "BasedOnStyle" : "llvm",
            \ "BreakBeforeBraces" : "Attach",
            \ "UseTab" : "Never",
            \ "TabWidth" : 2,
            \ "IndentWidth" : 2,
            \ "ColumnLimit" : 120,
            \ "AccessModifierOffset" : -2,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AllowShortFunctionsOnASingleLine" : "true",
            \}

" enable AutoSave on Vim startup
let g:auto_save = 1 
let g:auto_save_events = ["InsertLeave", "TextChanged"]

" lightline
let g:lightline = {'colorscheme' : 'gruvbox_material'}


" ################ Vim configs ################################
set autoread
set shiftwidth=2
set colorcolumn=120
highlight colorcolumn ctermbg=8 guibg=lightgrey
set relativenumber

" Color scheme
syntax on
set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
colorscheme ayu

" persistent undo
silent !mkdir -p ~/.local/share/nvim/undo
silent !mkdir -p ~/.local/share/nvim/swap
set undofile                 "turn on the feature  
set undodir=$HOME/.local/share/nvim/undo  "directory where the undo files will be stored
set dir=$HOME/.local/share/nvim/swap
set fsync " ;-; lost 2 files on poweroutage

" copy from clipboard
set clipboard=unnamedplus

" any fold
filetype plugin indent on
autocmd Filetype * AnyFoldActivate               " activate for all filetypes
set foldlevel=99

" ################ KeyMaps ################################
" Coc keymaps
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> <c-]> <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

let g:coc_snippet_next = '<c-k>'
let g:coc_snippet_prev = '<c-j>'
imap <C-k> <Plug>(coc-snippets-expand-jump)

" NerdTree Keymaps
map <A-0> :NERDTreeToggle<CR>
map <A-9> :NERDTreeFind<CR>

" header / source jump
nnoremap <A-1> :CocCommand clangd.switchSourceHeader<CR>
inoremap <A-1> :CocCommand clangd.switchSourceHeader<CR>
nnoremap <A-2> :CocCommand clangd.symbolInfo<CR>
inoremap <A-2> :CocCommand clangd.symbolInfo<CR>

" auto pair budget
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nmap <leader>dd :call vimspector#Launch()<CR>
nmap <leader>db :call vimspector#ToggleBreakpoint()<CR>
nmap <leader>dx :VimspectorReset<CR>
nmap <leader>de :VimspectorEval
nmap <leader>dw :VimspectorWatch
" nmap <leader>do :VimspectorShowOutput

nmap <leader>ds :call vimspector#Stop()<CR>
nmap <leader>dp :call vimspector#Pause()<CR>
nmap <leader>dr :call vimspector#Restart()<CR>

nmap <leader>dn :call vimspector#StepOver()<CR>
nmap <leader>di :call vimspector#StepInto()<CR>
nmap <leader>do :call vimspector#StepOut()<CR>

" clang-format
autocmd FileType c,cpp,objc,frag,vert,glsl,geom nnoremap <A-f> <Esc>:ClangFormat<CR>
autocmd FileType c,cpp,objc,frag,vert,glsl,geom inoremap <A-f> <Esc>:ClangFormat<CR>
