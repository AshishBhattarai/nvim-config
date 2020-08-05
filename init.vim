" Load plugins with plug
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'tikhomirov/vim-glsl'
Plug 'rhysd/vim-clang-format'
Plug 'terryma/vim-multiple-cursors'
Plug '907th/vim-auto-save'
Plug 'xavierd/clang_complete'
Plug 'sakhnik/nvim-gdb'
" A - for switching between source and header files
Plug 'vim-scripts/a.vim'
" ale - linter / autocompletion / formatter
Plug 'w0rp/ale'
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
call plug#end()

" ################ Plugin configs ################################
" clang_complete
" let g:clang_complete_loaded = 2
let g:clang_close_preview = 1
let g:clang_auto_select = 1
let g:clang_complete_auto = 0
let g:clang_library_path='/usr/lib64/libclang.so'
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
let g:clang_jumpto_back_key = '<C-[>'
let g:clang_jumpto_declaration_key = '<C-]>'
let g:clang_jumpto_declaration_in_preview_key = '<A-2>'

" ALE - linter
let g:ale_completion_enabled = 0
let g:ale_cpp_clang_executable = 'clang++'
let g:ale_cpp_clangtidy_executable = 'clang-tidy'
let g:ale_linters = {'cpp': ['clangtidy']}
let g:ale_cpp_clang_options = '-std=c++17 -O0 -Wextra -Wall -Wpedantic'
let g:ale_cpp_clangtidy_checks = ['cppcoreguidelines-*','clang-analyzer-*','modernize-*','performance-*']
let g:ale_cpp_clangtidy_options = '-O0 -Wextra -Wall -Wpedantic'
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
            \ "ColumnLimit" : 100,
            \ "AccessModifierOffset" : -2,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AllowShortFunctionsOnASingleLine" : "true",
            \}
nnoremap <A-f> <Esc>:ClangFormat<CR>
inoremap <A-f> <Esc>:ClangFormat<CR>

" A - header / source jump
nnoremap <A-1> :A<CR>
inoremap <A-1> <ESC>:A<CR>a

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
set colorcolumn=100
highlight colorcolumn ctermbg=8 guibg=lightgrey
set relativenumber

" Color scheme
syntax on
set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
colorscheme ayu

" Keymaps
map <A-0> :NERDTreeToggle<CR>
