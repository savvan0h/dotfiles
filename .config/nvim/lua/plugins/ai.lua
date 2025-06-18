-- AI assistance
return {
  -- MCP Client
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",  -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end
  },

  -- Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
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

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "github/copilot.vim", "nvim-lua/plenary.nvim" },
    branch = "main",
    opts = {
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
    },
  },

  -- Avante
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
      vim.api.nvim_set_hl(0, "AvanteSidebarWinHorizontalSeparator", { fg = normal_bg, bg = normal_bg })
      -- opts doesn't work for some reason
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
        },
        -- system_prompt as function ensures LLM always has latest MCP server state
        -- This is evaluated for every message, even in existing chats
        system_prompt = function()
          local hub = require("mcphub").get_hub_instance()
          return hub and hub:get_active_servers_prompt() or ""
        end,
        -- Using function prevents requiring mcphub before it's loaded
        custom_tools = function()
          return {
            require("mcphub.extensions.avante").mcp_tool(),
          }
        end,
      })
    end,
  },
}

