# Aplicación Bash para infraestructura de Servidores Web
## Autor: Rafael Torices

# Descripción
Este script de Bash permite instalar y configurar un servidor web en un sistema operativo Ubuntu/Debian.
Se instalan y se configuran automáticamente los siguientes paquetes/servicios:

- Apache2.2
- MySQL 8.0
- PHP 7.x
- PHP 8.x
- phpMyAdmin

Incluye una opción para saber la IP del servidor y un log con el registro que la aplicación va generando.

# Funcionamiento

Para ejecutar el script, colocarse en la carpeta donde se encuentra el archivo app.sh y ejecutar el siguiente comando:

```bash
sh app.sh
```
Seguir las instrucciones que se muestran en pantalla y utilizar las opciones que se ofrecen.

# Requisitos

- Sistema operativo Ubuntu/Debian
- Tener permisos sudo

# Nota

Comprobar que el usuario que ejecuta el script tiene permisos sudo, que el script tiene permisos de ejecución, que el script se ejecuta en un sistema operativo Ubuntu/Debian y que el directorio tiene permisos de escritura.