return {
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    }
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    cmd = "TSUpdate",
  },

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },

  -- LSP {{
    {
      "williamboman/mason.nvim",
      build = function()
        pcall(vim.cmd, "MasonUpdate")
      end,
    },
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",

    "LukasPietzschmann/telescope-tabs",

    "jose-elias-alvarez/null-ls.nvim",
    "jay-babu/mason-null-ls.nvim",
    "glepnir/lspsaga.nvim",

    -- Autocompletion {{
      "hrsh7th/nvim-cmp",     -- Required
      "hrsh7th/cmp-nvim-lsp", -- Required
      "L3MON4D3/LuaSnip",     -- Required
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "ray-x/lsp_signature.nvim",

    -- }}

    {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v4.x",
    },
  -- }}

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  { -- Web Dev stuff
    "norcalli/nvim-colorizer.lua",
    "windwp/nvim-ts-autotag",
  },

  "windwp/nvim-autopairs",

  "folke/which-key.nvim",

  -- Colorschemes {
    "rebelot/kanagawa.nvim",
    "folke/tokyonight.nvim",
  -- }

  "simrat39/rust-tools.nvim",

  "https://git.sr.ht/~p00f/clangd_extensions.nvim",

  "junegunn/vim-easy-align",

  "numToStr/Comment.nvim",

  "chentoast/marks.nvim",

  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",

  "smjonas/inc-rename.nvim",

  -- For a better JSX/TSX indentation experience (doesn't need to be `require()`'d in init.lua)
  "MaxMEllon/vim-jsx-pretty",

  -- TODO: https://github.com/danymat/neogen
}
