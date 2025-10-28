return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    config = function()
        local conform = require("conform")

        conform.setup({
        formatters_by_ft = {
            -- ruff is run first to fix imports/linting, then black for formatting
            python = { "ruff_fix", "ruff_organize_imports", "black" },

            -- C/C++ formatting via clang-format or LSP fallback
            c = { "clang_format" },
            cpp = { "clang_format" },

            -- Add other languages as needed
            lua = { "stylua" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
        },
        formatters = {
            ruff_fix = {
                command = "ruff",
                args = { "check", "--fix", "--exit-zero", "--line-length", "88", "--stdin-filename", "$FILENAME", "-" },
                stdin = true,
            },
            ruff_organize_imports = {
                command = "ruff",
                args = { "check", "--select", "I", "--fix", "--exit-zero", "--line-length", "88", "--stdin-filename", "$FILENAME", "-" },
                stdin = true,
            },
            black = {
                command = "black",
                args = { "--line-length", "88", "--quiet", "-" },
                stdin = true,
            },
        },
            -- Format on save
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })

        -- Add explicit autocmd for format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                conform.format({ bufnr = args.buf, lsp_fallback = true })
            end,
        })
    end,
}
