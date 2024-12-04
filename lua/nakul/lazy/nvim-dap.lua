return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require("dap")

        -- Define cppdbg adapter (VSCode cpptools)
        dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = "/home/nakul/.vscode/extensions/ms-vscode.cpptools-1.22.11-linux-x64/debugAdapters/bin/OpenDebugAD7",
        }

        -- Define configurations for C and C++
        dap.configurations.c = {
            {
                name = "Launch C Program",
                type = "cppdbg",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopAtEntry = false,
                setupCommands = {
                    {
                        text = "-enable-pretty-printing",
                        description = "Enable pretty printing",
                        ignoreFailures = false,
                    },
                },
            },
        }
        dap.configurations.cpp = dap.configurations.c
    end,
}

