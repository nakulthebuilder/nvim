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
                lualine_c = {
                    {'filename', path = 1},
                }
            }
        })

    end
}
