#!/bin/bash

# Fichero log
LOGFILE="log.log"

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
    echo "${COLOR_YELLOW}${COLOR_BOLD}Ciber2 ServerSide${COLOR_RESET} - ${COLOR_MAGENTA}${COLOR_UNDERLINE}ciber2info@gmail.com${COLOR_RESET}"
    echo "........................................."
    echo "${COLOR_CYAN}Bienvenido al script de config del Servidor, siga las instrucciones por pantalla...${COLOR_RESET}\n"
}

# Registrar fecha y hora en el log
registrarHoraLog() {
    {
        echo "---"
        echo "$(date)" # Fecha y hora actual del sistema
    } >>"$LOGFILE"
}

# Función para cargar un script desde un archivo y comprobar posible error
cargamosScript() {
    local SCRIPT="$1"
    # Comprobar si el archivo existe
    if [ -f "$SCRIPT" ]; then
        # Importar el script
        . "$SCRIPT"
        # Comprobar si hubo un error en la importación
        if [ $? -ne 0 ]; then
            return 1 # Devolver un código de error
        else
            return 0 # Devolver un código de éxito
        fi
    else
        return 1 # Devolver un código de error
    fi
}

# Función para mostrar un efecto de carga mediante puntos suspensivos
loading() {
    # Número total de puntos (suspensivos) a mostrar
    total_dots=1
    # Tiempo entre la actualización (en segundos)
    interval=1
    # Duración total del efecto de carga (en segundos)
    duration=8
    # Obtener el tiempo actual en segundos desde la época
    start_time=$(date +%s)
    # Realizar el efecto de carga
    while true; do
        # Calcular el tiempo transcurrido
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))
        # Salir si el tiempo transcurrido es mayor o igual a la duración
        if [ $elapsed_time -ge $duration ]; then
            break
        fi
        # Imprimir los puntos
        for i in $(seq 1 $total_dots); do
            printf "%${i}s" | tr ' ' '.'
            sleep $interval
        done
    done
    # OPCIONAL: Imprimir un mensaje final cuando la carga haya terminado
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
        echo "La configuración no puede continuar."
        mostrarError
        exit 1
    else
        registrarHoraLog
        echo "Paquete dialog instalado con éxito" >>"$LOGFILE"
    fi
}
