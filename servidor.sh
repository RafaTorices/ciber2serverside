#!/bin/bash

# Import de las funciones
. ./servidor/lamp.sh

# Función para mostrar las opciones de config del servidor
mostrarOpcionesServidor() {
    while true; do
        opcion=$(dialog --clear --title "$APP_TITULO" \
            --menu "Seleccione el entorno a configurar:" 15 50 4 \
            1 "LAMP (Linux-Apache-MySQL-PHP)" \
            2 "LEMP (Linux-Nginx-MySQL-PHP)" \
            3 "DOCKER (Contenedores)" \
            4 "Volver al menú principal" \
            3>&1 1>&2 2>&3)
        clear
        case $opcion in
        1)
            instalarApache2
            ;;
        2) ejecutar_script2 ;;
        3) ejecutar_script3 ;;
        4)
            sh ./app.sh
            break
            ;;
        *) echo "Opción inválida. Por favor, intente de nuevo." ;;
        esac
        echo ""
    done
}
