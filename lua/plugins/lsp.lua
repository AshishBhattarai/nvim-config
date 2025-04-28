vim.g.lsp_enable_inlay_hints = false;

local servers = {
  {
    name = 'typos_lsp',
    root_dir = function()
      return vim.loop.cwd()
    end,
    settings = {},
  },
  {
    name = 'zls',
    settings = {},
  },
  {
    name = 'ts_ls',
    settings = {
      implicitProjectConfiguration = {
        checkJs = true
      }
    },
  },
  {
    name = 'glsl_analyzer',
    settings = {},
  },
  -- {
  --   name = 'tailwindcss',
  --   settings = {},
  -- },
  {
    name = 'lua_ls',
    settings = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    },
  },
  {
    name = 'rust_analyzer',
    settings = {},
  },
  {
    name = 'clangd',
    settings = {}
  }
}

return {
  'neovim/nvim-lspconfig',
  branch = 'master',
  config = function()
    local lspconfig = require('lspconfig')

    for _, server in ipairs(servers) do
      lspconfig[server.name].setup(require('coq').lsp_ensure_capabilities(server.settings))
    end

    -- Lsp keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- client.name - server name ie 'zls', 'tsserver', ....

        -- ts_ls
        if client.name == "ts_ls" then
          -- Disable default formatter
          client.server_capabilities.documentFormattingProvider = false;
          -- Use prettier on <A-f>
          vim.keymap.set('n', '<A-f>', ':RunPrettier<CR>', { noremap = true, silent = true, buffer = ev.buf })
        elseif client.name == "glsl_analyzer" then
          client.cancel_request = function()
            -- glsl_analyzer doesn't handle cancel_request proplery yet
            -- https://github.com/nolanderc/glsl_analyzer/issues/68
          end
        end


        -- Enable inlay hints
        if vim.g.lsp_enable_inlay_hints and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, noremap = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gu', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, 'ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set('n', '<A-f>', vim.lsp.buf.format, opts)
        end

        -- split jumps
        vim.keymap.set('n', '<leader>s', ':split | lua vim.lsp.buf.definition()<CR>', opts)
        vim.keymap.set('n', '<leader>v', ':vsplit | lua vim.lsp.buf.definition()<CR>', opts)
        vim.keymap.set('n', '<leader>.',
          [[<Cmd>let save_pos = getpos('.')<CR>:tabnew %<CR>:execute 'normal! ' . save_pos[1] . 'G' . save_pos[2] . '|'<CR>:lua vim.lsp.buf.definition()<CR>]],
          opts)
      end,
    });
  end
}
