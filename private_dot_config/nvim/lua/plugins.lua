vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install packer is it's not installed
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- Plugins
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Cool dark themes
  use { 'nyoom-engineering/oxocarbon.nvim' }
  use { 'folke/tokyonight.nvim' }
  use { "catppuccin/nvim", as = "catppuccin" }
  use { 'xiyaowong/transparent.nvim',
        config = function()
          vim.cmd[[ TransparentEnable ]]
        end
      }

  -- Cool Japanese theme
  use "rebelot/kanagawa.nvim"

  -- File Tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      vim.cmd[[hi NvimTreeNormal guibg=none ctermbg=none]]
      require("nvim-tree").setup()
    end
  }

  -- LSP Server manager
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  -- Null-ls is used for formatters and linters
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }

  use 'jay-babu/mason-null-ls.nvim'

  -- Folder Tree view
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Indent line guide
  use 'lukas-reineke/indent-blankline.nvim'

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Autocomplete
  use 'hrsh7th/nvim-cmp'         -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'     -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip'         -- Snippets plugin

  -- Auto tags
  use 'windwp/nvim-ts-autotag'

  -- For blaming others for bugs
  use {
    'APZelos/blamer.nvim',
    config = function()
      vim.g.blamer_enabled = 1
    end
  }

  -- LSP Diagnosis in a window
  use {
    'kaputi/e-kaput.nvim',
    config = function()
      require('e-kaput').setup({})
      -- Window shows after 500ms
      vim.o.updatetime = 500
    end
  }

  -- FZF
  use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' }
 }

  -- If packer was just insalled then install all packages
  if is_bootstrap then
    require('packer').sync()
  end
end)

require("transparent").setup({
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLineNr', 'EndOfBuffer',
  },
  extra_groups = {
    "NvimTreeNormal" -- NvimTree
  },  exclude_groups = {}, -- table: groups you don't want to clear
})

require("luasnip").setup({
  history = true,
	region_check_events = "InsertEnter",
	delete_check_events = "TextChanged,InsertLeave",
})
