vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact", "neorg" },
  callback = function()
    if vim.bo.modifiable and not vim.bo.readonly then
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_us"
      vim.opt_local.spelloptions = "camel"
      vim.opt_local.spellcapcheck = ""
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "norg", "neorg" },
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
