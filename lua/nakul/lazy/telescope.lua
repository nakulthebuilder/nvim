return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        -- Filename first, parent dir after — works on any telescope version
        -- (this build has no built-in "filename_first" mode).
        local function filename_first(_, path)
            local rel = vim.fn.fnamemodify(path, ":.")   -- relative to cwd
            local tail = vim.fn.fnamemodify(rel, ":t")
            local parent = vim.fn.fnamemodify(rel, ":h")
            if parent == "." or parent == "" then
                return tail
            end
            return string.format("%s  %s", tail, parent)
        end

        require('telescope').setup({
            defaults = {
                path_display = filename_first,
                -- Show the selected entry's full path in the preview border,
                -- updating live as you move up/down (VSCode-style breadcrumb).
                dynamic_preview_title = true,
                layout_strategy = "vertical",
                layout_config = {
                    vertical = {
                        width = 0.9,
                        height = 0.9,
                        preview_height = 0.5,
                        mirror = false,
                    },
                },
            },
            pickers = {
                -- For LSP lists, rows show only the filename; the full path
                -- lives in the breadcrumb (preview title) up top. fname_width
                -- keeps "name:line:col" from being truncated.
                lsp_references = { path_display = { "tail" }, fname_width = 60 },
                lsp_definitions = { path_display = { "tail" }, fname_width = 60 },
                lsp_implementations = { path_display = { "tail" }, fname_width = 60 },
            },
            extensions = {
                file_browser = {
                    path = "%:p:h",
                    display_stat = false,
                    grouped = true,
                    hidden = true,
                    hide_parent_dir = true,
                    prompt_path = true
                }
            }
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        -- Live grep from git root (or cwd if not in git repo)
        vim.keymap.set('n', '<leader>pg', function()
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            if vim.v.shell_error == 0 then
                builtin.live_grep({ cwd = git_root })
            else
                builtin.live_grep()
            end
        end, {})

        -- Optional: live grep from current directory only
        vim.keymap.set('n', '<leader>pc', builtin.live_grep, {})

        -- local harpoon = require('harpoon')
        -- harpoon:setup({})

        -- basic telescope configuration
        local conf = require("telescope.config").values
        -- local function toggle_telescope(harpoon_files)
        --     local file_paths = {}
        --     for _, item in ipairs(harpoon_files.items) do
        --         table.insert(file_paths, item.value)
        --     end
        --
        --     require("telescope.pickers").new({}, {
        --         prompt_title = "Harpoon",
        --         finder = require("telescope.finders").new_table({
        --             results = file_paths,
        --         }),
        --         previewer = conf.file_previewer({}),
        --         sorter = conf.generic_sorter({}),
        --     }):find()
        -- end

        -- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
        --     { desc = "Open harpoon window" })
    end
}
