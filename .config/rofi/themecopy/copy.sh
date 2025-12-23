#!/usr/bin/env bash

## Script para copiar múltiples archivos desde diferentes orígenes a destinos específicos
## con un solo botón "Copiar" usando Rofi

swww img ~/wallpapers/mocha52.jpg

#spicetify config current_theme catppuccin
#spicetify config color_scheme mocha
#spicetify apply



# Tema de Rofi
rofi_theme="~/.config/rofi/themecopy/style.rasi"

# Lista de archivos: ("Nombre" "Origen" "Destino")
files=(
    "Hyprland" "~/.config/.theme/hyprland/matugen-hyprland.conf" "~/.config/hypr/matugen/"
    "Kitty" "~/.config/.theme/kitty/kitty.conf" "~/.config/kitty/"
    "Rofi" "~/.config/.theme/rofi/matugen-rofi.rasi" "~/.config/rofi/matugen/"
    "Spotify" "~/.config/.theme/spicetify/color.ini" "~/.config/spicetify/Themes/catppuccin/"
    "Swaync" "~/.config/.theme/swaync/matugen-swaync.css" "~/.config/swaync/matugen/"
    "Waybar" "~/.config/.theme/waybar/matugen-waybar.css" "~/.config/waybar/matugen/"
)

# Construir mensaje para mostrar en Rofi con nombres
build_message() {
    local msg=""
    for ((i=0; i<${#files[@]}; i+=3)); do
        msg+="${files[i]}\n"
    done
    echo -e "$msg"
}

# Mostrar botón de acción con resumen de archivos
run_menu() {
    echo "🚀 Copy all" | rofi -dmenu \
        -p "Apply" \
        -mesg "$(build_message)" \
        -theme "$rofi_theme"
}

# Notificación al sistema
notify() {
    notify-send "🎨 Copied files" "$1"
}

# Ejecutar copias
copy_all() {
    local total=${#files[@]}
    local success=0
    local failed=0

    for ((i=0; i<total; i+=3)); do
        local name="${files[i]}"
        local src="${files[i+1]}"
        local dst="${files[i+2]}"

        eval src="$src"
        eval dst="$dst"

        if [[ -f "$src" ]]; then
            mkdir -p "$dst"
            cp "$src" "$dst"
            ((success++))
        else
            echo "❌ Not found: $src"
            ((failed++))
        fi
    done

    notify "✅ Copied: $success | ❌ Failed: $failed"
}

# Mostrar menú y ejecutar si se selecciona
selected=$(run_menu)

if [[ "$selected" == "🚀 Copy all" ]]; then
    copy_all
fi
