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
      lsp_installer = false, -- Disable automatic LSP installation
      lsp = {
        disable_lsp = { "pylsp" }, -- Disable pylsp, we use pyright+ruff instead
        hint = {
          enable = false -- Disable all LSP hints
        },
        format_on_save = false, -- Disabled, using conform.nvim instead
        gopls = {
          on_attach = function(client, bufnr)
            -- Disable inlay hints for gopls
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end
          end,
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false
              },
              staticcheck = true,
              gofumpt = true,
              semanticTokens = true,
              analyses = {
                unusedparams = true,
                shadow = true
              },
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true
              },
              usePlaceholders = false
            }
          }
        },
        -- Python LSPs are configured in lspconfig.lua to avoid conflicts
        svelte = {
          on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true }
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
          end,
        },
        clangd = {
          on_attach = function(client, bufnr)
            -- Disable inlay hints for clangd
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end

            local opts = { noremap = true, silent = true }
            -- Keybindings for LSP features
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
          end,
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
        -- Disable inlay hints for Go files
        vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })

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
