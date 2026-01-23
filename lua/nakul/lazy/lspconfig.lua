return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Python: Pyright for type checking and completions
        vim.lsp.config.pyright = {
            cmd = { 'pyright-langserver', '--stdio' },
            filetypes = { 'python' },
            root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false

                -- Auto-detect UV virtual environment
                local util = require('lspconfig.util')
                local root_dir = util.root_pattern('pyproject.toml', '.git')(vim.api.nvim_buf_get_name(bufnr))
                if root_dir then
                    -- Find nearest .venv by walking up from root_dir
                    local function find_venv(start_path)
                        local path = start_path
                        while path ~= '/' do
                            local venv_python = path .. '/.venv/bin/python'
                            local handle = io.open(venv_python, 'r')
                            if handle then
                                handle:close()
                                return venv_python, path
                            end
                            -- Move up one directory
                            path = vim.fn.fnamemodify(path, ':h')
                        end
                        return nil, nil
                    end

                    local uv_python, venv_root = find_venv(root_dir)
                    if uv_python then
                        local extraPaths = {}

                        -- Add venv root if different from project root
                        if venv_root ~= root_dir then
                            table.insert(extraPaths, venv_root)
                        end

                        -- Add project root
                        table.insert(extraPaths, root_dir)

                        client.config.settings.python.pythonPath = uv_python
                        client.config.settings.python.analysis.extraPaths = extraPaths
                        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
                    end
                end
            end,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "workspace",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = "basic",
                    }
                }
            }
        }

        -- Python: Ruff for linting
        vim.lsp.config.ruff = {
            cmd = { 'ruff', 'server' },
            filetypes = { 'python' },
            root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
            on_attach = function(client, bufnr)
                client.server_capabilities.hoverProvider = false
                client.server_capabilities.completionProvider = false
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end,
        }

        -- Go: gopls
        vim.lsp.config.gopls = {
            cmd = { 'gopls' },
            filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
            root_markers = { 'go.work', 'go.mod', '.git' },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
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
        }

        -- C/C++: clangd
        vim.lsp.config.clangd = {
            cmd = { 'clangd' },
            filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
            root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                end
            end,
        }

        -- Lua: lua_ls
        vim.lsp.config.lua_ls = {
            cmd = { 'lua-language-server' },
            filetypes = { 'lua' },
            root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT'
                    },
                    diagnostics = {
                        globals = {'vim'}
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false
                    },
                    telemetry = {
                        enable = false
                    }
                }
            }
        }

        -- Jinja2: jinja-lsp
        vim.lsp.config['jinja-lsp'] = {
            cmd = { 'jinja-lsp' },
            filetypes = { 'jinja' },
            root_markers = { '.git' },
            capabilities = capabilities,
        }

        -- Enable LSPs on appropriate filetypes
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "python",
            callback = function()
                vim.lsp.enable('pyright')
                vim.lsp.enable('ruff')
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "go", "gomod", "gowork", "gotmpl" },
            callback = function()
                vim.lsp.enable('gopls')
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
            callback = function()
                vim.lsp.enable('clangd')
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "lua",
            callback = function()
                vim.lsp.enable('lua_ls')
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "jinja",
            callback = function()
                vim.lsp.enable('jinja-lsp')
            end,
        })

        -- Detect .j2 files as jinja filetype
        vim.filetype.add({
            extension = {
                j2 = 'jinja',
            }
        })
    end,
}
