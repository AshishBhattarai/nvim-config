local tab_colors = {
  bg        = "#0f1419",
  panel     = "#14191f",
  fg        = "#e6e1cf",
  inactive  = "#3e4b59",
  accent    = "#e6b673",
  accent_fg = "#14191f",
}

vim.api.nvim_set_hl(0, "TabLine", {
  fg = tab_colors.fg,
  bg = tab_colors.panel,
})

vim.api.nvim_set_hl(0, "TabLineSel", {
  fg = tab_colors.accent_fg,
  bg = tab_colors.accent,
  bold = true,
})

vim.api.nvim_set_hl(0, "TabLineFill", {
  fg = tab_colors.inactive,
  bg = tab_colors.bg,
})

local function tab_label(tabnr)
  local bufnr = vim.fn.tabpagebuflist(tabnr)[vim.fn.tabpagewinnr(tabnr)]
  local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
  if name == "" then
    return "[No Name]"
  end
  return name:gsub("%%", "%%%%")
end

function _G.tabline()
  local current = vim.fn.tabpagenr()
  local last = vim.fn.tabpagenr("$")
  local parts = {}

  for tabnr = 1, last do
    parts[#parts + 1] = tabnr == current and "%#TabLineSel#" or "%#TabLine#"
    parts[#parts + 1] = "%" .. tabnr .. "T"
    parts[#parts + 1] = " " .. tabnr .. " " .. tab_label(tabnr) .. " "
  end

  parts[#parts + 1] = "%#TabLineFill#%T"
  return table.concat(parts)
end

vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.tabline()"
