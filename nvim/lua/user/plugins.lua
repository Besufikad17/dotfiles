local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  git = {
    clone_timeout = 300, -- Timeout, in seconds, for git clones
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use { "wbthomason/packer.nvim" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs" } -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim" }
  use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use { "kyazdani42/nvim-web-devicons" }
  use { "kyazdani42/nvim-tree.lua" }
  use { "akinsho/bufferline.nvim"}
  use { "moll/vim-bbye" }
  use { "nvim-lualine/lualine.nvim" }
  use { "akinsho/toggleterm.nvim" }
  use { "ahmedkhalf/project.nvim" }
  use { "lewis6991/impatient.nvim" }
  use { "lukas-reineke/indent-blankline.nvim", main = "ibl" }
  use { "goolord/alpha-nvim" }
  use { "windwp/nvim-ts-autotag" }
  use { "theprimeagen/harpoon" }
  use { "mbbill/undotree" }
  use { "junegunn/fzf.vim" }
  use { "junegunn/fzf" }

  -- Colorschemes
  use { "EdenEast/nightfox.nvim" }
  use { "folke/tokyonight.nvim" }
  use { "lunarvim/darkplus.nvim" }
  use { "ellisonleao/gruvbox.nvim" }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp"} -- The completion plugin
  use { "hrsh7th/cmp-buffer" } -- buffer completions
  use { "hrsh7th/cmp-path"} -- path completions
  use { "saadparwaiz1/cmp_luasnip"} -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp"}
  use { "hrsh7th/cmp-nvim-lua"}

  -- snippets
  use { "L3MON4D3/LuaSnip" } --snippet engine
  use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use

  -- LSP
  -- use { "williamboman/nvim-lsp-installer", commit = "e9f13d7acaa60aff91c58b923002228668c8c9e6" } -- simple to use language server installer
  use { "neovim/nvim-lspconfig" } -- enable LSP
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
  use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters
  use { "RRethy/vim-illuminate" }
  use { 'mhartington/formatter.nvim' }
  
  -- Telescope
  use { "nvim-telescope/telescope.nvim" }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter"
  }

  -- Git
  use { "lewis6991/gitsigns.nvim" }

  -- DAP
  use { "mfussenegger/nvim-dap" }
  use { "rcarriga/nvim-dap-ui"  }
  use { "ravenxrz/DAPInstall.nvim" }

  -- language
  use { "ianks/vim-tsx" }
  use { "pangloss/vim-javascript" }
  use { "peitalin/vim-jsx-typescript" }
  use { "leafgarland/typescript-vim" }
  use { "styled-components/vim-styled-components" }
  use {'neoclide/coc.nvim', branch = 'release'} 
  use { "wakatime/vim-wakatime" }
  use { "josa42/coc-go" }
  use { "pantharshit00/coc-prisma" }
  use { "prisma/vim-prisma" }
  use { 'dart-lang/dart-vim-plugin' }
  use { 'thosakwe/vim-flutter' }
  use { 'natebosch/vim-lsc' }
  use { 'natebosch/vim-lsc-dart'}
  use {"ellisonleao/glow.nvim", config = function() require("glow").setup() end} 
  use {'othree/html5.vim'} 
  use {'evanleck/vim-svelte'}
  use {'leafOfTree/vim-svelte-plugin'}
  use {
    'akinsho/flutter-tools.nvim',
    requires = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
  }
  use {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require("fidget").setup {
        -- options
      }
    end,
  }

  -- php 
  use { "phpactor/phpactor" }
  use { 'ncm2/ncm2' }
  use { 'roxma/nvim-yarp' }
  use { 'phpactor/ncm2-phpactor' }

  -- java and spring
  use { 'mfussenegger/nvim-jdtls' }
  use { 'mfussenegger/nvim-dap' }
  use { 'folke/trouble.nvim' }

  -- transparency
  use { "xiyaowong/transparent.nvim" }
  
  -- linting
  use('MunifTanjim/prettier.nvim')
  use { 'jose-elias-alvarez/null-ls.nvim'}
  use { 'MunifTanjim/eslint.nvim'}
  use { "elentok/format-on-save.nvim" }
  
  -- refactoring 
  use { 'nvim-lua/plenary.nvim' }
  use { 'nvim-pack/nvim-spectre' }

  -- note taking 
  use { 'skykosiner/wiki.nvim'}
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use {
    "nvim-neorg/neorg", -- This is the important bit!
    config = function()
        require("neorg").setup {
            load = {
              ["core.defaults"] = {},
              ["core.dirman"] = {
                config = {
                  workspaces = {
                      work = "~/notes/work",
                      home = "~/notes/home",
                  }
                }
              }
            }
        }
    end,
  }
  
  --laravel 
  use { "adalessa/laravel.nvim" }

  -- git lense 
  -- use { "Eliot00/git-lens.vim" }

 -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
