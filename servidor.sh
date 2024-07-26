#!/bin/bash

# Import de las funciones
. ./servidor/lamp8x.sh

# Función para mostrar las opciones de config del servidor
mostrarOpcionesServidor() {
    while true; do
        opcion=$(dialog --clear --title "$APP_TITULO" \
            --menu "\nSeleccione el entorno a configurar:" 15 50 4 \
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
            dialog --title "$APP_TITULO" --yesno "\nAtención!!\nEsta acción instalará y configurará su sistema con las versiones de Apache2.2, MySQL8.0 y PHP8.x.\nEsta acción realizará cambios en su servidor y podrá causar pérdida de datos, está seguro de continuar?" 13 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                dialog --title "$APP_TITULO" --yesno "\nConfirme su decisión, desea continuar con la instalación?" 10 50
                segunda_respuesta=$?
                if [ $segunda_respuesta -eq 0 ]; then
                    desinstalarApache2
                    desinstalarMySQL8
                    instalarPHP8
                    comprobarServidor
                else
                    dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
                fi
            else
                dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
            fi
            ;;
        2) ejecutar_script2 ;;
        3) ejecutar_script3 ;;
        5)
            sh ./app.sh
            break
            ;;
        *) echo "\nOpción inválida. Por favor, intente de nuevo." ;;
        esac
        echo ""
    done
}
