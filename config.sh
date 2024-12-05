#!/bin/bash

# Fichero log
LOGFILE="app.log"
APP_TITULO="Ciber2 ServerSide"

# Colores para los mensajes
COLOR_RESET="\e[0m"     # Texto blanco normal
COLOR_BLUE="\e[34m"     # Texto azul para mensajes informativos
COLOR_RED="\e[31m"      # Texto rojo para mensajes de error
COLOR_GREEN="\e[32m"    # Texto verde para mensajes de éxito
COLOR_YELLOW="\e[33m"   # Texto amarillo para mensajes de advertencia
COLOR_MAGENTA="\e[35m"  # Texto magenta para submensajes
COLOR_CYAN="\e[36m"     # Texto cyan para mensajes de información
COLOR_BOLD="\e[1m"      # Texto en negrita
COLOR_UNDERLINE="\e[4m" # Texto subrayado

# Mensaje cabecera de los scripts
mostrarCabecera() {
    echo "........................................."
    echo "${COLOR_YELLOW}${COLOR_BOLD}$APP_TITULO${COLOR_RESET} - ${COLOR_MAGENTA}${COLOR_UNDERLINE}ciber2info@gmail.com${COLOR_RESET}"
    echo "........................................."
}

# Registrar fecha y hora en el log
registrarHoraLog() {
    {
        echo "---"
        echo "$(date)" # Fecha y hora actual del sistema
    } >>"$LOGFILE"
}

# Función para comprobar si es necesario el password de sudoer
comprobarSudoer() {
    if sudo -n true 2>/dev/null; then
        echo ""
    else
        echo "${COLOR_YELLOW}(Introduza su password para actuar como usuario sudoer)${COLOR_RESET}"
        registrarHoraLog
        echo "Pedido password de usuario para actuar como sudoer" >>"$LOGFILE"
    fi
}

# Función para mostrar mensaje de error
mostrarError() {
    mostrarCabecera
    echo "*** Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles. ***"
}

# Función para actualizar el sistema
actualizarSistema() {
    # 1.Lanzamos update
    sudo apt-get update -y >/dev/null 2>>"$LOGFILE"
    # Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
    if [ $? -ne 0 ]; then
        mostrarError
    else
        registrarHoraLog
        echo "Update realizado con éxito" >>"$LOGFILE"
    fi
    # 2.Lanzamos upgrade
    sudo apt-get upgrade -y >/dev/null 2>>"$LOGFILE"
    # Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
    if [ $? -ne 0 ]; then
        mostrarError
    else
        registrarHoraLog
        echo "Upgrade realizado con éxito" >>"$LOGFILE"
    fi
}

# Función para instalar el paquete dialog para mostrar la interfaz gráfica
instalarDialog() {
    sudo apt-get install dialog -y >/dev/null 2>>"$LOGFILE"
    # Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
    if [ $? -ne 0 ]; then
        mostrarError
        exit 1
    else
        registrarHoraLog
        echo "Paquete dialog instalado con éxito" >>"$LOGFILE"
    fi
}

# Función para comprobar si un paquete está instalado
comprobarPaquete() {
    local paquete="$1"
    if dpkg -s "$paquete" 2>/dev/null | grep -q "Status: install ok installed"; then
        return 0
    else
        return 1
    fi
}

# Función para mostrar error en ventana dialog
mostrarErrorDialog() {
    local error_message="$1"
    dialog --title "$APP_TITULO" --msgbox "$error_message" 10 50
    clear
}

mostrarOKDialog() {
    local ok_message="$1"
    dialog --title "$APP_TITULO" --msgbox "$ok_message" 10 50
    clear
}

comprobarServicio() {
    local servicio="$1"
    if systemctl is-active --quiet "$servicio"; then
        return 0
    else
        return 1
    fi
}

levantarServicio() {
    local servicio="$1"
    sudo systemctl start "$servicio" >/dev/null 2>>"$LOGFILE"
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

reiniciarServicio() {
    local servicio="$1"
    sudo systemctl restart "$servicio" >/dev/null 2>>"$LOGFILE"
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

opcionNoDisponible() {
    mostrarErrorDialog "\nOpción no disponible en este momento.\nPróximamente se implementará esta funcionalidad."
}

buscarPaquetesPHPInstalados() {
    # Buscar paquetes de PHP instalados
    php_versions=$(dpkg -l | grep php | grep -Eo 'php[0-9.]+')
    # Verificar si se encontró alguna versión de PHP
    if [ -n "$php_versions" ]; then
        return 0
    else
        return 1
    fi
}
