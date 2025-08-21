return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
    },
    config = function()
        local lspconfig = require("lspconfig")

        lspconfig.svelte.setup({
          on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true }
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
          end,
        })

        -- C/C++ setup (existing)
        lspconfig.clangd.setup({
            on_attach = function(client, bufnr)
                local opts = { noremap = true, silent = true }
                -- Keybindings for LSP features
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                -- Enable format on save for C++ files
                vim.api.nvim_create_autocmd("BufWritePre", {
                  pattern = "*.cpp,*.h",
                  callback = function()
                      vim.lsp.buf.formatting_sync(nil, 1000)
                  end,
                })
            end,
        })

        -- Python setup is handled by Navigator.lua
        -- Removed duplicate configuration to avoid conflicts
    end,
}
