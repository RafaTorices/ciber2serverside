#!/bin/bash

# App Ciber2ServerSide

# Importamos la config y las funciones
. ./config.sh
. ./funciones.sh

# Comprobamos que el paquete dialog está instalado para poder ejecutar la aplicación
# Si no está instalado, actualizamos el sistema e instalamos el paquete dialog y lo registramos en el log
if ! comprobarPaquete dialog; then
    registrarHoraLog
    echo "El paquete 'dialog' no está instalado." >>"$LOGFILE"
    echo "Actualizamos el sistema e instalamos el paquete 'dialog' para continuar." >>"$LOGFILE"
    mostrarCabecera
    echo "${COLOR_CYAN}Configurando la aplicación, por favor espere...${COLOR_RESET}"
    actualizarSistema
    instalarDialog
# Si está instalado, lo registramos en el log y ejecutamos la aplicación
else
    registrarHoraLog
    echo "Comprobado que el sistema puede iniciar la aplicación." >>"$LOGFILE"
    echo "El paquete 'dialog' está instalado." >>"$LOGFILE"
    echo "Se ejecuta la aplicación correctamente" >>"$LOGFILE"
fi

# Función para ver el log de la aplicación
verLog() {
    dialog --title "$APP_TITULO" --msgbox "\n$(cat $LOGFILE)" 20 80
}

# Bucle para mostrar el menú y obtener la opción del usuario
while true; do
    opcion=$(dialog --clear --title "$APP_TITULO" \
        --menu "\nScript de configuración de Servidor Web.\nSeleccione la opción a ejecutar:" 15 50 4 \
        1 "Comprobar configuración de LAMP" \
        2 "LAMP(Apache-MySQL-PHP-phpMyAdmin)" \
        3 "Mostrar IP del Servidor" \
        4 "Mostrar Log de la Aplicación" \
        0 "Cerrar y Salir" \
        3>&1 1>&2 2>&3)
    clear
    case $opcion in
    1)
        comprobarServidor
        ;;
    2)
        dialog --title "$APP_TITULO" --defaultno --yesno "\nAtención!!\nEsta acción instalará y configurará su sistema con las versiones de Apache2.2, MySQL8.0, PHP7.x, PHP8.x. y phpMyAdmin.\nEsta acción realizará cambios en su servidor y podrá causar pérdida de datos, está seguro de continuar?" 14 50
        respuesta=$?
        if [ $respuesta -eq 0 ]; then
            dialog --title "$APP_TITULO" --defaultno --yesno "\nConfirme su decisión, desea continuar con la instalación?" 10 50
            segunda_respuesta=$?
            if [ $segunda_respuesta -eq 0 ]; then
                desinstalarApache2
                desinstalarMySQL8
                instalarPHP8
                desinstalarPhpMyAdmin
                resumenServidor
            else
                dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
            fi
        else
            dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
        fi
        ;;
    3)
        dialog --title "$APP_TITULO" --msgbox "\nDirección IP(s):\n$(obtener_ip)" 10 50
        ;;
    4) verLog ;;
    0)
        echo "\n${COLOR_RED}Cerrando${COLOR_RESET} $APP_TITULO..."
        echo "${COLOR_GREEN}¡Hasta luego!\n${COLOR_RESET}"
        registrarHoraLog
        echo "Aplicación cerrada por el usuario." >>"$LOGFILE"
        break
        ;;
    *) echo "Opción inválida. Por favor, intente de nuevo." ;;
    esac
    echo ""
done
