-- .config\wezterm\config\appearance.lua
-- Window decorations, tab bar, colors, and visual feedback

local M = {}

function M.setup(config, wezterm)
  -- Window aesthetics
  config.window_decorations = "RESIZE"
  config.enable_tab_bar = true
  config.tab_bar_at_bottom = true

  config.window_padding = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
  }


  -- Copy mode colors
  config.colors = {
    copy_mode_active_highlight_bg = { Color = '#ff9e64' },
    copy_mode_active_highlight_fg = { Color = '#1a1b26' },
    copy_mode_inactive_highlight_bg = { Color = '#565f89' },
    copy_mode_inactive_highlight_fg = { Color = '#c0caf5' },
  }

  -- Flash notification when text is copied
  wezterm.on('copy', function(window, pane)
    window:toast_notification('wezterm', 'Copied!', nil, 1000)
  end)


end

return M
