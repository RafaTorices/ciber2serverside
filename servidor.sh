#!/bin/bash

# Menú de opciones con dialog en Bash para mostrar al usuario las opciones disponibles

# Bucle para mostrar el menú y obtener la opción del usuario
while true; do
    opcion=$(dialog --clear --title "Ciber2 Server Side" \
        --menu "Seleccione el entorno a configurar:" 15 50 4 \
        1 "LAMP (Linux-Apache-MySQL-PHP)" \
        2 "LEMP (Linux-Nginx-MySQL-PHP)" \
        3 "DOCKER (Contenedores)" \
        4 "Volver al menú principal" \
        3>&1 1>&2 2>&3)
    clear
    case $opcion in
    1)
        sh ./servidor/lamp.sh
        break
        ;;
    2) ejecutar_script2 ;;
    3) ejecutar_script3 ;;
    4)
        sh ./opciones.sh
        break
        ;;
    *) echo "Opción inválida. Por favor, intente de nuevo." ;;
    esac
    echo ""
done
