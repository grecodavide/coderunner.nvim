local M = {}
local api = vim.api
M.commands = {}


-- TODO:
-- make keymap part better: how to set them for neovim < 0.6 only in buffer
-- make it so that the user can pass the mappings (maybe with a `setup` function)

-- args are: extension, file path, name and extension, only name
local function run(ext, fp, ne, n)
    -- replace placeholders
    local c = M.commands[ext]
    if c then
        c = c:gsub("${NE}", ne):gsub("${N}", n):gsub("${FP}", fp)
    else
        vim.notify('command for "' .. ext .. '" not found')
        return
    end

    -- open terminal with the right command
    api.nvim_command("term " .. c )
    -- api.nvim_input("A") --uncomment to start in terminal mode

    -- go in insert mode
    vim.keymap.set("n", "q", function() vim.api.nvim_command("bdelete!") end , {buffer = 0, silent = true})
    vim.keymap.set({"n", "i", "t"}, "<Esc>", "<C-\\><C-n>" , {buffer = 0})
end

-- create functions and commands
M.run_current = function()
   run(vim.fn.expand("%:e"), vim.fn.expand("%:p"), vim.fn.expand("%"), vim.fn.expand("%:p:r"))
end

M.run_file = function(file)
    local ext, name, name_ext
    if not vim.fn.isdirectory(file) ~= 0 then
        name_ext = file:match(".+(/.+)$")
        ext = name_ext:match("%.(.*)")
        ext = ext or "sh" -- if it is not a directory and it has no extension treat it like a shell script
        name = file:match("(.*)%.")
    else
        vim.notify("Given file is a directory")
        return
    end
   run(ext, file, name_ext, name)
end

api.nvim_create_user_command("RunCurrent",function() return M.run_current() end, {})
api.nvim_create_user_command("RunFile", function(opts) M.run_file(opts.args) end, {nargs=1, complete="file"})

return M
