return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()

      -- DAP keybindings
      vim.keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
      vim.keymap.set("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
      vim.keymap.set("n", "<leader>do", ":lua require'dap'.step_over()<CR>")
      vim.keymap.set("n", "<leader>di", ":lua require'dap'.step_into()<CR>")
      vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
      vim.keymap.set("n", "<leader>du", ":lua require'dapui'.toggle()<CR>")
    end
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            pytest_xdist = true,
            runner = "pytest",
          })
        },
        icons = {
          running = "󰑮",
          passed = "✅",
          failed = "❌",
          skipped = "⏭️",
        },
      })

      -- Test runner keybindings
      vim.keymap.set("n", "<leader>tt", ":lua require('neotest').run.run()<CR>")
      vim.keymap.set("n", "<leader>tf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>")
      vim.keymap.set("n", "<leader>td", ":lua require('neotest').run.run({strategy = 'dap'})<CR>")
      vim.keymap.set("n", "<leader>ts", ":lua require('neotest').summary.toggle()<CR>")
    end
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      -- Python formatters and linters
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black.with({
            extra_args = {"--line-length", "88"}
          }),
          null_ls.builtins.formatting.isort.with({
            extra_args = {"--profile", "black"}
          }),
          null_ls.builtins.diagnostics.ruff.with({
            extra_args = {"--line-length", "88", "--extend-ignore", "E203"}
          }),
          null_ls.builtins.diagnostics.mypy,
        },
      })
    end
  }
}
