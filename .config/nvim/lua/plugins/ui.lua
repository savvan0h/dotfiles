return {
  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper',
        config = {
          header = {
            '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
            '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
            '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
            '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
            '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
            '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
          },
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },

  -- Window management
  {
    "simeji/winresizer",
    keys = "<C-T>",
    init = function()
      vim.g.winresizer_start_key = "<C-T>"
    end,
  },

  -- File explorer
  {
    "scrooloose/nerdtree",
    cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
    keys = {
      { "<C-e>", ":call MyNerdToggle()<CR>", desc = "Toggle NERDTree (find current file)", silent = true }
    },
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeWinSize = 28
      vim.cmd([[
        function MyNerdToggle()
          if &filetype == 'nerdtree' || exists("g:NERDTree") && g:NERDTree.IsOpen()
            :NERDTreeToggle
          else
            :NERDTreeFind
          endif
        endfunction
      ]])
    end,
  },

  -- Status line
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    config = function()
      vim.opt.laststatus = 3
      vim.g.airline_theme = "tomorrow"
      vim.g["airline#extensions#tabline#enabled"] = 1
      vim.g["airline#extensions#tabline#formatter"] = "unique_tail"
      vim.g["airline#extensions#hunks#enabled"] = 0
      vim.g.airline_highlighting_cache = 1
    end,
  },
  "vim-airline/vim-airline-themes",

  -- Icons and UI (for NERDTree, vim-airline, etc.)
  {
    "ryanoasis/vim-devicons",
    event = "VeryLazy",
  },

  -- Noice UI
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          background_colour = "#000000",
        },
      },
    },
    opts = {
      presets = {
        command_palette = true,
      },
    },
  },
}
