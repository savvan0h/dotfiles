return {
  -- Browser integration
  {
    "tyru/open-browser.vim",
    keys = {
      { "gx", "<Plug>(openbrowser-smart-search)", mode = { "n", "v" }, desc = "Open browser" }
    },
  },

  -- Peek lines
  {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup()
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Telescope live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Telescope buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Telescope help tags" },
    },
    opts = {
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
        },
        live_grep = {
          additional_args = { "--fixed-strings", "--hidden", "-g", "!.git" },
        },
      },
    },
  },
}
