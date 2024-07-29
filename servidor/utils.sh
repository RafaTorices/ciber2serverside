#!bin/bash

# Script de utilidades de la aplicación Ciber2ServerSide

# Función para mostrar las opciones de utilidades
mostrarOpcionesUtilidades() {
    while true; do
        opcion=$(dialog --clear --title "$APP_TITULO" \
            --menu "\nSeleccione la utilidad a ejecutar:" 15 50 4 \
            1 "Mostrar dirección IP" \
            2 "Ejecutar Pin" \
            0 "Volver al menú principal" \
            3>&1 1>&2 2>&3)
        clear
        case $opcion in
        1)
            dialog --title "$APP_TITULO" --msgbox "\nDirección IP(s):\n$(obtener_ip)" 10 50
            ;;
        2)
            ejecutar_ping
            ;;
        0)
            break
            ;;
        *) echo "\nOpción inválida. Por favor, intente de nuevo." ;;
        esac
        echo ""
    done
}

# Función para obtener la ip del servidor
obtener_ip() {
    ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1
}

# Función para realizar ping y mostrar el resultado
ejecutar_ping() {
    # Solicitar dirección IP o nombre de host al usuario
    local destino=$(dialog --title "$APP_TITULO" --inputbox "Ingrese la dirección IP o nombre de host:" 8 40 3>&1 1>&2 2>&3 3>&-)
    # Verificar si se ingresó un valor
    if [ -z "$destino" ]; then
        dialog --title "$APP_TITULO" --msgbox "No se ingresó ninguna dirección IP o nombre de host." 8 40
    else
        dialog --title "$APP_TITULO" --infobox "Realizando ping a $destino..." 8 40 &
        # Realizar ping y guardar el resultado
        local resultado=$(ping -c 4 $destino 2>&1)
        # Mostrar resultado en un msgbox
        dialog --title "$APP_TITULO" --msgbox "Resultado de ping a: $destino\n\n$resultado" 20 80
    fi
}
