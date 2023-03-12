local M = {}

local Path = require("plenary.path")
local dest = string.format("%s/coderunner.json", vim.fn.stdpath("data"))
local f = Path:new(dest)


M.get_config = function()
    if not f:exists() then
        f:touch()
        f:write("{}", "w")
    end
    return vim.json.decode(f:read())
end

M.set_config = function(conf)
    Path:new(dest):write(vim.fn.json_encode(conf), "w")
end


M.update_config = function(conf, ext, cmd)
    conf[ext] = cmd
    M.set_config(conf)
end


return M
