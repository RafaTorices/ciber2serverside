#!/bin/bash

# Instalación y configuración de LAMP

# Apache2
instalarApache2() {
    dialog --title "$APP_TITULO" --infobox "\n\nInstalando y configurando Apache2, espere..." 10 50
    sleep 2
    registrarHoraLog
    sudo apt-get install apache2 -y >/dev/null 2>>"$LOGFILE"
    if [ $? -ne 0 ]; then
        mostrarErrorDialog "\n\nError al configurar Apache2, compruebe el archivo de log: $LOGFILE para más detalles."
    else
        registrarHoraLog
        echo "Paquete Apache2 instalado con éxito." >>"$LOGFILE"
        levantarServicio apache2
        if [ $? -ne 0 ]; then
            mostrarErrorDialog "\n\nError al levantar el servicio Apache2, compruebe el archivo de log: $LOGFILE para más detalles."
        else
            registrarHoraLog
            echo "Servicio Apache2 levantado con éxito." >>"$LOGFILE"
            echo "Apache2 configurado con éxito." >>"$LOGFILE"
            mostrarOKDialog "\n\nApache2 configurado con éxito."
        fi
    fi
}

# MySQL Server 8.0
instalarMySQL8() {
    dialog --title "$APP_TITULO" --infobox "\n\nInstalando y configurando MySQL8.0, espere..." 10 50
    sleep 2
    registrarHoraLog
    sudo apt-get install mysql-server -y >/dev/null 2>>"$LOGFILE"
    if [ $? -ne 0 ]; then
        mostrarErrorDialog "\n\nError al configurar MySQL8.0, compruebe el archivo de log: $LOGFILE para más detalles."
    else
        registrarHoraLog
        echo "Paquete MySQL8.0 instalado con éxito." >>"$LOGFILE"
        levantarServicio mysql
        if [ $? -ne 0 ]; then
            mostrarErrorDialog "\n\nError al levantar el servicio MySQL8.0, compruebe el archivo de log: $LOGFILE para más detalles."
        else
            registrarHoraLog
            echo "Servicio MySQL8.0 levantado con éxito." >>"$LOGFILE"
            echo "MySQL8.0 configurado con éxito." >>"$LOGFILE"
            mostrarOKDialog "\n\nMySQL8.0 configurado con éxito."
        fi
    fi
}

