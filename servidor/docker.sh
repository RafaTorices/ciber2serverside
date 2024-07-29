#!bin/bash

# Función para instalar Docker en el servidor
instalarDocker() {
    registrarHoraLog
    sudo apt-get update -y >/dev/null 2>>"$LOGFILE"
    sudo apt-get upgrade -y >/dev/null 2>>"$LOGFILE"
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
    sudo apt-get install ca-certificates curl >/dev/null 2>>"$LOGFILE"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update -y >/dev/null 2>>"$LOGFILE"
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y >/dev/null 2>>"$LOGFILE"
    sudo docker run hello-world
    sudo usermod -aG docker $USER
    # newgrp docker
    prueba=$(docker run hello-world | grep "Hello from Docker!")
    echo "Docker instalado correctamente." >>"$LOGFILE"
    echo "Docker Hello World ejecutado correctamente." >>"$LOGFILE"
    dialog --title "$APP_TITULO" --msgbox "\nDocker se ha instalado correctamente en su sistema:\n\n$prueba" 10 50
}
