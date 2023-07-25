local wezterm = require 'wezterm'
local act = wezterm.action
local gpus = wezterm.gui.enumerate_gpus()
local config = {
    --see https://github.com/wez/wezterm/issues/484#issue-807875301
    enable_wayland = false,
    font = wezterm.font_with_fallback {
        { family = 'Iosevka Term Curly', weight='ExtraLight'},
        'FantasqueSansMono Nerd Font',
        'DejaVu Sans Mono',
    },
    font_size = 13.0,
    line_height = 1.0,
    harfbuzz_features = {
        "cv06=1",
        "cv14=1",
        "cv32=1",
        "ss04=1",
        "ss07=1",
        "ss09=1",
    },
    color_scheme = "MonokaiProRistretto (Gogh)",
    color_scheme = "Misterioso",
    color_scheme = "Molokai (Gogh)",
    color_scheme = "Molokai",
    front_end = "WebGpu",
    webgpu_power_preference = "HighPerformance",
    -- window_background_opacity = 1.0,
    -- cursor_blink_ease_in ="EaseIn",
    -- cursor_blink_ease_out = "EaseOut",
    -- cursor_blink_rate = 800,
    -- cursor_thickness = 1.0,
    default_cursor_style="BlinkingBlock"
}
-- config.webgpu_preferred_adapter = gpus[2]
return config