# PHP 8.x
instalarPHP8() {
    dialog --title "$APP_TITULO" --defaultno --yesno "\nAtención!!\nContinuar con la instalación y configuración de PHP en su servidor?" 10 50
    respuesta=$?
    if [ $respuesta -eq 0 ]; then
        dialog --title "$APP_TITULO" --infobox "\n\nInstalando y configurando PHP, espere..." 10 50
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
        sudo apt install -y -qq php7.0 php7.0-mcrypt \
            php7.0-gd php7.0-curl php7.0-mysql php7.0-zip \
            php7.0-xml php7.0-soap php7.0-intl \
            php7.0-mbstring php7.0-bcmath >/dev/null 2>>"$LOGFILE"
        sudo apt install -y -qq php7.1 php7.1-mcrypt \
            php7.1-gd php7.1-curl php7.1-mysql php7.1-zip \
            php7.1-xml php7.1-soap php7.1-intl \
            php7.1-mbstring php7.1-bcmath >/dev/null 2>>"$LOGFILE"
        sudo apt install -y -qq php7.2 php7.2-mcrypt \
            php7.2-gd php7.2-curl php7.2-mysql php7.2-zip \
            php7.2-xml php7.2-soap php7.2-intl \
            php7.2-mbstring php7.2-bcmath >/dev/null 2>>"$LOGFILE"
        sudo apt install -y -qq php7.3 php7.3-mcrypt \
            php7.3-gd php7.3-curl php7.3-mysql php7.3-zip \
            php7.3-xml php7.3-soap php7.3-intl \
            php7.3-mbstring php7.3-bcmath >/dev/null 2>>"$LOGFILE"
        sudo apt install -y -qq php7.4 php7.4-mcrypt \
            php7.4-gd php7.4-curl php7.4-mysql php7.4-zip \
            php7.4-xml php7.4-soap php7.4-intl \
            php7.4-mbstring php7.4-bcmath >/dev/null 2>>"$LOGFILE"

        dialog --title "$APP_TITULO" --msgbox "\n\nPHP instalado con éxito." 10 50
        registrarHoraLog
        echo "PHP instalado con éxito." >>"$LOGFILE"
    else
        dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
    fi
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
    if comprobarServicio apache2 0; then
        apache2_servicio="Servicio de Apache2 corriendo OK."
    else
        apache2_servicio="Servicio de Apache2 detenido."
    fi
    modules=$(apache2ctl -M 2>/dev/null | grep -oP '^\s*\S+(?=_module)')
    # Verificar si se obtuvieron módulos y preparar la salida
    if [ -z "$modules" ]; then
        modules="No se pudo obtener la lista de módulos habilitados o no hay módulos habilitados."
    else
        modules=$(echo "$modules" | tr '\n' ' ')
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
    if comprobarServicio mysql 0; then
        mysql_servicio="Servicio de MySQL corriendo OK."
    else
        mysql_servicio="Servicio de MySQL detenido."
    fi
    # Comprobamos las versiones de PHP
    php_versions=$(ls /usr/bin/php* 2>/dev/null | grep -oP '(?<=php)[0-9.]+')
    # Si no hay versiones encontradas, muestra un mensaje adecuado
    if [ -z "$php_versions" ]; then
        php_versions="No se encontraron versiones de PHP configuradas en el servidor."
    else
        php_versions=$(echo "$php_versions" | sort | uniq | tr '\n' ' ')
    fi
    # Obtener las extensiones habilitadas de PHP
    extensions=$(php -m 2>/dev/null)
    # Verificar si se obtuvieron extensiones y preparar la salida
    if [ -z "$extensions" ]; then
        extensions="No se pudo obtener la lista de extensiones habilitadas o no hay extensiones habilitadas."
    else
        # Convertir saltos de línea en espacios para mostrar las extensiones en una sola línea
        extensions=$(echo "$extensions" | tr '\n' ' ')
    fi
    # Mostramos los resultados en una ventana dialog
    while true; do
        opcion=$(dialog --clear --title "$APP_TITULO" \
            --menu "\nConfiguración actual de su servidor:" 15 50 4 \
            1 "Apache" \
            2 "MySQL" \
            3 "PHP" \
            4 "phpMyAdmin" \
            0 "Volver atrás" \
            3>&1 1>&2 2>&3)
        clear
        case $opcion in
        1)
            dialog --title "$APP_TITULO" --defaultno --yesno "\n$apache2_status\n\n$apache2_version\n\n$apache2_servicio\n\nMódulos habilitados Apache2:\n$modules\n\n***¿Reiniciar el servicio?***\n" 20 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                if comprobarServicio apache2 0; then
                    reiniciarServicio apache2 >/dev/null 2>>"$LOGFILE"
                    if [ $? -ne 0 ]; then
                        mostrarErrorDialog "\n\nError al reiniciar Apache2, compruebe el archivo de log: $LOGFILE para más detalles."
                    else
                        registrarHoraLog
                        echo "Servicio de Apache2 reiniciado con éxito." >>"$LOGFILE"
                        dialog --title "$APP_TITULO" --msgbox "\nServicio de Apache2 reiniciado con éxito." 10 50
                        break
                    fi
                else
                    registrarHoraLog
                    echo "El servicio de Apache2 no está corriendo, no se puede reiniciar." >>"$LOGFILE"
                    mostrarErrorDialog "\n\nEl servicio de Apache2 no está corriendo, no se puede reiniciar."
                fi
            else
                break
            fi
            ;;
        2)
            dialog --title "$APP_TITULO" --defaultno --yesno "\n$mysql_status\n\n$cleaned_version\n\n$mysql_servicio\n\n***¿Reiniciar el servicio?***" 20 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                if comprobarServicio mysql 0; then
                    reiniciarServicio mysql >/dev/null 2>>"$LOGFILE"
                    if [ $? -ne 0 ]; then
                        mostrarErrorDialog "\n\nError al reiniciar MySQL, compruebe el archivo de log: $LOGFILE para más detalles."
                    else
                        registrarHoraLog
                        echo "Servicio de MySQL reiniciado con éxito." >>"$LOGFILE"
                        dialog --title "$APP_TITULO" --msgbox "\nServicio de MySQL reiniciado con éxito." 10 50
                        break
                    fi
                else
                    registrarHoraLog
                    echo "El servicio de MySQL no está corriendo, no se puede reiniciar." >>"$LOGFILE"
                    mostrarErrorDialog "\n\nEl servicio de MySQL no está corriendo, no se puede reiniciar."
                fi
            else
                break
            fi
            ;;
        3)
            dialog --title "$APP_TITULO" --msgbox "\nVersiones de PHP disponibles:\n$php_versions\n\nExtensiones habilitadas de PHP:\n$extensions" 20 50
            break
            ;;
        4)
            if comprobarPhpMyAdmin 0; then
                phpmyadmin_status="phpMyAdmin está configurado OK en este servidor."
            else
                phpmyadmin_status="phpMyAdmin NO está configurado en este servidor."
            fi
            dialog --title "$APP_TITULO" --msgbox "\n$phpmyadmin_status" 10 50
            break
            ;;
        0)
            break
            ;;
        *) echo "Opción inválida. Por favor, intente de nuevo." ;;
        esac
        echo ""
    done
}

