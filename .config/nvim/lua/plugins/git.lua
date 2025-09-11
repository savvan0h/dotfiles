-- Git integration
return {
  {
    "airblade/vim-gitgutter",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit" },
    config = function()
      -- Force vertical diff
      vim.opt.diffopt = vim.opt.diffopt + "vertical"
    end
  },
}
