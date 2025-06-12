-- LSP
return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.opt.updatetime = 100
      vim.g.coc_global_extensions = {
        "coc-css",
        "coc-eslint",
        "coc-go",
        "coc-html",
        "coc-java",
        "coc-json",
        "coc-phpls",
        "coc-pyright",
        "coc-tsserver",
        "coc-pretty-ts-errors",
        "coc-prettier",
        "coc-yaml"
      }

      -- Don't pass messages to |ins-completion-menu|.
      vim.opt.shortmess:append("c")

      -- Always show the signcolumn
      if vim.fn.has("patch-8.1.1564") == 1 then
        vim.opt.signcolumn = "number"
      else
        vim.opt.signcolumn = "yes"
      end

      -- Key mappings
      vim.keymap.set("i", "<C-n>", [[coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"]], { expr = true })
      vim.keymap.set("i", "<C-p>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"]], { expr = true })
      vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], { expr = true })
      vim.keymap.set("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], { expr = true, silent = true })

      -- Trigger completion
      if vim.fn.has('nvim') == 1 then
        vim.keymap.set("i", "<c-space>", "coc#refresh()", { expr = true, silent = true })
      else
        vim.keymap.set("i", "<c-@>", "coc#refresh()", { expr = true, silent = true })
      end

      -- Navigate diagnostics
      vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, nowait = true })
      vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true, nowait = true })

      -- GoTo code navigation
      vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true, nowait = true })
      vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true, nowait = true })
      vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true, nowait = true })
      vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true, nowait = true })

      -- Use K to show documentation
      vim.keymap.set("n", "K", function()
        if vim.fn.CocAction("hasProvider", "hover") then
          vim.fn.CocActionAsync("doHover")
        else
          vim.fn.feedkeys("K", "in")
        end
      end, { silent = true })

      -- Symbol renaming
      vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)")

      -- Formatting
      vim.keymap.set({"x", "n"}, "<leader>f", "<Plug>(coc-format-selected)")

      -- Code actions
      vim.keymap.set({"x", "n"}, "<leader>a", "<Plug>(coc-codeaction-selected)")
      vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)")
      vim.keymap.set("n", "<leader>as", "<Plug>(coc-codeaction-source)")
      vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)")

      -- Refactoring
      vim.keymap.set("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      vim.keymap.set({"x", "n"}, "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Code lens
      vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)")

      -- Text objects
      vim.keymap.set({"x", "o"}, "if", "<Plug>(coc-funcobj-i)")
      vim.keymap.set({"x", "o"}, "af", "<Plug>(coc-funcobj-a)")
      vim.keymap.set({"x", "o"}, "ic", "<Plug>(coc-classobj-i)")
      vim.keymap.set({"x", "o"}, "ac", "<Plug>(coc-classobj-a)")

      -- Scroll float windows
      if vim.fn.has('nvim-0.4.0') == 1 or vim.fn.has('patch-8.2.0750') == 1 then
        vim.keymap.set("n", "<C-f>", [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], { expr = true, silent = true, nowait = true })
        vim.keymap.set("n", "<C-b>", [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], { expr = true, silent = true, nowait = true })
        vim.keymap.set("i", "<C-f>", [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"]], { expr = true, silent = true, nowait = true })
        vim.keymap.set("i", "<C-b>", [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"]], { expr = true, silent = true, nowait = true })
        vim.keymap.set("v", "<C-f>", [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], { expr = true, silent = true, nowait = true })
        vim.keymap.set("v", "<C-b>", [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], { expr = true, silent = true, nowait = true })
      end

      -- Selection ranges
      vim.keymap.set({"n", "x"}, "<C-s>", "<Plug>(coc-range-select)", { silent = true })

      -- Commands
      vim.api.nvim_create_user_command("Format", function() vim.fn.CocActionAsync("format") end, {})
      vim.api.nvim_create_user_command("Fold", function(opts) vim.fn.CocAction("fold", opts.args) end, { nargs = "?" })
      vim.api.nvim_create_user_command("OR", function() vim.fn.CocActionAsync("runCommand", "editor.action.organizeImport") end, {})

      -- CoCList mappings
      vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<cr>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>e", ":<C-u>CocList extensions<cr>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>c", ":<C-u>CocList commands<cr>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>o", ":<C-u>CocList outline<cr>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>s", ":<C-u>CocList -I symbols<cr>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>m", ":<C-u>CocNext<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>n", ":<C-u>CocPrev<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>p", ":<C-u>CocListResume<CR>", { silent = true, nowait = true })

      -- Jump to previously visited location
      vim.keymap.set("n", "<C-l>", "<C-i>")

      -- Auto commands
      vim.cmd([[
        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        function! ShowDocumentation()
          if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
          else
            call feedkeys('K', 'in')
          endif
        endfunction
      ]])

      vim.api.nvim_create_augroup("mygroup", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = "mygroup",
        pattern = {"typescript", "json"},
        callback = function()
          vim.opt_local.formatexpr = "CocAction('formatSelected')"
        end,
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.fn.CocActionAsync("highlight")
        end,
      })
    end,
  },
}

