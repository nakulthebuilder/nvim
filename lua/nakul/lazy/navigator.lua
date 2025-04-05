return {
  "ray-x/navigator.lua",
  dependencies = {
    {"hrsh7th/nvim-cmp"}, {"nvim-treesitter/nvim-treesitter"},
    {"ray-x/guihua.lua", run = "cd lua/fzy && make"}, {
      "ray-x/go.nvim",
      event = {"CmdlineEnter"},
      ft = {"go", "gomod"},
      build = ':lua require("go.install").update_all_sync()'
    },
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      opts = {},
    },
    {
      "ray-x/lsp_signature.nvim", -- Show function signature when you type
      event = "VeryLazy",
      config = function() require("lsp_signature").setup({
        hint_enable = false,       -- Disable virtual hints
      }) end
    },
    -- Python-specific plugins
    {
      "python-rope/rope", -- Python refactoring library
      lazy = true,
      ft = "python"
    },
    {
      "mfussenegger/nvim-dap-python", -- Debug adapter for Python
      dependencies = {"mfussenegger/nvim-dap"},
      ft = "python",
      config = function()
        require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
      end
    }
  },
  config = function()
    require("go").setup()
    require("navigator").setup({
      lsp_signature_help = true, -- enable ray-x/lsp_signature
      lsp = {
        format_on_save = true,
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic"
              }
            }
          }
        }
      },
      signature_help_cfg = {
        hint_enable = false,       -- Disable virtual hints
      },
    })
    require("typescript-tools").setup {
      settings = {
        complete_function_calls = true,
      },
    }
    local lspconfig = require('lspconfig')
    lspconfig.denols.setup({
      autostart = false,
      deno = {
        enable = true,
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true
            }
          }
        }
      }
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"go"},
      callback = function(ev)
        -- CTRL/control keymaps
        vim.api
        .nvim_buf_set_keymap(0, "n", "<C-i>", ":GoImport<CR>", {})
        vim.api.nvim_buf_set_keymap(0, "n", "<C-b>", ":GoBuild %:h<CR>",
          {})
        vim.api.nvim_buf_set_keymap(0, "n", "<C-t>", ":GoTestPkg<CR>",
          {})
        vim.api.nvim_buf_set_keymap(0, "n", "<C-c>",
          ":GoCoverage -p<CR>", {})
      end,
      group = vim.api.nvim_create_augroup("go_autocommands",
        {clear = true})
    })

    -- Python-specific autocommands
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"python"},
      callback = function()
        -- Set Python indentation
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4

        -- Python keymaps
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>pt", ":!python -m pytest %<CR>", opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>pr", ":!python %<CR>", opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>pi", ":!pip install -e .<CR>", opts)
      end,
      group = vim.api.nvim_create_augroup("python_autocommands", {clear = true})
    })
  end
}
