local colors = {
  fg     = "#e6e1cf",
  muted  = "#3e4b59",
  panel  = "#14191f",
  bg     = "#0f1419",
  amber  = "#d8a657",
  red    = "#f07178",
  yellow = "#e0af68",
  blue   = "#36a3d9",
  green  = "#b8cc52",
}

local function hi(group, fg, bg, bold)
  vim.api.nvim_set_hl(0, group, {
    fg = fg,
    bg = bg,
    bold = bold or false,
  })
end

hi("StatusLine", colors.fg, colors.bg)
hi("StatusLineNC", colors.muted, colors.bg)

hi("SLGap", colors.muted, colors.bg)
hi("SLFile", colors.fg, colors.panel)
hi("SLMeta", colors.muted, colors.bg)
hi("SLPer", colors.fg, colors.panel)
hi("SLPos", colors.bg, colors.fg)

hi("SLInactiveGap", colors.muted, colors.bg)
hi("SLInactiveFile", colors.fg, colors.panel)
hi("SLInactiveMeta", colors.muted, colors.bg)
hi("SLInactivePer", colors.muted, colors.bg)
hi("SLInactivePos", colors.fg, colors.panel)


local modes = {
  n = { "NORMAL", colors.blue },
  i = { "INSERT", colors.green },
  v = { "VISUAL", colors.yellow },
  V = { "V-LINE", colors.yellow },
  ["\22"] = { "V-BLOCK", colors.yellow },
  R = { "REPLACE", colors.red },
  c = { "COMMAND", colors.amber },
  t = { "TERMINAL", colors.green },
}

function _G.statusline()
  local winid = vim.g.statusline_winid
  local filename = vim.fn.fnamemodify(
    vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(winid)),
    ":t"
  )
  if filename == "" then
    filename = "[No Name]"
  end

  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"
  local active = winid == vim.api.nvim_get_current_win()

  if not active then
    return table.concat({
      "%#SLInactiveFile# ", filename, " ",
      "%#SLInactiveGap#%=",
      "%#SLInactivePer# ", "%2p%%", " ",
      "%#SLInactivePos# ", "%3l:%-3c", " ",
    })
  end

  local mode = vim.api.nvim_get_mode().mode
  local spec = modes[mode] or modes[mode:sub(1, 1)] or modes.n

  return table.concat({
    "%#SLMode# ", spec[1], " ",
    "%#SLFile# ", filename, " ",
    "%#SLGap#%=",
    "%#SLMeta# ",
    vim.bo.fileformat, " | ",
    encoding, " | ",
    filetype, " ",
    "%#SLPer# ", "%3p%%", " ",
    "%#SLPos# ", "%3l:%-2c", " ",
  })
end

vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    local spec = modes[mode] or modes[mode:sub(1, 1)] or modes.n
    hi("SLMode", colors.bg, spec[2])
  end,
})

vim.o.statusline = "%!v:lua.statusline()"
vim.o.laststatus = 2
vim.o.showmode = false
