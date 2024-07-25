#!/bin/bash

# Instalación y configuración de LAMP

# Apache2
instalarApache2() {
    dialog --title "$APP_TITULO" --infobox "Instalando y configurando Apache2, espere..." 10 50
    sleep 2
    if comprobarPaquete apache2 0 && comprobarServicio apache2 0; then
        mostrarOKDialog "Apache2 ya está configurado y funcionando en este servidor, cancelamos la instalación."
        registrarHoraLog
        echo "Apache2 ya está configurado y funcionando en este servidor, cancelamos la instalación." >>"$LOGFILE"
        return
    else
        registrarHoraLog
        sudo apt-get install apache2 -y >/dev/null 2>>"$LOGFILE"
        if [ $? -ne 0 ]; then
            mostrarErrorDialog "Error al configurar Apache2, compruebe el archivo de log: $LOGFILE para más detalles."
        else
            registrarHoraLog
            echo "Paquete Apache2 instalado con éxito." >>"$LOGFILE"
            levantarServicio apache2
            if [ $? -ne 0 ]; then
                mostrarErrorDialog "Error al levantar el servicio Apache2, compruebe el archivo de log: $LOGFILE para más detalles."
            else
                registrarHoraLog
                echo "Servicio Apache2 levantado con éxito." >>"$LOGFILE"
                echo "Apache2 configurado con éxito." >>"$LOGFILE"
                mostrarOKDialog "Apache2 configurado con éxito."
            fi
        fi
    fi
}
