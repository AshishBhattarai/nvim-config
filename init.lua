-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.coq_settings = { 
  auto_start = 'shut-up', 
  ["clients.snippets.warn"] = {"outdated"},
	["display.ghost_text.enabled"] = false,
	["keymap.recommended"] = false,
  ["clients.buffers.same_filetype"] = true,
  ["clients.lsp.weight_adjust"] = 2.0,
  ["weights.prefix_matches"] = 20.0,
}

require("lazy").setup("plugins")
require("config.options")
require("config.keymaps")
require("config.commands")
