-- Markdown
return {
  --- Table mode
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
    cmd = { "TableModeToggle", "TableModeEnable", "TableModeDisable" },
    config = function()
      vim.g.table_mode_corner = "|"
    end,
  },

  --- Preview
  {
    "previm/previm",
    ft = "markdown",
    config = function()
      vim.g.previm_show_header = 0
      vim.g.previm_open_cmd = 'open -a "Google Chrome"'
    end,
  },
}

