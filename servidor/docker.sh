#!bin/bash

# Función para instalar Docker en el servidor
instalarDocker() {
    registrarHoraLog
    dialog --title "$APP_TITULO" --infobox "\nInstalando Docker en su sistema, espere..." 5 50
    sudo apt-get update -y >/dev/null 2>>"$LOGFILE"
    sudo apt-get upgrade -y >/dev/null 2>>"$LOGFILE"
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg >/dev/null 2>>"$LOGFILE"; done
    sudo apt-get install ca-certificates curl -y >/dev/null 2>>"$LOGFILE"
    sudo install -m 0755 -d /etc/apt/keyrings -y >/dev/null 2>>"$LOGFILE"
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update -y >/dev/null 2>>"$LOGFILE"
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y >/dev/null 2>>"$LOGFILE"
    sudo usermod -aG docker $USER
    echo "Docker instalado correctamente." >>"$LOGFILE"
    dialog --title "$APP_TITULO" --msgbox "\nDocker se ha instalado correctamente.\n*** Deberá reiniciar su servidor para poder usar Docker ***" 10 50
}
