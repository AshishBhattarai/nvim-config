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