# Desinstalar Apache2
desinstalarApache2() {
    if comprobarPaquete apache2 0; then
        {
            dialog --title "$APP_TITULO" --defaultno --yesno "\nInstalación de Apache2\nSe ha detectado que Apache2 ya está instalado en este servidor,\n¿desea continuar con la instalación?\n(Esta acción eliminará su paquete actual y reinstalará Apache2, puede causar pérdida de datos)\nDesea continuar?" 13 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                registrarHoraLog
                sudo apt-get remove apache2 -y >/dev/null 2>>"$LOGFILE"
                if [ $? -ne 0 ]; then
                    mostrarErrorDialog "\n\nError al desinstalar Apache2, compruebe el archivo de log: $LOGFILE para más detalles."
                else
                    registrarHoraLog
                    echo "Paquete Apache2 desinstalado con éxito." >>"$LOGFILE"
                fi
                instalarApache2
                levantarServicio apache2
            else
                levantarServicio apache2
                dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
            fi
        }
    else
        {
            dialog --title "$APP_TITULO" --defaultno --yesno "\nAtención!!\nContinuar con la instalación y configuración de Apache2 en su servidor?" 10 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                instalarApache2
                levantarServicio apache2
            else
                dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
            fi
        }
    fi
    if comprobarServicio apache2 0; then
        levantarServicio apache2
    fi
}

# Desinstalar MySQL8
desinstalarMySQL8() {
    if comprobarPaquete mysql-server 0; then
        {
            dialog --title "$APP_TITULO" --defaultno --yesno "\nInstalación de MySQL8.0\nSe ha detectado una instacia de MySQL en este servidor,\n¿desea continuar con la instalación?\n(Esta acción eliminará su paquete actual y reinstalará MySQL8.0, puede causar pérdida de datos)\nDesea continuar?" 13 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                registrarHoraLog
                sudo apt-get remove mysql-server -y >/dev/null 2>>"$LOGFILE"
                if [ $? -ne 0 ]; then
                    mostrarErrorDialog "\n\nError al desinstalar MySQL, compruebe el archivo de log: $LOGFILE para más detalles."
                else
                    registrarHoraLog
                    echo "Paquete MySQL8.0 desinstalado con éxito." >>"$LOGFILE"
                fi
                instalarMySQL8
                levantarServicio mysql
                establecerPasswordRootMySQL
            else
                levantarServicio mysql
                dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
            fi
        }
    else
        {
            dialog --title "$APP_TITULO" --defaultno --yesno "\nAtención!!\nContinuar con la instalación y configuración de MySQL8x en su servidor?" 10 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                instalarMySQL8
                levantarServicio mysql
                establecerPasswordRootMySQL
            else
                dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
            fi
        }
    fi
    if comprobarServicio mysql 0; then
        levantarServicio mysql
    fi
}

# Función para resumir la configuración del servidor
resumenServidor() {
    if comprobarPaquete apache2 0; then
        apache2_status="Apache2 configurado OK."
    else
        apache2_status="Apache2 NO configurado."
    fi
    if comprobarServicio apache2 0; then
        apache2_servicio="Servicio de Apache2 corriendo OK."
    else
        apache2_servicio="Servicio de Apache2 detenido."
    fi
    if comprobarPaquete mysql-server 0; then
        mysql_status="MySQL configurado OK."
    else
        mysql_status="MySQL NO configurado."
    fi
    if comprobarServicio mysql 0; then
        mysql_servicio="Servicio de MySQL corriendo OK."
    else
        mysql_servicio="Servicio de MySQL detenido."
    fi
    php_versions=$(ls /usr/bin/php* 2>/dev/null | grep -oP '(?<=php)[0-9.]+')
    if [ -z "$php_versions" ]; then
        php_versions="No se encontraron versiones de PHP configuradas en el servidor."
    else
        php_versions=$(echo "$php_versions" | sort | uniq | tr '\n' ' ')
    fi
    if comprobarPhpMyAdmin 0; then
        phpmyadmin_status="phpMyAdmin está configurado OK en este servidor."
    else
        phpmyadmin_status="phpMyAdmin NO está configurado en este servidor."
    fi
    dialog --title "$APP_TITULO" --msgbox "\nConfiguración actual de su servidor:\n\n$apache2_status\n$apache2_servicio\n\n$mysql_status\n$mysql_servicio\n\nVersiones de PHP disponibles:\n$php_versions\n\n$phpmyadmin_status" 22 50
}

