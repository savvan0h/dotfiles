return {
  -- Colorscheme
  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[
        colorscheme gruvbox
        set background=dark
        set t_Co=256
        let g:ligthline = { 'colorscheme': 'gruvbox' }
      ]])
    end,
  },

  -- Window management
  {
    "simeji/winresizer",
    init = function()
      vim.g.winresizer_start_key = "<C-T>"
    end,
  },

  -- File explorer
  {
    "scrooloose/nerdtree",
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeWinSize = 28
      vim.keymap.set("n", "<C-e>", ":NERDTreeToggle<CR>", { silent = true })
    end,
  },

  -- LSP
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = "InsertEnter",
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

  -- Browser integration
  {
    "tyru/open-browser.vim",
    config = function()
      vim.keymap.set({"n", "v"}, "gx", "<Plug>(openbrowser-smart-search)")
    end,
  },

  -- Markdown
  --- Table mode
  {
    "dhruvasagar/vim-table-mode",
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

  -- Git integration
  "airblade/vim-gitgutter",
  "tpope/vim-fugitive",

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            find_command = {"rg", "--files", "--hidden", "-g", "!.git"},
          },
          live_grep = {
            additional_args = {"--fixed-strings"},
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    end,
  },

  -- Rooter
  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = {".git"}
    end,
  },

  -- Various utilities
  "rhysd/clever-f.vim",
  "HerringtonDarkholme/yats.vim",
  "thinca/vim-visualstar",

  -- Icons and UI
  "ryanoasis/vim-devicons",

  -- Whitespace
  {
    "ntpeters/vim-better-whitespace",
    config = function()
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function()
          vim.cmd("DisableWhitespace")
        end,
      })
    end,
  },

  -- Notification system
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        render = "wrapped-compact",
        max_width = 60,
        stages = "slide",
      })
    end,
  },

  -- Noice UI
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup({
        presets = {
          command_palette = true,
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cond = function()
      return vim.fn.has("nvim") == 1
    end,
    config = function()
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

  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configure dap-ui
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "watches", size = 0.20 },
              { id = "stacks", size = 0.20 },
              { id = "breakpoints", size = 0.20 },
              { id = "scopes", size = 0.40 },
            },
            position = "right",
            size = 40,
          },
          {
            elements = {
              { id = "console", size = 0.5 },
              { id = "repl", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Auto open/close dap-ui
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Virtual text
      require("nvim-dap-virtual-text").setup()

      -- Python debugging
      require("dap-python").setup("python")
      table.insert(dap.configurations.python, {
        type = "python",
        request = "attach",
        name = "Remote Python Debugger",
        port = 5678,
        host = "127.0.0.1",
        mode = "remote",
        cwd = vim.fn.getcwd(),
        pathMappings = {
          {
            localRoot = function()
              return vim.fn.input("Local directory > ", vim.fn.getcwd() .. "/backend", "file")
            end,
            remoteRoot = function()
              return vim.fn.input("Container directory > ", "/app", "file")
            end,
          },
        },
      })

      -- Key mappings
      vim.keymap.set("n", "<F5>", function() dap.continue() end)
      vim.keymap.set("n", "<F6>", function() dap.step_over() end)
      vim.keymap.set("n", "<F7>", function() dap.step_into() end)
      vim.keymap.set("n", "<F8>", function() dap.step_out() end)
      vim.keymap.set("n", "<Leader>b", function() dap.toggle_breakpoint() end)
      vim.keymap.set("n", "<Leader>B", function() dap.set_breakpoint() end)
      vim.keymap.set("n", "<Leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
      vim.keymap.set("n", "<Leader>dr", function() dap.repl.open() end)
      vim.keymap.set("n", "<Leader>dl", function() dap.run_last() end)
      vim.keymap.set({"n", "v"}, "<Leader>dh", function()
        require("dap.ui.widgets").hover()
      end)
      vim.keymap.set({"n", "v"}, "<Leader>dp", function()
        require("dap.ui.widgets").preview()
      end)
      vim.keymap.set("n", "<Leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
      end)
      vim.keymap.set("n", "<Leader>ds", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end)
    end,
  },

  -- AI assistance
  --- Copilot
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_filetypes = {
        gitcommit = true,
        markdown = true,
        yaml = true,
        TelescopeResults = false,
        TelescopePrompt = false,
      }

      -- Set workspace folder to git root
      vim.api.nvim_create_user_command("SetCopilotWorkspaceFolder", function()
        local git_root = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")
        git_root = vim.fn.substitute(git_root, "\\n\\+$", "", "")
        if vim.v.shell_error == 0 and git_root ~= "" then
          vim.g.copilot_workspace_folders = {git_root}
        end
      end, {})

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.cmd("SetCopilotWorkspaceFolder")
        end,
      })

      -- Keybindings
      vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)", { silent = true })
      vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)", { silent = true })
    end,
  },

  --- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "github/copilot.vim", "nvim-lua/plenary.nvim" },
    branch = "main",
    config = function()
      require("CopilotChat").setup({
        model = "claude-sonnet-4",
        agent = "copilot",
        debug = false,
        window = {
          layout = "float",
          relative = "cursor",
          width = 0.8,
          height = 0.4,
          row = 1,
        },
        auto_insert_mode = false,
        question_header = "👤 ",
        answer_header = "🤖 ",
        error_header = "❌ ",
        prompts = {
          Docs = {
            prompt = "/COPILOT_GENERATE Please add documentation comment for the selection. If the selection is Python code, use Google Style docstrings.",
          },
        },
        mappings = {
          complete = {
            insert = "<C-t>",
          },
        },
      })
    end,
  },

  --- Avante
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = '0.0.24',
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "stevearc/dressing.nvim", -- for input provider dressing
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "github/copilot.vim", -- for providers='copilot'
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "Avante" },
        },
        ft = { "Avante" },
      },
    },
    config = function()
      -- Fix highlighting issues
      vim.api.nvim_set_hl(0, "AvanteSidebarNormal", { link = "Normal" })
      vim.api.nvim_set_hl(0, "AvanteSidebarWinSeparator", { link = "WinSeparator" })
      local normal_bg = string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg)
      vim.api.nvim_set_hl(0, "AvanteSidebarWinHorizontalSeparator", { fg = normal_bg })
      -- TODO: Use opts
      require('avante').setup({
        provider = 'copilot',
        providers = {
          copilot = {
            model = 'claude-sonnet-4',
          },
        },
        mappings = {
          sidebar = {
            close = {},
          }, },
        windows = {
          width = 50,
        }
      })
    end,
  },
}
