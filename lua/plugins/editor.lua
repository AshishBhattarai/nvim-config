-- https://lazy.folke.io/spec#spec-setup
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
    dependencies = { 'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
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
      local telescope = require('telescope')

      telescope.setup(opts)
      telescope.load_extension("fzf")

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<A-p>', builtin.find_files, {})
      vim.keymap.set('n', '<A-P>', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>f', builtin.current_buffer_fuzzy_find, {})
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
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
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects'
    },
    opts = {
      highlight = {
        enable = true
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        }
      }
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts);
    end
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
      provider_selector = function(_, _, _)
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
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
          }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
        vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))
      end,
      view = {
        preserve_window_proportions = true,
      },
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)
      vim.keymap.set('n', '<A-0>', ':NvimTreeFindFileToggle<CR>', { silent = true })
      vim.keymap.set('n', '<A-9>', ':NvimTreeFindFile<CR>', { silent = true })
      vim.keymap.set('n', '<A-8>', ':NvimTreeCollapse<CR>', { silent = true })
    end
  },
  {
    'numToStr/FTerm.nvim',
    branch = 'master',
    opts = {
      border = 'double',
      dimensions = {
        height = 0.7, -- Height of the terminal window
        width = 0.7,  -- Width of the terminal window
      }
    },
    init = function()
      local fterm = require('FTerm')

      vim.api.nvim_create_user_command('FTermOpen', fterm.open, { bang = true })
      vim.api.nvim_create_user_command('FTermClose', fterm.close, { bang = true })
      vim.api.nvim_create_user_command('FTermExit', fterm.exit, { bang = true })
      vim.api.nvim_create_user_command('FTermToggle', fterm.toggle, { bang = true })

      vim.keymap.set('n', '<A-1>', fterm.toggle, { silent = true })
      vim.keymap.set('t', '<A-1>', fterm.toggle, { silent = true })

      -- vim.g.floaterm_winblend = 30
      -- vim.g.floaterm_keymap_new = '<A-2>'
      -- vim.g.floaterm_keymap_prev = '<A-3>'
      -- vim.g.floaterm_keymap_next = '<A-4>'
      -- vim.g.floaterm_keymap_toggle = '<A-1>'
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
      require('gitblame').setup()
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
    init = function()
      vim.g.coq_settings = {
        auto_start = 'shut-up',
        ["clients.snippets.warn"] = { "outdated" },
        ["display.ghost_text.enabled"] = false,
        ["keymap.recommended"] = false,
        ["keymap.manual_complete_insertion_only"] = true,
        ["keymap.repeat"] = ',',
        ["clients.buffers.same_filetype"] = true,
        ["clients.lsp.weight_adjust"] = 2.0,
        ["weights.prefix_matches"] = 20.0,
      }
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      local dap, dapui = require('dap'), require('dapui');
      dapui.setup();

      -- lldb_dap path
      local lldb_command
      if vim.loop.os_uname().sysname == "Linux" then
        lldb_command = '/usr/bin/lldb-dap'
      elseif vim.loop.os_uname().sysname == "Darwin" then
        lldb_command = '/opt/homebrew/opt/llvm/bin/lldb-dap'
      else
        print("Unsupported OS for dap.adapters.lldb.command configuration")
      end

      dap.adapters.lldb = {
        type = 'executable',
        command = lldb_command,
        name = 'lldb'
      }

      local js_debug_path = vim.env.JS_DEBUG_PATH
      if js_debug_path then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = 9229,
          executable = {
            command = "node",
            args = { js_debug_path, "9229" },
          }
        }
        dap.adapters["pwa-chrome"] = {
          type = "server",
          host = "localhost",
          port = 9228,
          executable = {
            command = "node",
            args = { js_debug_path, "9228" },
          }
        }
      end

      -- Debugger keymans
      vim.keymap.set('n', '<leader>dd', dap.continue);
      vim.keymap.set('n', '<leader>dc', dap.continue);
      vim.keymap.set('n', '<leader>dn', dap.step_over);
      vim.keymap.set('n', '<leader>di', dap.step_into);
      vim.keymap.set('n', '<leader>do', dap.step_out);
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint);
      vim.keymap.set('n', '<leader>dB', dap.clear_breakpoints);
      vim.keymap.set('n', '<leader>dl', dap.list_breakpoints);
      vim.keymap.set({ 'n', 'v' }, '<leader>de', dapui.eval);
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
  },
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            icon_preset = "varied",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/Documents/notes/neorg/notes",
              office = "~/Documents/notes/neorg/kittl",
              project = "~/Documents/notes/neorg/projekt_inception",
            },
            default_workspace = "notes",
          },
        },
      },
    },
    config = true,
  }
}
