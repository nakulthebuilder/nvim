return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",  -- Core DAP plugin
    "nvim-neotest/nvim-nio",  -- Optional, if you want integration with tests
    "folke/neodev.nvim"       -- Optional, improves Lua development in Neovim
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local neodev = require("neodev")

    -- Setup neodev (optional, mainly for Lua developers)
    neodev.setup({
      library = {
        plugins = { "nvim-dap-ui" },
        types = true,
      },
    })

    -- Configure nvim-dap-ui
    dapui.setup()

    -- Open/close DAP UI automatically when debugging starts/stops
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Configure DAP for C (example using `vscode-cpptools`)
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = "/home/nakul/.vscode/extensions/ms-vscode.cpptools-1.22.11-linux-x64/debugAdapters/bin/OpenDebugAD7",
    }

    dap.configurations.c = {
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        setupCommands = {
          {
            description = "Enable pretty-printing for gdb",
            text = "-enable-pretty-printing",
            ignoreFailures = false,
          },
        },
      },
    }

    -- Keybindings for DAP
    vim.keymap.set("n", "<F5>", dap.continue)
    vim.keymap.set("n", "<F10>", dap.step_over)
    vim.keymap.set("n", "<F11>", dap.step_into)
    vim.keymap.set("n", "<F12>", dap.step_out)
    vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
    vim.keymap.set("n", "<Leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end)
    vim.keymap.set("n", "<Leader>lp", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end)
    vim.keymap.set("n", "<Leader>dr", dap.repl.open)
    vim.keymap.set("n", "<Leader>dl", dap.run_last)
  end,
}

