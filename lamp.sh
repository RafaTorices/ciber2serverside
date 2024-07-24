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

# Registramos la fecha y hora de registro en el log
{
    echo "........"
    echo "$(date)" # Fecha y hora actual del sistema
    echo "........"
} >>"$LOGFILE"

# Mostramos un mensaje informativo al usuario de inicio del script
echo "........................................."
echo "${COLOR_YELLOW}${COLOR_BOLD}Ciber2 ServerSide${COLOR_RESET} - ${COLOR_MAGENTA}${COLOR_UNDERLINE}ciber2info@gmail.com${COLOR_RESET}"
echo "........................................."
echo "${COLOR_CYAN}Iniciando instalación y configuración de LAMP...${COLOR_RESET}"
sleep 2

# Instalación y configuración de LAMP
sudo apt-get install apache2 -y >/dev/null 2>>"$LOGFILE"
# Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
if [ $? -ne 0 ]; then
    echo "........"
    echo "Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles."
    echo "........"
    sleep 3
    sh ./servidor.sh
fi

# Levantamos el servicio de Apache2 y lo habilitamos para que se inicie en el arranque del sistema e informamos al usuario
echo "........"
echo "Levantando el servicio de Apache2..."
sleep 2

sudo systemctl start apache2 >/dev/null 2>>"$LOGFILE"
# Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
if [ $? -ne 0 ]; then
    echo "........"
    echo "Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles."
    echo "........"
    sleep 3
    sh ./servidor.sh
fi
sudo systemctl enable apache2 >/dev/null 2>>"$LOGFILE"
# Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
if [ $? -ne 0 ]; then
    echo "........"
    echo "Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles."
    echo "........"
    sleep 3
    sh ./servidor.sh
fi
echo "........"
echo "Servidor Apache2 instalado y configurado correctamente."
echo "........"
echo "Espere un momento, volviendo al menú principal..."
sleep 3
sh ./servidor.sh
