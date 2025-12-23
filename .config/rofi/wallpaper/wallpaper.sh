#!/bin/bash

WALLPAPERS_DIR="$HOME/wallpapers/"

# Función para definir el estilo del menú de selección
build_theme() {
    rows=$1
    cols=$2
    icon_size=$3
    echo "element{orientation:vertical;}element-text{horizontal-align:0.5;}element-icon{size:${icon_size}.0000em;}listview{lines:$rows;columns:$cols;}"
}

theme="$HOME/.config/rofi/wallpaper/style.rasi"

# --- Selector de esquema matugen (antes de elegir wallpaper) ---
SCHEMES=(
    "ninguno"
    "scheme-content"
    "scheme-expressive"
    "scheme-fidelity"
    "scheme-fruit-salad"
    "scheme-monochrome"
    "scheme-neutral"
    "scheme-rainbow"
    "scheme-tonal-spot"
)

# Mostrar menú rofi para escoger esquema
scheme_choice=$(printf "%s\n" "${SCHEMES[@]}" | rofi -dmenu -i -p "󰙘 Esquema de color" -lines ${#SCHEMES[@]} -width 20 -location 1 -yoffset 0)

# Definir el comando matugen según la opción seleccionada
if [[ "$scheme_choice" != "ninguno" && -n "$scheme_choice" ]]; then
    APPLY_SCHEME="matugen -t $scheme_choice image"
else
    APPLY_SCHEME="matugen image"
fi

# --- Selección del wallpaper ---
ROFI_CMD="rofi -dmenu -i -show-icons -theme-str $(build_theme 3 5 6) -theme ${theme}"

choice=$(
    ls --escape "$WALLPAPERS_DIR" | \
        while read A; do echo -en "$A\x00icon\x1f$WALLPAPERS_DIR/$A\n"; done | \
        $ROFI_CMD -p "󰸉  Wallpaper"
)

# Ruta completa al archivo seleccionado
wallpaper="$WALLPAPERS_DIR/$choice"

# Aplicar wallpaper según el entorno de escritorio
if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    echo "$wallpaper"
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
        var allDesktops = desktops();
        for (i = 0; i < allDesktops.length; i++) {
            d = allDesktops[i];
            d.wallpaperPlugin = \"org.kde.image\";
            d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\");
            d.writeConfig(\"Image\", \"file:$wallpaper\");
        }"

    exit 0

elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper"
    exit 0

elif [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    swaymsg output "*" bg "$wallpaper" "stretch"
    exit 0

else
    # Otros entornos de escritorio (ej: wayland con swww)
    swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration 1 --transition-step 255 --transition-fps 60 "$wallpaper"
    $APPLY_SCHEME "$wallpaper"
    ln -sf "$wallpaper" "$WALLPAPERS_DIR/current.wall"
fi

exit 1
