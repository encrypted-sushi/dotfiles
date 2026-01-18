local platform = require("config.platform_detection.platform")

-- If we aren't in Neovide, we are in a terminal.
-- Let's use the terminal's clipboard pipe (OSC 52).
if not vim.g.neovide then
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = function(lines, regtype) require('vim.ui.clipboard.osc52').copy('+')(lines, regtype) end,
        ['*'] = function(lines, regtype) require('vim.ui.clipboard.osc52').copy('*')(lines, regtype) end,
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      },
    }
end
