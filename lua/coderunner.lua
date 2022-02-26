local M = {}
local api = vim.api
M.commands = {}

local function run(ext, command)
    -- replace placeholders
    local c = M.commands[ext]
    if c then
        c = c:gsub("${NE}", vim.fn.expand("%")):gsub("${N}", vim.fn.expand("%:p:r")):gsub("${FP}", vim.fn.expand("%:p"))
    else
        vim.notify('command for "' .. ext .. '" not found')
        return
    end

    -- open terminal with the right command
    api.nvim_command(command .. c)

    -- go in insert mode
    api.nvim_input("A")
    vim.keymap.set("n", "q", function() vim.api.nvim_command("bdelete!") end , {buffer = 0, silent = true})
    vim.keymap.set({"n", "i", "t"}, "<Esc>", "<C-\\><C-n>" , {buffer = 0})
end

-- create functions and commands
M.run_current = function()
   run(vim.fn.expand("%:e"), "term ")
end

M.run_current_split = function()
   run(vim.fn.expand("%:e"), "split | term ")
end

M.run_current_vsplit = function()
   run(vim.fn.expand("%:e"), "vsplit | term ")
end

api.nvim_add_user_command("RunCurrent", function() return M.run_current() end, {})
api.nvim_add_user_command("RunCurrentSplit", function() return M.run_current_split() end, {})
api.nvim_add_user_command("RunCurrentVSplit", function() return M.run_current_vsplit() end, {})


return M
