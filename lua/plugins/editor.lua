return {
  {
    'sainnhe/gruvbox-material',
    branch = 'master',
    config = function()
      vim.opt.termguicolors = true
      vim.g.gruvbox_material_background = 'hard'
      vim.cmd 'colorscheme gruvbox-material'
    end
  },
  {
    'ayu-theme/ayu-vim',
    branch = 'master',
  },
  {
    'itchyny/lightline.vim',
    branch = 'master',
    config = function()
      vim.g.lightline = {
	      colorscheme = 'ayu_dark'
      }
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
      	selection_strategy = "reset",
      	sorting_strategy = "ascending",
      	layout_strategy = "horizontal",
      	layout_config = {
      	  horizontal = {
      	    prompt_position = "top",
      	    preview_width = 0.55,
      	    results_width = 0.8,
      	  },
      	  vertical = {
      	    mirror = false,
      	  },
      	  width = 0.87,
      	  height = 0.80,
      	  preview_cutoff = 120,
      	},
        path_display = {
          filename_first = {
            reverse_directories = false
          }
        },
        mappings = {
          i = {
      	    ["<C-s>"] = "select_horizontal"
          }
      	}
      },
    },
    config = function(_, opts)
      require('telescope').setup(opts)

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<A-p>', builtin.find_files, {})
      vim.keymap.set('n', '<A-P>', builtin.live_grep, {})
      vim.keymap.set('n', '<A-b>', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end
  },
  {
    'numToStr/Comment.nvim',
    branch = 'master',
    config = function()
        require("Comment").setup()
    end
  },
  {
    'rmagatti/auto-session',
    branch = 'main',
    opts = {
        auto_save_enabled = true,
        auto_restore_enabled = true,
    },
    config = function(_, opts)
        require("auto-session").setup(opts)
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate'
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup()
    end
  },
  {
    'kevinhwang91/nvim-ufo',
    branch = 'main',
    dependencies = { 'kevinhwang91/promise-async' },
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
      	return {'treesitter', 'indent'}
      end
    },
    config = function(_, opts)
      require('ufo').setup(opts)
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    branch = 'master',
    dependencies= { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    opts = {
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
        vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))
      end
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)
      vim.keymap.set('n', '<A-0>', ':NvimTreeFindFileToggle<CR>', {silent = true})
      vim.keymap.set('n', '<A-9>', ':NvimTreeFindFile<CR>', {silent = true})
      vim.keymap.set('n', '<A-8>', ':NvimTreeCollapse<CR>', {silent = true})
    end
  },
  {
    'voldikss/vim-floaterm', 
    branch = 'master',
    init = function()
      vim.g.floaterm_winblend = 30
      vim.g.floaterm_keymap_new = '<A-2>'
      vim.g.floaterm_keymap_prev = '<A-3>'
      vim.g.floaterm_keymap_next = '<A-4>'
      vim.g.floaterm_keymap_toggle = '<A-1>'
    end
  },
  {
    'tpope/vim-fugitive',
    branch = 'master'
  },
  {
    'f-person/git-blame.nvim',
    branch = 'master',
    config = function()
      require('gitblame').setup();
    end
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    branch = 'master',
    opts = {
      exclude = {
        filetypes = {
      	"help",
      	"terminal",
      	"alpha",
      	"packer",
      	"lspinfo",
      	"TelescopePrompt",
      	"TelescopeResults",
        "gitcommit",
        "man",
      	"NvimTree",
      	""
      },
        buftypes = { "terminal", "nofile", "prompt" },
      }
    },
    config = function(_, opts)
      require('ibl').setup(opts)
    end
  },
  {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    build = 'python3 -m coq deps',
    dependencies = { 'ms-jpq/coq.artifacts', 'ms-jpq/coq.thirdparty' },
  },
  {
    'neovim/nvim-lspconfig',
    branch = 'master',
    config = function()
      local lspconfig = require('lspconfig')
      local servers = { 'zls', 'tsserver', 'typos_lsp', 'tailwindcss' }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup(require('coq').lsp_ensure_capabilities({}))
      end
    end
  }, 
  {
    'rcarriga/nvim-dap-ui', 
    dependencies = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'},
    config = function()
      require('dapui').setup();
    end
  }
}
