-- Hyprland Lua configuration
-- Converted from hyprland.conf
-- See https://wiki.hypr.land/Configuring/Start/


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "",         mode = "preferred", position = "auto", scale = 1.25 })
-- Office monitor: left, rotated
hl.monitor({ output = "DVI-D-1",  mode = "preferred", position = "0x0",  scale = 1.25, transform = 1 })
-- Office monitor: right  (scaled position: 1080 / 1.25 = 675)
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "864x0", scale = 1.25 })
-- Laptop
hl.monitor({ output = "eDP-1",    mode = "preferred", position = "auto", scale = 1.25 })
-- Mirror HDMI to laptop (uncomment to enable):
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1.6, mirror = "eDP-1" })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "dolphin"
local menu        = "wofi --show drun"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("waybar")
    hl.exec_cmd("syncthingtray --wait")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hypridle")

    -- Cursor theme: must run here, not at file scope. A bare hl.exec_cmd runs
    -- during config parse, before the IPC socket exists, so hyprctl fails.
    hl.exec_cmd("hyprctl setcursor macOS 24")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- Unscale XWayland
-- https://wiki.hyprland.org/Configuring/XWayland/
hl.config({ xwayland = { force_zero_scaling = true } })
hl.env("GDK_SCALE", "1")

-- Cursor theme for clients (XWayland/GTK/Qt).
-- Hyprland's own rendered cursor is set via setcursor in the autostart block.
hl.env("XCURSOR_THEME", "macOS")
hl.env("XCURSOR_SIZE",   "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Avoid black cursor on some monitors
-- https://github.com/end-4/dots-hyprland/issues/3054
hl.config({ cursor = { no_hardware_cursors = 1 } })


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 0,
        gaps_out = 0,

        border_size = 1,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        allow_tearing = false,
        layout        = "scrolling",
    },

    decoration = {
        rounding = 0,

        active_opacity   = 1.0,
        inactive_opacity = 0.9,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = false,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,      -- 0 or 1 disables anime mascot wallpapers
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
        background_color        = "rgb(0,0,0)",
        focus_on_activate       = true,   -- allows changing Emacs windows
    },
    debug = {
        vfr = true,                       -- lower sent frames
    },
})


---------------
---- INPUT ----
---------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.config({
    input = {
        kb_layout  = "us,br,de",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:win_space_toggle",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,  -- -1.0 to 1.0, 0 means no modification

        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor        = 0.5,
        },
    },
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

hl.device({
    name        = "dell-mouse-ms3320w-mouse",
    sensitivity = -0.8,
})

hl.device({
    -- https://github.com/hyprwm/Hyprland/issues/6023
    name        = "wacom-one-by-wacom-s-pen",
    output      = "current",
    left_handed = true,
})


---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER"

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd(menu))

-- Window management
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())             -- dwindle
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("togglesplit"))       -- dwindle
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen(0))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreenstate 0 2"))  -- maximize, keep geometry

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Cycle windows in a floating workspace
hl.bind("SUPER + Tab", hl.dsp.window.cycle_next())
hl.bind("SUPER + Tab", hl.dsp.window.bring_to_top())

-- Switch workspaces with mainMod + [0-9]
-- Move active window to workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move windows with mainMod + SHIFT + hjkl
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + MINUS",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + MINUS", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move current workspace to monitor
hl.bind("CTRL + ALT + " .. mainMod .. " + SHIFT + comma",  hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor l"))
hl.bind("CTRL + ALT + " .. mainMod .. " + SHIFT + period", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor r"))

-- Resize submap
-- See https://wiki.hyprland.org/Configuring/Binds/#submaps
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("L",      hl.dsp.exec_cmd("hyprctl dispatch resizeactive 20 0"),  { repeating = true })
    hl.bind("H",      hl.dsp.exec_cmd("hyprctl dispatch resizeactive -20 0"), { repeating = true })
    hl.bind("K",      hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -20"), { repeating = true })
    hl.bind("J",      hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 20"),  { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Yellow/sunset submap (hyprsunset colour temperature control)
hl.bind(mainMod .. " + S", hl.dsp.submap("yellow"))
hl.define_submap("yellow", function()
    -- Each bind also resets the submap so it acts as a one-shot selection
    local function sun_bind(key, cmd)
        hl.bind(key, hl.dsp.exec_cmd(cmd))
        hl.bind(key, hl.dsp.submap("reset"))
    end

    sun_bind("S", "hyprctl hyprsunset identity")
    sun_bind("1", "hyprctl hyprsunset temperature 1000")
    sun_bind("2", "hyprctl hyprsunset temperature 2000")
    sun_bind("3", "hyprctl hyprsunset temperature 3000")
    sun_bind("4", "hyprctl hyprsunset temperature 4000")
    sun_bind("5", "hyprctl hyprsunset temperature 5000")
    sun_bind("6", "hyprctl hyprsunset temperature 6000")
    sun_bind("I", "hyprctl keyword decoration:screen_shader '~/.config/hypr/shaders/invert.glsl'")
    sun_bind("O", "hyprctl keyword decoration:screen_shader ''")

    hl.bind("0",      hl.dsp.submap("reset"))
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Reload waybar
-- NOTE: mainMod+K is also bound to movefocus up above; both dispatchers will fire.
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("killall waybar || waybar"))

-- Screen brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })

-- Audio volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Media controls (requires playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Lock screen (requires hyprlock)
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("hyprlock"))

-- GTK dark / light theme toggle
-- https://github.com/hyprwm/Hyprland/discussions/5867
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-light' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'"))

-- Screenshot (requires grim, slurp, satty)
-- https://wiki.hypr.land/FAQ/#how-do-i-screenshot
hl.bind("Print",         hl.dsp.exec_cmd('grim -g "$(slurp -w 0 -d -b 00000088)" - | satty --filename -'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp -w 0 -d)"'))

-- Fix clipboard between X11 and Wayland
-- https://github.com/hyprwm/Hyprland/issues/6132
hl.bind("SUPER + C", hl.dsp.exec_cmd("xclip -selection clipboard -o | wl-copy"))


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    -- Ignore maximize requests from all apps
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    -- Hyprland-run: float and pin to bottom-left corner
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "swayimg-float",
    match = { class = "swayimg" },
    float = true,
})
