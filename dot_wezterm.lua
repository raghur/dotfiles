local wezterm = require 'wezterm'
local act = wezterm.action
-- local gpus = wezterm.gui.enumerate_gpus()
local config = {
    keys = {
        { key = '=', mods = 'META', action = act.IncreaseFontSize },
        { key = '-', mods = 'META', action = act.DecreaseFontSize },
        { key = '0', mods = 'META', action = act.ResetFontSize },
        { key = '6', mods = 'META', action = act.ToggleFullScreen },
        { key = '`', mods = 'META', action = act.ShowLauncher },
    },
    allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
    --see https://github.com/wez/wezterm/issues/484#issue-807875301
    enable_wayland = false,
    font = wezterm.font_with_fallback {
        'MonaspiceKr Nerd Font',
        'Iosevka Nerd Font',
        'FantasqueSansM Nerd Font',
        'DejaVu Sans Mono',
    },
    custom_block_glyphs = true,
    font_size = 15.0,
    line_height = 0.95,
    cell_width = 1.07,
    -- term="xterm-256color",
    harfbuzz_features = {
        "dlig",
        "calt",
        "cv06=1",
        "cv14=1",
        "cv32=1",
        "ss04=1",
        "ss07=1",
        "ss09=1",
    },
    color_scheme = "MonokaiProRistretto ()",
    color_scheme = "Misterioso",
    color_scheme = "Molokai (Gogh)",
    color_scheme = "terminal.sexy",
    color_scheme = "Molokai",
    front_end = "WebGpu",
    -- webgpu_power_preference = "HighPerformance",
    -- window_background_opacity = 1.0,
    -- cursor_blink_ease_in ="EaseIn",
    -- cursor_blink_ease_out = "EaseOut",
    -- cursor_blink_rate = 800,
    default_cursor_style="BlinkingBlock",
    force_reverse_video_cursor = true,
    font_rules = {
      {
        intensity = 'Normal',
        italic = true,
        font = wezterm.font {
          family = 'MonaspiceRn Nerd Font',
          weight = "ExtraLight",
        }
      },
    },
}
-- config.webgpu_preferred_adapter = gpus[2]
return config
