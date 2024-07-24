#!/bin/bash

# Definimos el fichero log donde se almacenan los errores y salidas del script
LOGFILE="log.log"

# Registramos la fecha y hora de registro en el log
{
    echo "........"
    echo "$(date)" # Fecha y hora actual del sistema
    echo "........"
} >>"$LOGFILE"

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
sudo systemctl start apache2 -y >/dev/null 2>>"$LOGFILE"
# Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
if [ $? -ne 0 ]; then
    echo "........"
    echo "Ha ocurrido un ${COLOR_BOLD}${COLOR_RED}error.${COLOR_RESET} Consulte el archivo de log: ${COLOR_RED}$LOGFILE${COLOR_RESET} para detalles."
    echo "........"
    sleep 3
    sh ./servidor.sh
fi
sudo systemctl enable apache2 -y >/dev/null 2>>"$LOGFILE"
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
sleep 3
sh ./servidor.sh
