return {
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons", "catppuccin/nvim"},
    config = function()
        require("lualine").setup({
            options = {
                theme = "catppuccin",
                component_separators = '|',
                section_separators = '',
            },
            sections = {
                lualine_b = {
                    {'branch', fmt = function(str) return str:sub(1, 20) end}
                },
                lualine_c = {
                    {'filename', path = 1},
                }
            }
        })

    end
}
