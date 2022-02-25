# coderunner.nvim
---
Run code in neovim

# Requirements
---
This plugin requires neovim >= 0.6

# Setup
---
to set up this plugin, in a lua file require it and give it the commands:
```lua
local cr = require("coderunner")
cr.commands = {
    sh = "${FP}",
    py = "python ${FP}"
}
```
Available placeholders are:
- `${FP}` for the full path
- `${NE}` for the file name
- `${N}`  for the file name without extension

# Features
---
Run current file in a neovim terminal.  
The available functions are:  
- `run_current`: creates a new buffer
- `run_current_split`: creates a new split
- `run_current_vsplit`: creates a new vertical split

And the commands to do the same are:
- `RunCurrent`
- `RunCurrentSplit`
- `RunCurrentVSplit`
