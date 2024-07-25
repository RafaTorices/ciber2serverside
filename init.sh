#!/bin/bash

# Importamos config.sh y comprobamos que se carga correctamente
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
# Creamos un fichero log
LOGFILE="log.log"
SCRIPTNAME="config.sh"
load_script "./$SCRIPTNAME"
if [ $? -ne 0 ]; then
    echo "Error grave: falló el import del script $SCRIPTNAME, no se ha podido importar." >>"$LOGFILE"
    echo "........................................."
    echo "${COLOR_YELLOW}${COLOR_BOLD}Ciber2 ServerSide${COLOR_RESET} - ${COLOR_MAGENTA}${COLOR_UNDERLINE}ciber2info@gmail.com${COLOR_RESET}"
    echo "........................................."
    echo "${COLOR_CYAN}Bienvenido al script de config del Servidor, siga las instrucciones por pantalla...${COLOR_RESET}\n"
    echo "No se puede continuar con la configuración debido a un error."
    echo "Consulte el fichero $LOGFILE para ver los detalles"
    exit 1
else
    registrarHoraLog
    echo "Script $SCRIPTNAME cargado con éxito." >>"$LOGFILE"
fi

# Mensaje de inicio
mostrarCabecera
echo "Iniciando script de config del servidor, espere por favor..."

# Llamamos a la función de insertar fecha y hora en el log
registrarHoraLog

# Comprobamos si es necesario el password de sudoer
comprobarSudoer

# Actualizamos el sistema
actualizarSistema

# Instalamos el paquete dialog
instalarDialog
echo "${COLOR_GREEN}Proceso completado con éxito.${COLOR_RESET}"

# Cargamos la interfaz gráfica
echo "\nCargando la interfaz gráfica, espere por favor..."
sleep 4
echo "\n${COLOR_GREEN}Abriendo la interfaz gráfica...${COLOR_RESET}"
sleep 1
# Mostramos la interfaz gráfica
SCRIPTNAME="opciones.sh"
cargamosScript "./$SCRIPTNAME"
if [ $? -ne 0 ]; then
    echo "Error con el import del script $SCRIPTNAME, no se ha podido importar." >>"$LOGFILE"
    mostrarError
    echo "${COLOR_RED}Error al abrir la interfaz gráfica${COLOR_RESET}"
    exit 1
fi
