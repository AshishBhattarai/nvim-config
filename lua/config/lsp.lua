vim.g.lsp_enable_inlay_hints = false

-- Define servers
local servers = {
  {
    name = "zls",
    options = {
      filetypes = { 'zig' }
    },
  },
  {
    name = "clangd",
    options = {},
  },
  {
    name = 'biome',
    options = {}
  },
  {
    name = "ts_ls",
    options = {
      settings = {
        implicitProjectConfiguration = {
          checkJs = true,
        },
      },
      on_attach = function(client, bufnr)
        -- Disable built-in formatter (use Prettier instead)
        client.server_capabilities.documentFormattingProvider = false
        vim.keymap.set("n", "<A-f>", ":RunPrettier<CR>", { noremap = true, silent = true, buffer = bufnr })
      end,
    },
  },
  {
    name = 'biome',
    options = {},
  },
  {
    name = "glsl_analyzer",
    options = {
      on_attach = function(client, _)
        -- Patch buggy cancel_request
        client.cancel_request = function() end
      end,
    },
  },
  {
    name = "lua_ls",
    options = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
  }
}

-- Setup servers
local blink_cmp = require('blink.cmp')
for _, server in ipairs(servers) do
  server.options.capabilities = blink_cmp.get_lsp_capabilities(server.options.capabilities)
  vim.lsp.config(server.name, server.options)
  vim.lsp.enable(server.name)
end

-- Keymaps for all LSP servers
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Enable inlay hints if globally enabled & supported
    if vim.g.lsp_enable_inlay_hints and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, noremap = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gu", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    if client.server_capabilities.documentFormattingProvider then
      vim.keymap.set("n", "<A-f>", vim.lsp.buf.format, opts)
    end

    -- Split jumps
    vim.keymap.set("n", "<leader>s", ":split | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set("n", "<leader>v", ":vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set(
      "n",
      "<leader>.",
      [[<Cmd>let save_pos = getpos('.')<CR>:tabnew %<CR>:execute 'normal! ' . save_pos[1] . 'G' . save_pos[2] . '|'<CR>:lua vim.lsp.buf.definition()<CR>]],
      opts
    )
  end,
})


-- Neovim 0.12 removed the old LSP user commands; add small compatibility wrappers.
local function get_lsp_config_names()
  local config_names = {}
  local configs = vim.lsp.config and vim.lsp.config._configs or {}

  for name, _ in pairs(configs) do
    table.insert(config_names, name)
  end

  table.sort(config_names)
  return config_names
end

local function lsp_names_for_current_buffer()
  local filetype = vim.bo.filetype
  local names = {}

  for _, name in ipairs(get_lsp_config_names()) do
    local ok, config = pcall(function()
      return vim.lsp.config[name]
    end)
    local filetypes = ok and config and config.filetypes or nil

    if not filetypes or vim.tbl_contains(filetypes, filetype) then
      table.insert(names, name)
    end
  end

  return names
end

local function parse_lsp_command_names(arg)
  local trimmed = vim.trim(arg or "")
  if trimmed == "" then
    return lsp_names_for_current_buffer()
  end

  return vim.split(trimmed, "%s+", { trimempty = true })
end

local function lsp_name_completion(arg_lead)
  local matches = {}
  for _, name in ipairs(get_lsp_config_names()) do
    if arg_lead == "" or vim.startswith(name, arg_lead) then
      table.insert(matches, name)
    end
  end
  return matches
end

vim.api.nvim_create_user_command("LspStart", function(opts)
  local names = parse_lsp_command_names(opts.args)
  if vim.tbl_isempty(names) then
    vim.notify("No matching LSP configs for the current buffer", vim.log.levels.WARN)
    return
  end

  vim.lsp.enable(names, true)
end, {
  nargs = "*",
  complete = lsp_name_completion,
  desc = "Compatibility wrapper for vim.lsp.enable()",
})

vim.api.nvim_create_user_command("LspStop", function(opts)
  local names = parse_lsp_command_names(opts.args)
  if vim.tbl_isempty(names) then
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if vim.tbl_isempty(clients) then
      vim.notify("No active LSP clients for the current buffer", vim.log.levels.WARN)
      return
    end

    for _, client in ipairs(clients) do
      client:stop(opts.bang and true or client.exit_timeout)
    end
    return
  end

  vim.lsp.enable(names, false)
end, {
  bang = true,
  nargs = "*",
  complete = lsp_name_completion,
  desc = "Compatibility wrapper for stopping LSP clients/configs",
})

vim.api.nvim_create_user_command("LspRestart", function(opts)
  local names = parse_lsp_command_names(opts.args)
  if vim.tbl_isempty(names) then
    vim.notify("No matching LSP configs for the current buffer", vim.log.levels.WARN)
    return
  end

  vim.lsp.enable(names, false)
  vim.defer_fn(function()
    vim.lsp.enable(names, true)
  end, 100)
end, {
  nargs = "*",
  complete = lsp_name_completion,
  desc = "Compatibility wrapper for restarting LSP clients/configs",
})

vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd("checkhealth vim.lsp")
end, {
  desc = "Compatibility wrapper for Neovim LSP health output",
})
