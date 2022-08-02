-- setup nvim-tree
local tree_cb = require'nvim-tree.config'.nvim_tree_callback

require('nvim-tree').setup({
  view = {
    mappings = {
      list = {
	{ key = "<C-s>", cb = tree_cb('split') }
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

    additional_vim_regex_highlighting = false,
  },
}

