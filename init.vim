" Load plugins with plug
call plug#begin('~/.config/nvim/plugged')
" Vim multi cursor
Plug 'terryma/vim-multiple-cursors'
" Auto save
Plug 'Pocco81/AutoSave.nvim'
" Dox generator
Plug 'vim-scripts/DoxygenToolkit.vim'
" tabline theme
Plug 'itchyny/lightline.vim'
" fuzzy finder
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
" colorscheme
Plug 'sainnhe/gruvbox-material'
Plug 'ayu-theme/ayu-vim'
" project local config
Plug 'embear/vim-localvimrc'
" Comment shortcut
Plug 'preservim/nerdcommenter'
" AutoComplete+
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Semantic Highlight
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Surround
Plug 'tpope/vim-surround'
" Fast Fold
Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'
" rust
Plug 'rust-lang/rust.vim'
" debugger
Plug 'puremourning/vimspector'
" Nvim tree
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'kyazdani42/nvim-tree.lua'
" FloatTerm
Plug 'voldikss/vim-floaterm'
" git
Plug 'tpope/vim-fugitive'

call plug#end()

" ################ Plugin configs ################################
" localvimrc
let g:localvimrc_file_dir=".vim"

" vim-lsp-cxx-highlight
let g:lsp_cxx_hl_use_text_props = 1

" lightline
let g:lightline = {'colorscheme' : 'gruvbox_material'}

" coc
let g:coc_node_path=trim(system('which node'))

" Float term config
let g:floaterm_winblend = 30

" ################ Vim configs ################################
set autoread
set shiftwidth=2
set colorcolumn=100
highlight colorcolumn ctermbg=8 guibg=lightorange

set relativenumber
set splitright

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

" fold
set foldlevel=99
set foldcolumn=1
set foldenable

" coc
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" vimspector
let g:vimspector_base_dir=expand('$HOME/.config/nvim/vimspector-config')

" ################ KeyMaps ################################
" Coc keymaps
let g:coc_snippet_next = '<c-k>'
let g:coc_snippet_prev = '<c-j>'
imap <C-k> <Plug>(coc-snippets-expand-jump)

nnoremap <silent> gu :call <SID>show_documentation()<CR>
nmap <silent> <C-]> <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> go <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" split jump
nmap <silent> gs :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> gd :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> g. :call CocAction('jumpDefinition', 'tabe')<CR>

" rename references
nmap <silent>gn <Plug>(coc-rename)

inoremap <silent><expr> <C-space> coc#refresh()
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Overlay scroll
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" NerdTree Keymaps
map <A-0> :NvimTreeFindFileToggle<CR>
map <A-9> :NvimTreeFindFile<CR>
map <A-8> :NvimTreeCollapse<CR>

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
nmap <leader>dc :call vimspector#Continue()<CR>

" Move 1 more lines up or down in normal and visual selection modes.
nnoremap <A-j> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <A-j> :m '>+1<CR>gv=gv

" Esc to exit terminal insert mode
tnoremap <esc> <C-\><C-N>

nnoremap <A-p> :FzfLua files<CR>
nnoremap <A-P> :FzfLua grep<CR>
nnoremap <A-f> :Format<CR>

" Floatterm bindings
let g:floaterm_keymap_new    = '<A-2>'
let g:floaterm_keymap_prev   = '<A-3>'
let g:floaterm_keymap_next   = '<A-4>'
let g:floaterm_keymap_toggle = '<A-1>'

" lua config
lua require('config')
