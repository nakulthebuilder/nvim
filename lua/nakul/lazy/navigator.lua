return {
  "ray-x/navigator.lua",
  dependencies = {
    {"hrsh7th/nvim-cmp"},
    {"nvim-treesitter/nvim-treesitter"},
    {"ray-x/guihua.lua", run = "cd lua/fzy && make"},
    {
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
      "ray-x/lsp_signature.nvim",
      event = "VeryLazy",
      config = function()
        require("lsp_signature").setup({
          hint_enable = false,
        })
      end
    },
    {
      "python-rope/rope",
      lazy = true,
      ft = "python"
    },
    {
      "mfussenegger/nvim-dap-python",
      dependencies = {"mfussenegger/nvim-dap"},
      ft = "python",
      config = function()
        require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
      end
    }
  },
  config = function()
    require("go").setup()

    -- Disable navigator's LSP management to avoid conflicts
    -- LSPs are configured in lspconfig.lua instead
    require("navigator").setup({
      lsp = false,  -- Completely disable navigator's LSP setup
    })

    -- Set up TypeScript tools
    require("typescript-tools").setup {
      on_attach = function(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
      end,
      settings = {
        complete_function_calls = true,
      },
    }

    -- Go-specific autocommands and keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"go"},
      callback = function(ev)
        vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })

        vim.api.nvim_buf_set_keymap(0, "n", "<C-i>", ":GoImport<CR>", {})
        vim.api.nvim_buf_set_keymap(0, "n", "<C-b>", ":GoBuild %:h<CR>", {})
        vim.api.nvim_buf_set_keymap(0, "n", "<C-t>", ":GoTestPkg<CR>", {})
        vim.api.nvim_buf_set_keymap(0, "n", "<C-c>", ":GoCoverage -p<CR>", {})
      end,
      group = vim.api.nvim_create_augroup("go_autocommands", {clear = true})
    })

    -- JavaScript/TypeScript-specific autocommands
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
      callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
      end,
      group = vim.api.nvim_create_augroup("javascript_autocommands", {clear = true})
    })

    -- Python-specific autocommands
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"python"},
      callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4

        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>pt", ":!python -m pytest %<CR>", opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>pr", ":!python %<CR>", opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>pi", ":!pip install -e .<CR>", opts)
      end,
      group = vim.api.nvim_create_augroup("python_autocommands", {clear = true})
    })
  end
}
