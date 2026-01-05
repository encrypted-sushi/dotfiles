-- ~/.config/wezterm/configs/preload/utils.lua
local wezterm = require('wezterm')
local M = {}

function M.load_directory(config, directory_path)
  -- Get the directory where wezterm.lua is located
  local script_dir = wezterm.config_dir
  
  -- Build absolute path
  local pattern = script_dir .. '/' .. directory_path .. '/*.lua'
  
  wezterm.log_info('Loading from pattern: ' .. pattern)
  
  for _, file in ipairs(wezterm.glob(pattern)) do
    -- Skip init.lua if present
    if not file:match('init%.lua$') then
      -- Convert file path back to module name
      -- e.g., 'configs/appearance/colors.lua' -> 'configs.appearance.colors'
      local relative_path = file:match('configs[/\\](.+)%.lua$')
      if relative_path then
        local module_name = 'configs.' .. relative_path:gsub('[/\\]', '.')
        
        wezterm.log_info('Attempting to load: ' .. module_name)
        
        local ok, module = pcall(require, module_name)
        if ok and module.setup then
          wezterm.log_info('Successfully loaded: ' .. module_name)
          module.setup(config)
        else
          wezterm.log_warn('Failed to load: ' .. module_name)
        end
      end
    end
  end
end

return M
