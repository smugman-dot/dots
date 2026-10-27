-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
local colors = require("colors")
require("comms-workspaces")
------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@180.003",
    position = "auto",
    scale    = "auto",
    vrr      = 1,
    icc      = "/home/walid/Documents/VG249Q3A.icm"
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "foot"
local fileManager = "thunar"
local browser     = "uwsm app -- brave-origin"
local menu        = 'rofi -show drun -run-command "uwsm app -- {cmd}"'

-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function () 
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)
hl.on("hyprland.start", function ()
    hl.exec_cmd("stash watch")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    hl.exec_cmd("systemctl --user start dmemcg-booster-user.service hyprland-focused-booster.service")
    hl.exec_cmd("gsr-ui")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,ssh")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GL_VRR_ALLOWED", "1")
hl.env("__GL_GSYNC_ALLOWED", "1")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 9,
        border_size = 2,
        col = {
            active_border   = { colors = { colors.primary, colors.tertiary }, angle = 45 },
            inactive_border = colors.outline,
        },
        resize_on_border = true,
        allow_tearing = true,
        layout = "dwindle",
    },
    render = {
        direct_scanout = true
    },
    quirks = {
        skip_non_kms_dmabuf_formats = true,
    },
    decoration = {
        rounding       = 18,
        rounding_power = 3,
        active_opacity   = 1.0,
        inactive_opacity = 0.92,
        dim_inactive     = true,
        dim_strength     = 0.06,

        shadow = {
            enabled      = true,
            range        = 24,
            render_power = 4,
            offset       = { 0, 6 },
            color        = 0x66000000,
            color_inactive = 0x44000000,
        },

        blur = {
    enabled = true,
    size = 4,
    passes = 2,
    vibrancy = 0.17,
    noise = 0.015,
    contrast = 1.0,
    brightness = 1.0,
    popups = true,
    popups_ignorealpha = 0.6,
    xray = false,
    special = true,
    new_optimizations = true,
},
    },
    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })


hl.animation({ leaf = "specialWorkspace",    enabled = true, speed = 4,   bezier = "easeOutQuint", style = "slidefadevert 15%" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 4.5, bezier = "easeOutQuint", style = "slidefadevert 15%" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3,   bezier = "quick",        style = "slidefadevert 15%" })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",  enabled = true, speed = 5,   bezier = "easeOutQuint", style = "popin 80%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.5, bezier = "quick",        style = "popin 90%" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
-- hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 4,   bezier = "easeOutQuint", style = "slidefade 30%" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 4.5, bezier = "easeOutQuint", style = "slidefade 30%" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 3,   bezier = "quick",        style = "slidefade 30%" })

hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })


-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
        explicit_column_widths = "0.5, 1.0",
    },
})

----------------
----  MISC  ----
----------------
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        focus_on_activate = true,
        exit_window_retains_fullscreen = true,
        vrr = 1
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,ara",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        accel_profile = "flat",

        follow_mouse = 1,
        repeat_rate = 40,
        repeat_delay = 100,
        kb_options = "grp:win_space_toggle,caps:escape,grp:super_space_toggle",

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.config({
    cursor = {
        hide_on_key_press = true,
        no_hardware_cursors = false,
        no_break_fs_vrr = true
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. "+ SHIFT + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/scripts/rofi-audio-output.sh"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprcap shot region -z -c -n -w"))
hl.layer_rule({ match = { namespace = "hyprpicker" }, no_anim = true })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprcap shot monitor:active -w -c"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("~/scripts/roficlipboard.sh"))
hl.bind(mainMod .. " + SHIFT + PERIOD", hl.dsp.exec_cmd("rofimoji --action copy"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("wlogout -C ~/.config/wlogout/style.css -l ~/.config/wlogout/layout -b 3 -c 0 -r 0"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + A",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local resizeStep = 20 -- pixels per press, adjust to taste

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = -resizeStep, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.resize({ x =  resizeStep, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -resizeStep, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y =  resizeStep, relative = true }), { repeating = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/scripts/osd_volume.sh --vol-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/scripts/osd_volume.sh --vol-down"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("~/scripts/osd_media.sh --next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("~/scripts/osd_media.sh --play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("~/scripts/osd_media.sh --play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("~/scripts/osd_media.sh --prev"),   { locked = true })

hl.bind("SUPER + I", function ()
    if hl.get_workspace("special:minimized") then
        -- restore all minimized windows to the current workspace
        hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        -- minimize the active window
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end)
--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)
-- Drop this in your hyprland.lua window rules section
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
-- all FL windows: float + center (dialogs, plugin windows, etc.)
hl.window_rule({
    name  = "fl-all-float",
    match = { class = "^(fl64\\.exe)$" },
    float = true,
    center = true,
    suppress_event = "fullscreen maximize",
})

-- main window only: back to tiled (must come AFTER the rule above)
hl.window_rule({
    name  = "fl-main-tile",
    match = { class = "^(fl64\\.exe)$", title = "^(FL Studio.*)$" },
    tile  = true,
})
-- put this AFTER your other fl rules
hl.window_rule({
    name  = "fl-splash-hide",
    match = { class = "^(fl64\\.exe)$", initial_title = "^$" },
    workspace = "special:flsplash silent",
    no_focus = true,
    no_anim = true,
})
-- 3. Match ALL proton/umu games using xdg_tag
hl.window_rule({ match = { xdg_tag = "proton-game" }, immediate = true })
hl.window_rule({ match = { xdg_tag = "proton-game" }, no_blur = true })
hl.window_rule({ match = { xdg_tag = "proton-game" }, no_shadow = true })
hl.window_rule({ match = { xdg_tag = "proton-game" }, no_anim = true })
hl.window_rule({ match = { xdg_tag = "proton-game" }, fullscreen = true })

-- Optional: You can keep your old steam_app rules as a backup for native XWayland Steam games,
-- or use the "content" property to match everything tagged as a game by the system:
hl.window_rule({ match = { content = "game" }, fullscreen = true })

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
-- 2. Window rules use hl.window_rule() with distinct 'match' properties and effect values
hl.window_rule({
    match = {
        class = "^(steam)$",
        title = "^(Steam Big Picture)$",
    },
    fullscreen = true, -- Forces Steam BP to stay locked into fullscreen
})
hl.layer_rule({
    match = { namespace = "rofi" },
    blur = true,
    ignore_alpha = 0.5,
    animation = "popin 80%",
})
hl.layer_rule({
    match = { namespace = "osd" },
    blur = true,
    ignore_alpha = 0,
    animation = "popin 80%",
})
hl.layer_rule({
    match = { namespace = "notifications" },
    blur = true,
    ignore_alpha = 0.1,
    animation = "popin 20%",
})
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })
hl.layer_rule({ match = { namespace = "gtk-layer-shell" }, {blur = true, dimaround = true} })

-- hl.window_rule({
--     match = {
--         class = "^(steam_app_.*)$",
--     },
--     workspace = 5,
-- })
