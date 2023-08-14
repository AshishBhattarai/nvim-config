" Load plugins with plug
call plug#begin('~/.config/nvim/plugged')
" Vim multi cursor
Plug 'terryma/vim-multiple-cursors'
" tabline theme
Plug 'itchyny/lightline.vim'
" fuzzy finder
" Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
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
" auto save
Plug 'Pocco81/auto-save.nvim'
" Discord precense
" Plug 'andweeb/presence.nvim'
" Adds indentation guides to all lines
Plug 'lukas-reineke/indent-blankline.nvim'

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

" vimspector
let g:vimspector_base_dir=expand('$HOME/.config/nvim/vimspector-config')

" use treesitter for blankline
let g:indent_blankline_use_treesitter = v:true

" ################ Vim configs ################################
set autowriteall
set autoread
set shiftwidth=2
set colorcolumn=120
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

" ################ KeyMaps ################################
" Coc keymaps
let g:coc_snippet_next = '<C-k>'
let g:coc_snippet_prev = '<C-j>'
imap <C-k> <Plug>(coc-snippets-expand-jump)

nnoremap <silent> gu :call <SID>show_documentation()<CR>
nmap <silent> <C-]> <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> go <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ca <Plug>(coc-codeaction-cursor)
" split jump
nmap <silent> gs :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> gx :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> g. :call CocAction('jumpDefinition', 'tabe')<CR>

" rename references
nmap <silent>gn <Plug>(coc-rename)

inoremap <silent><expr> <C-i> coc#refresh()

" use <tab> for trigger completion and select top option
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()

function! CheckBackSpace() abort
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

" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nmap <leader>dd :call vimspector#Launch()<CR>
nmap <leader>dt :call vimspector#ToggleBreakpoint()<CR>
nmap <Leader>dT :call vimspector#ClearBreakpoints()<CR>
nmap <leader>dq :VimspectorReset<CR>
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
tnoremap <S-esc> <C-\><C-N>

nnoremap <A-f> :Format<CR>

" Fzf
" nnoremap <A-p> :FzfLua files<CR>
" nnoremap <A-P> :FzfLua grep<CR>
" nnoremap <A-b> :FzfLua buffers<CR>
" Find files using Telescope command-line sugar.
nnoremap <A-p> <cmd>Telescope find_files<cr>
nnoremap <A-P> <cmd>Telescope live_grep<cr>
nnoremap <A-b> <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Floatterm bindings
let g:floaterm_keymap_new    = '<A-2>'
let g:floaterm_keymap_prev   = '<A-3>'
let g:floaterm_keymap_next   = '<A-4>'
let g:floaterm_keymap_toggle = '<A-1>'

" NERDCommenter
let g:NERDCreateDefaultMappings = 1

" lua config
lua require('config')