# Función para establecer el password del root de MySQL
establecerPasswordRootMySQL() {
    root_password=$(dialog --title "$APP_TITULO" --passwordbox "\nPor favor, introduzca un nuevo password para el usuario root:\n(Tenga en cuenta que los caracteres no serán visibles en la pantalla)" 10 50 3>&1 1>&2 2>&3)
    if [ -z "$root_password" ]; then
        mostrarErrorDialog "\n\nNo se ha introducido ninguna contraseña, por favor, inténtelo de nuevo."
        establecerPasswordRootMySQL
    else
        registrarHoraLog
        sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$root_password'; FLUSH PRIVILEGES;" >/dev/null 2>>"$LOGFILE"
        if [ $? -ne 0 ]; then
            mostrarErrorDialog "\n\nError al establecer la contraseña de MySQL, compruebe el archivo de log: $LOGFILE para más detalles."
        else
            registrarHoraLog
            echo "Contraseña de MySQL establecida correctamente." >>"$LOGFILE"
            dialog --title "$APP_TITULO" --infobox "\nContraseña de MySQL establecida correctamente, recuérdela, la necesitará para acceder a sus bases de datos.\nEspere para continuar con la instalación..." 10 50
            sleep 5
        fi
    fi
}

# Función para instalar phpmyadmin
instalarPhpMyAdmin() {
    dialog --title "$APP_TITULO" --defaultno --yesno "\nAtención!!\nContinuar con la instalación y configuración de phpMyAdmin en su servidor?" 10 50
    respuesta=$?
    if [ $respuesta -eq 0 ]; then
        dialog --title "$APP_TITULO" --infobox "\n\nInstalando y configurando phpMyAdmin, espere..." 10 50
        sleep 2
        if (comprobarPaquete apache2 0 && buscarPaquetesPHPInstalados 0); then
            registrarHoraLog
            sudo apt-get install phpmyadmin -y >/dev/null 2>>"$LOGFILE"
            if [ $? -ne 0 ]; then
                mostrarErrorDialog "\n\nError al instalar phpMyAdmin, compruebe el archivo de log: $LOGFILE para más detalles."
            else
                registrarHoraLog
                echo "Paquete phpMyAdmin instalado con éxito." >>"$LOGFILE"
                sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
                reiniciarServicio apache2
                if [ $? -ne 0 ]; then
                    mostrarErrorDialog "\n\nError al levantar el servicio Apache2, compruebe el archivo de log: $LOGFILE para más detalles."
                else
                    registrarHoraLog
                    echo "Servicio Apache2 levantado con éxito." >>"$LOGFILE"
                    echo "phpMyAdmin configurado con éxito." >>"$LOGFILE"
                    mostrarOKDialog "\n\nphpMyAdmin configurado con éxito."
                fi
            fi
        else
            registrarHoraLog
            echo "Error al instalar phpMyAdmin, compruebe que Apache2 y PHP están instalados en su servidor." >>"$LOGFILE"
            dialog --title "$APP_TITULO" --msgbox "\n\nError al instalar phpMyAdmin, compruebe que Apache2 y PHP están instalados en su servidor." 10 50
        fi
    else
        dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
    fi
}
# Función para desinstalar phpmyadmin
desinstalarPhpMyAdmin() {
    if comprobarPaquete phpmyadmin 0; then
        {
            dialog --title "$APP_TITULO" --defaultno --yesno "\nInstalación de phpMyAdmin\nSe ha detectado que phpMyAdmin ya está instalado en este servidor,\n¿desea continuar con la instalación?\n(Esta acción eliminará su paquete actual y reinstalará phpMyAdmin, puede causar pérdida de datos)\nDesea continuar?" 13 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                registrarHoraLog
                sudo apt-get remove phpmyadmin -y >/dev/null 2>>"$LOGFILE"
                if [ $? -ne 0 ]; then
                    mostrarErrorDialog "\n\nError al desinstalar phpMyAdmin, compruebe el archivo de log: $LOGFILE para más detalles."
                else
                    registrarHoraLog
                    echo "Paquete phpMyAdmin desinstalado con éxito." >>"$LOGFILE"
                fi
                instalarPhpMyAdmin
            else
                dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
            fi
        }
    else
        {
            instalarPhpMyAdmin
        }
    fi
}

# Función para obtener la ip del servidor
obtener_ip() {
    ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1
}

# Función para comprorbar si phpmyadmin está instalado
comprobarPhpMyAdmin() {
    # Comprobar si el paquete phpMyAdmin está instalado
    if dpkg -l | grep -q phpmyadmin; then
        return 0
    else
        return 1
    fi
}
