return {
    {
        "mhartington/formatter.nvim",
        config = function()
            require('formatter').setup({
                filetype = {
                    javascript = {
                        -- Prettier
                        function()
                            return {
                                exe = "prettier",
                                args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
                                stdin = true
                            }
                        end
                    },
                    typescript = {
                        -- Prettier
                        function()
                            return {
                                exe = "prettier",
                                args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
                                stdin = true
                            }
                        end
                    }
                }
            })
        end
    },
}

