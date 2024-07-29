#!bin/bash

# Función para instalar Docker en el servidor
instalarDocker() {
    if command -v docker &>/dev/null; then
        local version=$(docker --version)
        dialog --title "$APP_TITULO" --msgbox "\nDocker ya está instalado en su sistema.\n\n$version" 10 50
        echo "Docker ya está instalado en su sistema: $version" >>"$LOGFILE"
    else
        # Actualizamos el sistema
        registrarHoraLog
        sudo apt-get update -y >/dev/null 2>>"$LOGFILE"
        sudo apt-get upgrade -y >/dev/null 2>>"$LOGFILE"
        # Instala los paquetes necesarios para permitir que apt use un repositorio sobre HTTPS
        sudo apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            software-properties-common >/dev/null 2>>"$LOGFILE"
        # Agrega la clave GPG oficial de Docker
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg >/dev/null 2>>"$LOGFILE"
        # Configura el repositorio estable de Docker
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null 2>>"$LOGFILE"
        # Actualiza el índice de paquetes nuevamente
        sudo apt-get update -y >/dev/null 2>>"$LOGFILE"
        # Instala Docker Engine
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io >/dev/null 2>>"$LOGFILE"
        # Agrega tu usuario al grupo docker para evitar usar sudo al ejecutar comandos Docker
        sudo usermod -aG docker $USER
        newgrp docker
        # Verifica que Docker esté instalado correctamente
        sudo docker --version >/dev/null 2>>"$LOGFILE"
        echo "Docker instalado correctamente." >>"$LOGFILE"
        local dockerrun=$(docker run hello-world | grep "Hello from Docker!")
        echo "$dockerrun" >>"$LOGFILE"
        echo "Docker Hello World ejecutado correctamente." >>"$LOGFILE"
        dialog --title "$APP_TITULO" --msgbox "\nDocker se ha instalado correctamente en su sistema:\n$dockerrun" 10 50
    fi

}
