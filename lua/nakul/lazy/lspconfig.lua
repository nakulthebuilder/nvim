return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
    },
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Python LSP setup (pyright for hover/completion)
        lspconfig.pyright.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                -- Disable formatting since conform handles it
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false

                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = "off",
                        -- Reduce false positives for syntax errors
                        reportMissingImports = "none",
                        reportUndefinedVariable = "none",
                        reportGeneralTypeIssues = "none",
                    }
                }
            }
        })

        -- Ruff for linting (ruff_lsp is deprecated, use ruff instead)
        lspconfig.ruff.setup({
            on_attach = function(client, bufnr)
                -- Disable hover/completion since pyright handles it
                client.server_capabilities.hoverProvider = false
                client.server_capabilities.completionProvider = false
                -- Disable formatting since conform handles it
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end,
        })
    end,
}
