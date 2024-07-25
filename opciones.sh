#!/bin/bash

# Script para mostrar opciones al usuario mediante un menú
# Importamos config.sh
. ./config.sh

# Bucle para mostrar el menú y obtener la opción del usuario
while true; do
    opcion=$(dialog --clear --title "Ciber2 Server Side" \
        --menu "Seleccione la opción a ejecutar:" 15 50 4 \
        1 "Configuración de Servidor Web" \
        2 "VirtualHost de desarrollo básico" \
        3 "VirtualHost de desarrollo WORDPRESS" \
        4 "VirtualHost de desarrollo JOOMLA" \
        5 "Cerrar y Salir" \
        3>&1 1>&2 2>&3)
    clear
    case $opcion in
    1)
        sh servidor.sh
        break
        ;;
    2) ejecutar_script2 ;;
    3) ejecutar_script3 ;;
    4) ejecutar_script4 ;;
    5)
        echo "\n${COLOR_RED}Cerrando${COLOR_RESET} Ciber2 Server Side, espere por favor..."
        sleep 2
        echo "${COLOR_GREEN}¡Hasta luego!\n${COLOR_RESET}"
        break
        ;;
    *) echo "Opción inválida. Por favor, intente de nuevo." ;;
    esac
    echo ""
done
