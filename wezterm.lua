-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.color_scheme = 'Nord (Gogh)'

config.font_size = 10

config.hide_tab_bar_if_only_one_tab = true

-- config.font = wezterm.font('Berkeley Mono')

-- and finally, return the configuration to wezterm
return config
