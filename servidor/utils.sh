#!bin/bash

# Script de utilidades de la aplicación Ciber2ServerSide

# Función para mostrar las opciones de utilidades
mostrarOpcionesUtilidades() {
    while true; do
        opcion=$(dialog --clear --title "$APP_TITULO" \
            --menu "\nSeleccione la utilidad a ejecutar:" 15 50 4 \
            1 "Mostrar dirección IP" \
            2 "Ejecutar Pin" \
            3 "Instalar SMB/FTP" \
            4 "Configurar UFW" \
            0 "Volver al menú principal" \
            3>&1 1>&2 2>&3)
        clear
        case $opcion in
        1)
            dialog --title "$APP_TITULO" --msgbox "\nDirección IP(s):\n$(obtener_ip)" 10 50
            ;;
        2)
            ejecutar_ping
            ;;
        3)
            dialog --title "$APP_TITULO" --defaultno --yesno "\nAtención!!\nEsta acción instalará y configurará SMB/FTP en su sistema.\nEsta acción realizará cambios en su servidor y podrá causar pérdida de datos, está seguro de continuar?" 13 50
            respuesta=$?
            if [ $respuesta -eq 0 ]; then
                instalar_smb_ftp
            else
                dialog --title "$APP_TITULO" --msgbox "\n\nOperación cancelada, no se han producido cambios en su servidor." 10 50
            fi
            ;;
        0)
            break
            ;;
        *) echo "\nOpción inválida. Por favor, intente de nuevo." ;;
        esac
        echo ""
    done
}

# Función para obtener la ip del servidor
obtener_ip() {
    ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1
}

# Función para realizar ping y mostrar el resultado
ejecutar_ping() {
    # Solicitar dirección IP o nombre de host al usuario
    local destino=$(dialog --title "$APP_TITULO" --inputbox "Ingrese la dirección IP o nombre de host:" 8 40 3>&1 1>&2 2>&3 3>&-)
    # Verificar si se ingresó un valor
    if [ -z "$destino" ]; then
        dialog --title "$APP_TITULO" --msgbox "No se ingresó ninguna dirección IP o nombre de host." 8 40
    else
        dialog --title "$APP_TITULO" --infobox "Realizando ping a $destino..." 8 40 &
        # Realizar ping y guardar el resultado
        local resultado=$(ping -c 4 $destino 2>&1)
        # Mostrar resultado en un msgbox
        dialog --title "$APP_TITULO" --msgbox "Resultado de ping a: $destino\n\n$resultado" 20 80
    fi
}

# Función para instalar y configurar SMB/FTP
instalar_smb_ftp() {
    # Instalar paquetes necesarios
    dialog --title "$APP_TITULO" --infobox "Instalando paquetes necesarios..." 8 40
    apt-get install -y samba samba-common smbclient cifs-utils vsftpd
    # Configurar Samba
    dialog --title "$APP_TITULO" --infobox "Configurando Samba..." 8 40
    cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
    echo -e "[global]\nworkgroup = WORKGROUP\nserver string = %h server\nsecurity = user\nmap to guest = bad user\n" >/etc/samba/smb.conf
    # Crear usuario para Samba
    dialog --title "$APP_TITULO" --infobox "Creando usuario para Samba..." 8 40
    smbpasswd -a root
    # Configurar FTP
    dialog --title "$APP_TITULO" --infobox "Configurando FTP..." 8 40
    cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
    echo -e "listen=NO\nlisten_ipv6=YES\nanonymous_enable=NO\nlocal_enable=YES\nwrite_enable=YES\nlocal_umask=022\nchroot_local_user=YES\nallow_writeable_chroot=YES\n" >/etc/vsftpd.conf
    # Reiniciar servicios
    dialog --title "$APP_TITULO" --infobox "Reiniciando servicios..." 8 40
    systemctl restart smbd
    systemctl restart nmbd
    systemctl restart vsftpd
    # Mostrar mensaje de finalización
    dialog --title "$APP_TITULO" --msgbox "SMB/FTP instalado y configurado correctamente." 8 40
}
