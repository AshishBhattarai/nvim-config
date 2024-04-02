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
	["clients.tabnine.enabled"] = false,
	["clients.buffers.same_filetype"] = true,
	["keymap.recommended"] = false,
}

require("lazy").setup("plugins")
require("config/options")
require("config/keymaps")
