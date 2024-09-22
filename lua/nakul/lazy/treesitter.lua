return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        {
            "nvim-treesitter/nvim-treesitter-context",
            opts = { enable = true, mode = "topline", line_numbers = true }
        }
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            ensure_installed = {
                "vimdoc", "javascript", "typescript", "c", "lua", "rust",
                "jsdoc", "bash", "dockerfile", "gitignore", "go", "gomod",
                "gosum", "json", "markdown", "python", "sql"
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
                enable = true
            },

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            -- textobjects = { select = { enable = true, lookahead = true } }
        })

        local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        treesitter_parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = { "src/parser.c", "src/scanner.c" },
                branch = "master",
            },
        }

        vim.treesitter.language.register("templ", "templ")
    end
}
