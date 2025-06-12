-- Git integration
return {
  {
    "airblade/vim-gitgutter",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
  },
}

