#!/bin/bash

# Import de las funciones
. ./servidor/lamp8x.sh

# Función para mostrar las opciones de config del servidor
mostrarOpcionesServidor() {
    while true; do
        opcion=$(dialog --clear --title "$APP_TITULO" \
            --menu "Seleccione el entorno a configurar:" 15 50 4 \
            1 "Comprobar configuración de LAMP" \
            2 "LAMP(Apache2.2-MySQL8.0-PHP8.x)" \
            3 "LAMP(Apache2.2-MySQL5.7-PHP7.x)" \
            4 "Entorno Docker" \
            5 "Volver al menú principal" \
            3>&1 1>&2 2>&3)
        clear
        case $opcion in
        1)
            comprobarServidor
            ;;
        2)
            instalarApache2
            instalarMySQL8
            instalarPHP8
            ;;
        2) ejecutar_script2 ;;
        3) ejecutar_script3 ;;
        5)
            sh ./app.sh
            break
            ;;
        *) echo "Opción inválida. Por favor, intente de nuevo." ;;
        esac
        echo ""
    done
}
