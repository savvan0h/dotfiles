return {
  -- Indent guides
  {
    "nathanaelkane/vim-indent-guides",
    init = function()
      vim.g.indent_guides_enable_on_vim_startup = 1
      vim.g.indent_guides_start_level = 2
      vim.g.indent_guides_guide_size = 1
    end,
  },

  -- Python indentation
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },

  -- Context filetype
  {
    "osyo-manga/vim-precious",
    dependencies = { "Shougo/context_filetype.vim" },
  },
  "Shougo/context_filetype.vim",

  -- Whitespace
  {
    "ntpeters/vim-better-whitespace",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function()
          vim.cmd("DisableWhitespace")
        end,
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false, -- Lazy loading is not supported
    build = ":TSUpdate",
    cond = function()
      return vim.fn.has("nvim") == 1
    end,
    config = function()
      -- See https://github.com/nvim-treesitter/nvim-treesitter/discussions/7535
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "java",
          "php",
          "python",
          "javascript",
          "typescript",
          "json",
          "yaml",
          "toml",
          "lua",
          "vim",
          "vimdoc",
          "markdown",
          "diff",
        },
        highlight = {
          enable = true,
          disable = {},
        },
      })
    end,
  },

  -- Various utilities
  {
    "rhysd/clever-f.vim",
    keys = { "f", "F", "t", "T" },
  },
  {
    "HerringtonDarkholme/yats.vim",
    ft = { "typescript", "typescriptreact" },
  },
  {
    "thinca/vim-visualstar",
    keys = { "*", "#" },
  },

  -- Rooter
  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = { ".git" }
    end,
  },
}
