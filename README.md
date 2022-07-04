# coderunner.nvim
Run code in neovim's integrated terminal

# Requirements
This plugin requires neovim >= 0.6

# Setup
to set up this plugin, in a lua file require it and give it the commands:
```lua
local cr = require("coderunner")
cr.commands = {
    sh = "${FP}",
    py = "python ${FP}"
    -- note that this is a shell command, so it can be something more elaborate 
    c = "gcc -o ${N} ${FP};if [[ $? ]];then ${N}; fi"
}
```
Available placeholders are:
- `${FP}` for the full path
- `${NE}` for the file name
- `${N}`  for the file name without extension


# Features
Run current file in a neovim terminal.  
The available functions are:  
- `run_current`
- `run_file` (requires filepath)

And the commands to do the same are:
- `RunCurrent`
- `RunFile`

Note that you can create a split like so:
- `:split | RunCurrent`
- `:vsplit | RunCurrent`
