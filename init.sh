#!/bin/bash

# Definimos el fichero log donde se almacenan los errores y salidas del script
LOGFILE="log.log"

# Definimos los colores para los mensajes
COLOR_RESET="\e[0m"     # Texto blanco normal
COLOR_BLUE="\e[34m"     # Texto azul para mensajes informativos
COLOR_RED="\e[31m"      # Texto rojo para mensajes de error
COLOR_GREEN="\e[32m"    # Texto verde para mensajes de éxito
COLOR_YELLOW="\e[33m"   # Texto amarillo para mensajes de advertencia
COLOR_MAGENTA="\e[35m"  # Texto magenta para submensajes
COLOR_CYAN="\e[36m"     # Texto cyan para mensajes de información
COLOR_BOLD="\e[1m"      # Texto en negrita
COLOR_UNDERLINE="\e[4m" # Texto subrayado

# Mostramos un mensaje informativo al usuario de inicio del script
echo "........................................."
echo "${COLOR_YELLOW}${COLOR_BOLD}Ciber2 ServerSide${COLOR_RESET} - ${COLOR_MAGENTA}${COLOR_UNDERLINE}ciber2info@gmail.com${COLOR_RESET}"
echo "........................................."
echo "${COLOR_CYAN}Bienvenido al script de config del Servidor, siga las instrucciones por pantalla...${COLOR_RESET}"
echo "........"
echo "Iniciando script de config del Servidor..."
# echo "${COLOR_YELLOW}(Introduza su password *${COLOR_BOLD}${COLOR_UNDERLINE}solamente*${COLOR_RESET} si se le solicita para actuar como usuario sudoer)${COLOR_RESET}"

# Registramos la fecha y hora de registro en el log
{
    echo "........"
    echo "$(date)" # Fecha y hora actual del sistema
    echo "........"
} >>"$LOGFILE"

# Función para cargar un script desde un archivo y comprobar posible error
load_script() {
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

# Cargamos funciones internas de nuestra aplicación
# Cargamos loading
SCRIPTNAME="loading.sh"
load_script "./$SCRIPTNAME"
if [ $? -ne 0 ]; then
    echo "Error con el import del script $SCRIPTNAME, no se ha podido importar." >>"$LOGFILE"
    echo "Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles."
    exit 1
fi

# 1.Actualizamos el sistema
if sudo -n true 2>/dev/null; then
    echo "........"
    echo "Configurando componentes..."
else
    echo "${COLOR_YELLOW}(Introduza su password para actuar como usuario sudoer)${COLOR_RESET}"
fi
sudo apt-get update -y >/dev/null 2>>"$LOGFILE"
# Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
if [ $? -ne 0 ]; then
    echo "........"
    echo "Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles."
    echo "........"
# Si el código de salida del último comando es 0, continuamos con el script
else
    # 2.Hacemos el upgrade del sistema
    sudo apt-get upgrade -y >/dev/null 2>>"$LOGFILE"
    # Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
    if [ $? -ne 0 ]; then
        echo "........"
        echo "Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles."
        echo "........"
    else
        # 3.Instalamos el paquete dialog para poder mostrar la interfaz gráfica
        sudo apt-get install dialog -y >/dev/null 2>>"$LOGFILE" # Enviamos la salida a /dev/null para evitar mostrarla en pantalla y redirigimos los errores al log
        # Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
        if [ $? -ne 0 ]; then
            echo "........"
            echo "Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles."
            echo "........"
        else
            # Si todo va bien, mostramos un mensaje de éxito al usuario y guardamos en el log
            echo "Update, Upgrade, paquete dialog instalados con éxito." >>"$LOGFILE"
            echo "........"
            echo "${COLOR_GREEN}Proceso completado con éxito.${COLOR_RESET}"
            echo "........"
            # Cargamos la interfaz gráfica
            echo "Cargando la interfaz gráfica..."
            # Ejecutamos un loading para que el usuario espere mientras se carga la interfaz
            loading
            echo "\n${COLOR_GREEN}Abriendo la interfaz gráfica${COLOR_RESET}"
            echo "........"
            sleep 2
            # Mostramos la interfaz gráfica
            sh ./opciones.sh
        fi
    fi
fi
