#!/bin/bash

# App Ciber2ServerSide

# Importamos el script de configuración
. ./config.sh
# Importamos resto de scripts necesarios
. ./servidor.sh

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
        mostrarOpcionesServidor
        break
        ;;
    2) ejecutar_script2 ;;
    3) ejecutar_script3 ;;
    4) ejecutar_script4 ;;
    5)
        echo "\n${COLOR_RED}Cerrando${COLOR_RESET} Ciber2 ServerSide..."
        echo "${COLOR_GREEN}¡Hasta luego!\n${COLOR_RESET}"
        break
        ;;
    *) echo "Opción inválida. Por favor, intente de nuevo." ;;
    esac
    echo ""
done
