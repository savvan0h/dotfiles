return {
  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F6>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F7>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F8>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      { "<Leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<Leader>B", function() require("dap").set_breakpoint() end, desc = "DAP Set Breakpoint" },
      { "<Leader>dr", function() require("dap").repl.open() end, desc = "DAP Open REPL" },
      { "<Leader>dl", function() require("dap").run_last() end, desc = "DAP Run Last" },
    },
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

      -- Additional key mappings
      vim.keymap.set("n", "<Leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
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
}

