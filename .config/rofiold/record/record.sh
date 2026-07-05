#!/usr/bin/env bash
#
# Menu con Rofi para controlar grabaciones (fullscreen, region, stop).
# Invoca internamente a "record.sh".
#
# Ajusta las rutas según tus preferencias.

# Ruta a tu script de grabación
RECORD_SCRIPT="$HOME/.config/hypr/scripts/record.sh"

# Ruta a tu tema para Rofi (archivo .rasi)
ROFI_THEME="$HOME/.config/rofi/record/config.rasi"

# Opciones que se mostrarán en el menú
# Puedes cambiar los iconos por otros de tu preferencia (Nerd Fonts, FontAwesome, etc.)
options="  Pantalla Completa\n  Seleccionar Región\n  Detener Grabación"

# Llamamos a rofi para que muestre el menú
# -dmenu = menú desplegable
# -p = prompt (texto a la izquierda)
# -theme = cargamos el .rasi personalizado
choice="$(echo -e "$options" | rofi -dmenu -p "Grabación" -theme "$ROFI_THEME" -selected-row 0)"

# Actuamos según la elección del usuario
case "$choice" in
    "  Pantalla Completa")
        "$RECORD_SCRIPT" fullscreen
        ;;
    "  Seleccionar Región")
        "$RECORD_SCRIPT" section
        ;;
    "  Detener Grabación")
        "$RECORD_SCRIPT" stop
        ;;
    *)
        # Si se cierra el menú o se escoge algo no previsto
        exit 0
        ;;
esac
