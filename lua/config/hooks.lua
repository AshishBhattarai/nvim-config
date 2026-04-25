vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "c",
    "cpp",
    "zig",
    "javascript",
    "javascriptreact",
    "json",
    "lua",
    "markdown",
    "query",
    "toml",
    "typescript",
    "typescriptreact",
    "vim",
    "yaml",
  },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

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
  pattern = "norg",
  callback = function(ev)
    vim.treesitter.start(ev.buf)
    vim.wo[0][0].foldmethod = "expr"
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
