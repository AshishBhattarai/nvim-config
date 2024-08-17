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
      vim.keymap.set('n', '<leader>f', builtin.current_buffer_fuzzy_find, {})
      vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
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
        return { 'treesitter', 'indent' }
      end
    },
    config = function(_, opts)
      require('ufo').setup(opts)
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    branch = 'master',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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
      vim.keymap.set('n', '<A-0>', ':NvimTreeFindFileToggle<CR>', { silent = true })
      vim.keymap.set('n', '<A-9>', ':NvimTreeFindFile<CR>', { silent = true })
      vim.keymap.set('n', '<A-8>', ':NvimTreeCollapse<CR>', { silent = true })
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
      local servers = { 'zls', 'tsserver', 'typos_lsp', 'glsl_analyzer', 'tailwindcss', 'lua_ls', 'rust_analyzer' }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup(require('coq').lsp_ensure_capabilities({}))
      end

      -- Lsp keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gu', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'gn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, 'ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<A-f>', vim.lsp.buf.format, opts)

          -- split jumps
          vim.keymap.set('n', '<leader>s', ':split | lua vim.lsp.buf.definition()<CR>', opts)
          vim.keymap.set('n', '<leader>v', ':vsplit | lua vim.lsp.buf.definition()<CR>', opts)
          vim.keymap.set('n', '<leader>.',
            [[<Cmd>let save_pos = getpos('.')<CR>:tabnew %<CR>:execute 'normal! ' . save_pos[1] . 'G' . save_pos[2] . '|'<CR>:lua vim.lsp.buf.definition()<CR>]],
            opts)
        end,
      });
      --
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      local dap, dapui = require('dap'), require('dapui');
      dapui.setup();

      -- adapters
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-dap', -- adjust as needed, must be absolute path
        name = 'lldb'
      }

      -- Debugger keymans
      vim.keymap.set('n', '<leader>dd', dap.continue);
      vim.keymap.set('n', '<leader>dc', dap.continue);
      vim.keymap.set('n', '<leader>dn', dap.step_over);
      vim.keymap.set('n', '<leader>di', dap.step_into);
      vim.keymap.set('n', '<leader>do', dap.step_out);
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint);
      vim.keymap.set('n', '<leader>dB', dap.clear_breakpoints);
      vim.keymap.set('n', '<leader>dl', dap.list_breakpoints);
      vim.keymap.set('n', '<leader>de', dap.repl.open);
      vim.keymap.set('n', '<leader>dr', dap.restart);
      vim.keymap.set('n', '<leader>dp', dap.pause);
      --
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      local harpoon = require('harpoon');
      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<A-S-o>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<A-o>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<A-i>", function() harpoon:list():next() end)

      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-s>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-.>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })
    end
  },
  {
    'mbbill/undotree',
    branch = 'master',
    config = function()
      vim.g.undotree_CustomUndotreeCmd = 'bot horizontal 32 new'
      vim.g.undotree_CustomDiffpanelCmd = 'belowright 12 new'
      vim.g.undotree_SetFocusWhenToggle = 1;

      vim.keymap.set("n", "<leader>ut", ':UndotreeToggle<CR>');
      vim.keymap.set("n", "<leader>up", ':UndotreePersistUndo<CR>');
    end
  }
}
