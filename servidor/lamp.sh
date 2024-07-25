#!/bin/bash

# Instalación y configuración de LAMP

# Apache2
instalarApache2() {
    registrarHoraLog
    sudo apt-get install apache22 -y >/dev/null 2>>"$LOGFILE"
    # Si el código de salida del último comando es distinto de 0, mostramos un mensaje de error por pantalla al usuario
    if [ $? -ne 0 ]; then
        mostrarErrorDialog "Error al instalar Apache2, compruebe el archivo de log: $LOGFILE para más detalles."
    else
        registrarHoraLog
        echo "Paquete Apache2 instalado con éxito" >>"$LOGFILE"
    fi
}
