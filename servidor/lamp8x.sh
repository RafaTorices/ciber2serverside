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

# MySQL Server 8.0
instalarMySQL8() {
    dialog --title "$APP_TITULO" --infobox "Instalando y configurando MySQL Server 8.0, espere..." 10 50
    sleep 2
    if comprobarPaquete mysql-server 0 && comprobarServicio mysql 0; then
        mostrarOKDialog "Ya hay una instancia de MySQL Server configurado y funcionando en este servidor, cancelamos la instalación."
        registrarHoraLog
        echo "Ya hay una instancia de MySQL Server configurado y funcionando en este servidor, cancelamos la instalación." >>"$LOGFILE"
        return
    else
        registrarHoraLog
        sudo apt-get install mysql-server -y >/dev/null 2>>"$LOGFILE"
        if [ $? -ne 0 ]; then
            mostrarErrorDialog "Error al configurar MySQL Server 8.0, compruebe el archivo de log: $LOGFILE para más detalles."
        else
            registrarHoraLog
            echo "Paquete MySQL Server 8.0 instalado con éxito." >>"$LOGFILE"
            levantarServicio mysql
            if [ $? -ne 0 ]; then
                mostrarErrorDialog "Error al levantar el servicio MySQL Server 8.0, compruebe el archivo de log: $LOGFILE para más detalles."
            else
                registrarHoraLog
                echo "Servicio MySQL Server 8.0 levantado con éxito." >>"$LOGFILE"
                echo "MySQL Server 8.0 configurado con éxito." >>"$LOGFILE"
                mostrarOKDialog "MySQL Server 8.0 configurado con éxito."
            fi
        fi
    fi
}

# PHP 8.x
instalarPHP8() {
    dialog --title "$APP_TITULO" --infobox "Instalando y configurando PHP 8.x, espere..." 10 50
    sleep 2
    registrarHoraLog
    sudo add-apt-repository ppa:ondrej/apache2 -y >/dev/null 2>>"$LOGFILE"
    sudo add-apt-repository ppa:ondrej/php -y >/dev/null 2>>"$LOGFILE"
    sudo apt update -y >/dev/null 2>>"$LOGFILE"
    sudo apt install -y -qq php8.0 php8.0-mcrypt \
        php8.0-gd php8.0-curl php8.0-mysql php8.0-zip \
        php8.0-xml php8.0-soap php8.0-intl \
        php8.0-mbstring php8.0-bcmath >/dev/null 2>>"$LOGFILE"
    sudo apt install -y -qq php8.1 php8.1-mcrypt \
        php8.1-gd php8.1-curl php8.1-mysql php8.1-zip \
        php8.1-xml php8.1-soap php8.1-intl \
        php8.1-mbstring php8.1-bcmath >/dev/null 2>>"$LOGFILE"
    sudo apt install -y -qq php8.2 php8.2-mcrypt \
        php8.2-gd php8.2-curl php8.2-mysql php8.2-zip \
        php8.2-xml php8.2-soap php8.2-intl \
        php8.2-mbstring php8.2-bcmath >/dev/null 2>>"$LOGFILE"
    sudo apt install -y -qq php8.3 php8.3-mcrypt \
        php8.3-gd php8.3-curl php8.3-mysql php8.3-zip \
        php8.3-xml php8.3-soap php8.3-intl \
        php8.3-mbstring php8.3-bcmath >/dev/null 2>>"$LOGFILE"
    dialog --title "$APP_TITULO" --msgbox "PHP 8.x instalado con éxito." 10 50
    registrarHoraLog
    echo "PHP 8.x instalado con éxito." >>"$LOGFILE"
}

# Comprobar la configuración actual del servidor
comprobarServidor() {
    # Comprobamos si Apache2 está instalado
    if comprobarPaquete apache2 0; then
        apache2_status="Apache2 configurado OK."
        apache2_version=$(apache2 -v 2>/dev/null | grep "Server version:")
        if [ -z "$apache2_version" ]; then
            apache2_version="No se pudo obtener la versión de Apache2."
        else
            apache2_version=$(echo "$apache2_version")
        fi
    else
        apache2_status="Apache2 NO configurado."
    fi
    # Comprobamos si MySQL está instalado
    if comprobarPaquete mysql-server 0; then
        mysql_status="MySQL configurado OK."
        mysql_version=$(mysql --version 2>/dev/null)
        # Usa `sed` para limpiar la salida y extraer solo la versión
        cleaned_version=$(echo "$mysql_version" | sed -e 's/^mysql  Ver  for  [^ ]* //')
        if [ -z "$cleaned_version" ]; then
            cleaned_version="No se pudo obtener la versión de MySQL."
        fi
    else
        mysql_status="MySQL NO configurado."
    fi
    # Comprobamos las versiones de PHP
    php_versions=$(ls /usr/bin/php* 2>/dev/null | grep -oP '(?<=php)[0-9.]+')
    # Si no hay versiones encontradas, muestra un mensaje adecuado
    if [ -z "$php_versions" ]; then
        php_versions="No se encontraron versiones de PHP configuradas en el servidor."
    else
        php_versions=$(echo "$php_versions" | sort | uniq | tr '\n' ' ')
    fi
    # Mostramos los resultados en una ventana dialog
    dialog --title "$APP_TITULO" --msgbox "Configuración actual del servidor:\n\nEstado de Apache2:\n$apache2_status\n$apache2_version\n\nEstado de MySQL:\n$mysql_status\n$cleaned_version\n\nVersiones de PHP:\n$php_versions" 20 50
}
