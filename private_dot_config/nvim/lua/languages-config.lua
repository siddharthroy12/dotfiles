-- Setup Autocomplete
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()

require("mason-lspconfig").setup {
  -- LSP Servers that I need
  ensure_installed = { "bashls", "clangd", "cssls", "html", "jsonls", "vtsls", "lua_ls", "emmet_ls", "rust_analyzer", "jedi_language_server"},

  automatic_installation = true,
}

-- Formatters I need
require("mason-null-ls").setup({
  ensure_installed = { "prettierd", "prettier" },
  automatic_installation = true,
  automatic_setup = true,
  handlers = {}
})

-- Null ls setup
require("null-ls").setup()

-- Setup Treesitter
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "html", "css", "python", "javascript", "typescript",
    "tsx", "json" },

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  -- Auto tag
  auto_tag = {
    enable = true
  },

  highlight = {
    enable = true
  },
}

-- Setup auto tag
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    virtual_text = {
      spacing = 5,
      severity_limit = 'Warning',
    },
    update_in_insert = true,
  }
)

-- Format file with null-ls
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format({
      bufnr = bufnr,
      filter = function(client)
        return client.name == "null-ls"
      end
    })
    print("File formatted")
  end, { desc = 'Format current buffer with LSP' })
end

-- Format with lsp on save
vim.cmd('autocmd BufWritePre * silent! Format')

-- Setup LSPs
require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      -- Setting capabilities from nvim-cmp
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,

  ['lua_ls'] = function()
    require('lspconfig').lua_ls.setup{
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    }
  end
}

require('nvim-ts-autotag').setup({
})

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
