local wezterm = require 'wezterm'
local act = wezterm.action
local function make_mouse_binding(dir, streak, button, mods, action)
  return {
    event = { [dir] = { streak = streak, button = button } },
    mods = mods,
    action = action,
  }
end

-- local gpus = wezterm.gui.enumerate_gpus()
local config = {
    hide_tab_bar_if_only_one_tab = true,
    audible_bell="Disabled",
    visual_bell = {
        fade_in_function = 'EaseIn',
        fade_in_duration_ms = 150,
        fade_out_function = 'EaseOut',
        fade_out_duration_ms = 150,
    },
    colors = {
        visual_bell = '#202020',
    },
    keys = {
        { key = '=', mods = 'META', action = act.IncreaseFontSize },
        { key = '-', mods = 'META', action = act.DecreaseFontSize },
        { key = '0', mods = 'META', action = act.ResetFontSize },
        { key = '6', mods = 'META', action = act.ToggleFullScreen },
        { key = '`', mods = 'META', action = act.ShowLauncher },
        -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
        { key = 'LeftArrow', mods = 'OPT', action = act.SendKey {key = 'b', mods='ALT'} },
        -- Make Option-Right equivalent to Alt-f; forward-word
        { key = 'RightArrow', mods = 'OPT', action = act.SendKey {key = 'f', mods = 'ALT'} },
    },
    allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
    --see https://github.com/wez/wezterm/issues/484#issue-807875301
    enable_wayland = false,
    font = wezterm.font_with_fallback {
        -- https://wezfurlong.org/wezterm/config/lua/wezterm/font.html
        { family = 'IosevkaTerm Nerd Font', weight = "ExtraLight"} ,
        { family = 'FiraCode Nerd Font' } ,
        { family = 'FantasqueSansM Nerd Font', weight='Light'},
        { family = 'MonaspiceKr Nerd Font', weight = 'Light'},
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
    -- webgpu_power_preference = "HighPerformance",
    -- window_background_opacity = 1.0,
    -- cursor_blink_ease_in ="EaseIn",
    -- cursor_blink_ease_out = "EaseOut",
    -- cursor_blink_rate = 800,
    unicode_version=14,
    default_cursor_style="BlinkingBlock",
    force_reverse_video_cursor = true,
    font_rules = {
        {
            italic = true,
            font = wezterm.font('MonaspiceRn Nerd Font',
                {
                    weight = "ExtraLight",
                    style = "Italic"
                })
        },
        -- {
        --     intensity = "Half",
        --     font = wezterm.font(
        --         'MonaspiceRn Nerd Font',
        --         {
        --             weight = "Bold",
        --             style = "Italic"
        --         })
        -- },
    },
    mouse_bindings = {
        make_mouse_binding('Up', 1, 'Left', 'NONE', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 1, 'Left', 'SHIFT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 1, 'Left', 'ALT', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 1, 'Left', 'SHIFT|ALT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 2, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
        make_mouse_binding('Up', 3, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
    },
}
-- config.webgpu_preferred_adapter = gpus[2]
return config
