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
Plug 'octol/vim-cpp-enhanced-highlight'
" project local config
Plug 'LucHermitte/lh-vim-lib'
Plug 'LucHermitte/local_vimrc'
" Comment shortcut
Plug 'preservim/nerdcommenter'
" AutoComplete+
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" ################ Plugin configs ################################

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

" cpp-syntax
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
" slow
" let g:cpp_experimental_template_highlight = 1 
" let g:cpp_concepts_highlight = 1

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
silent !mkdir -p ~/.vim/undo
set undofile                 "turn on the feature  
set undodir=$HOME/.vim/undo  "directory where the undo files will be stored

" copy from clipboard
set clipboard=unnamedplus

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

" A - header / source jump
nnoremap <A-1> :CocCommand clangd.switchSourceHeader<CR>
inoremap <A-1> :CocCommand clangd.switchSourceHeader<CR>
nnoremap <A-2> :CocCommand clangd.symbolInfo<CR>
inoremap <A-2> :CocCommand clangd.symbolInfo<CR>

" clang-format
autocmd FileType c,cpp,objc,frag,vert,glsl,geom nnoremap <A-f> <Esc>:ClangFormat<CR>
autocmd FileType c,cpp,objc,frag,vert,glsl,geom inoremap <A-f> <Esc>:ClangFormat<CR>
