-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require('nvim-tree').setup({
  view = {
    mappings = {
      list = {
	{ key = "<C-s>", action = "split" },
	{ key = "d", action = "trash" },
      }
    }
  }
})

-- ufo fold
require('ufo').setup()

-- setup nvim-treesitter
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "javascript", "typescript", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
}

-- save
require("auto-save").setup()

-- presence
--require("presence"):setup({
--    -- General options
--    auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
--    neovim_image_text   = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
--    main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
--    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
--    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
--    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
--    enable_line_number  = false,                      -- Displays the current line number instead of the current project
--    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
--    buttons             = false,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
--    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
--    show_time           = true,                       -- Show the timer
--
--    -- Rich Presence text options
--    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
--    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
--    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
--    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
--    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
--    workspace_text      = "Working",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
--    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
--})

-- blankline
require("indent_blankline").setup {
    indentLine_enabled = 1,
    filetype_exclude = {
      "help",
      "terminal",
      "alpha",
      "packer",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "mason",
      "NvimTree",
      ""
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = true,
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = true,
}

-- telescope
require('telescope').setup({
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
      mappings = {
	i = {
	  ["<C-s>"] = "select_horizontal"
	}
    }
  },
})
