#!/bin/bash

# Menú de pre-opciones con dialog en Bash para mostrar al usuario las opciones disponibles

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

# Función para ejecutar el script1
ejecutar_script1() {
    echo "Ejecutando script1..."
    # Aquí puedes poner el comando para ejecutar tu script1
    ./script1.sh
}

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
        sh servidor.sh
        break
        ;;
    2) ejecutar_script2 ;;
    3) ejecutar_script3 ;;
    4) ejecutar_script4 ;;
    5)
        echo "Cerrando Ciber2 Server Side..."
        loading
        echo "\n¡Hasta luego!\n"
        break
        ;;
    *) echo "Opción inválida. Por favor, intente de nuevo." ;;
    esac
    echo ""
done
