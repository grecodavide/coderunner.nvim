local M = {}
local api = vim.api
M.commands = {}


---@param command string
local function open_term(command)
    vim.fn.termopen(command)
end

---@param ext string
---@param filepath string
---@param name_extension string
---@param name string
local function run(ext, filepath, name_extension, name)
    -- Replace placeholders
    local c = M.commands[ext]
    if c then
        c = c:gsub("${NE}", name_extension):gsub("${N}", name):gsub("${FP}", filepath)
    else
        vim.notify('command for "' .. ext .. '" not found')
        return
    end

    -- Final output: red if exit code != 0, green otherwise
    local eos = [[\\n\\n\\u001b[1m\\u001b[38;5;${c}mSCRIPT ENDED\\u001b[0m]]
    local check_ok = "if [[ $? == 0 ]];then; c=2;else;c=1;fi"
    local command = string.format("%s; %s; echo -e \"%s\"", c, check_ok, eos)


    -- Actually open terminal
    local bufnr = api.nvim_create_buf(false, false)
    api.nvim_buf_call(bufnr, function() open_term(command) end)

    local cur_buf = api.nvim_get_current_buf()
    if cur_buf ~= bufnr then
        vim.cmd(string.format("silent keepalt buffer %d", bufnr))
    end

    -- Mappings
    vim.keymap.set("n", "q", ":bdelete!<CR>", {buffer = 0, silent = true})
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>" , {buffer = 0})

end


M.run_current = function()
    if not vim.fn.isdirectory(vim.fn.expand("%")) ~= 0 then
        run(vim.fn.expand("%:e"), vim.fn.expand("%:p"), vim.fn.expand("%"), vim.fn.expand("%:p:r"))
    else
        vim.notify("Given file is a directory")
        return
    end
end

---@param file string
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

-- create commands executable in command mode
api.nvim_create_user_command("RunCurrent",function() return M.run_current() end, {})
api.nvim_create_user_command("RunFile", function(opts) M.run_file(opts.args) end, {nargs=1, complete="file"})

return M
