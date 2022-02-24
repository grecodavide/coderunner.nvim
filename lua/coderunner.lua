local M = {}
local api = vim.api
M.commands = {}

local function run(ext)
    -- replace placeholders
    local c = M.commands[ext]
    c = c:gsub("${NE}", vim.fn.expand("%")):gsub("${N}", vim.fn.expand("%:r"))

    -- open terminal with the right command
    api.nvim_command("term " .. c)

    -- go in insert mode
    api.nvim_input("A")
    vim.keymap.set("n", "q", function() vim.api.nvim_command("bdelete!") end , {buffer = 0, silent = true})
    vim.keymap.set({"n", "i", "t"}, "<Esc>", "<C-\\><C-n>" , {buffer = 0})
end


api.nvim_add_user_command("RunCurrentFile", function() return run(vim.fn.expand("%:e")) end, {})


return M
