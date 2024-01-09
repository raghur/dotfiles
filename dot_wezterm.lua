local wezterm = require 'wezterm'
local act = wezterm.action
-- local gpus = wezterm.gui.enumerate_gpus()
local config = {
    hide_tab_bar_if_only_one_tab = true,
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
        -- https://wezfurlong.org/wezterm/config/lua/wezterm/font.html
        { family = 'Iosevka Nerd Font', weight = 'Light'} ,
        { family = 'Iosevka Fixed Curly', weight = 'ExtraLight'},
        { family = 'FantasqueSansMono Nerd Font', weight = 'ExtraLight'},
        { family = 'MonaspiceKr Nerd Font', weight = 'ExtraLight'},
        'FantasqueSansM Nerd Font',
        'DejaVu Sans Mono',
    },
    custom_block_glyphs = true,
    font_size = 15.0,
    line_height = 0.95,
    line_height = 1,
    cell_width = 1.1,
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
            intensity = "Bold",
            font = wezterm.font(
                'MonaspiceKr Nerd Font',
                {
                    weight = "Thin",
                    style = "Italic"
                })
        },
        {
            intensity = "Normal",
            italic = true,
            font = wezterm.font(
                'MonaspiceRn Nerd Font',
                {
                    weight = "ExtraLight",
                    style = "Normal"
                })
        },
    },
}
-- config.webgpu_preferred_adapter = gpus[2]
return config
