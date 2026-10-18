local mainMod = "SUPER"
-- Windows go to their special workspace automatically; "silent" avoids stealing focus on autolaunch
hl.window_rule({ match = { class = "^(discord)$" }, workspace = "special:comms silent" })
hl.window_rule({ match = { class = "^([Ss]potify)$" }, workspace = "special:music silent" })

-- Toggle the special workspace if the app is running, otherwise launch it
-- (the window rule above then drops it onto the special workspace)
local function toggleApp(ws, class, cmd)
    return hl.dsp.exec_cmd(string.format(
        "hyprctl clients -j | grep -qi '\"class\": \"%s\"' && hyprctl dispatch 'hl.dsp.workspace.toggle_special(\"%s\")' || %s",
        class, ws, cmd))
end

hl.bind(mainMod .. " + D", toggleApp("comms", "discord", "uwsm app -- discord"))
hl.bind(mainMod .. " + M", toggleApp("music", "spotify", "uwsm app -- spotify"))
