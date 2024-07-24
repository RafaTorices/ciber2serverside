#!/bin/bash
# Función para mostrar un efecto de carga mediante puntos suspensivos

loading() {
    # Número total de puntos (suspensivos) a mostrar
    total_dots=1
    # Tiempo entre la actualización (en segundos)
    interval=1
    # Duración total del efecto de carga (en segundos)
    duration=8
    # Obtener el tiempo actual en segundos desde la época
    start_time=$(date +%s)
    # Realizar el efecto de carga
    while true; do
        # Calcular el tiempo transcurrido
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))
        # Salir si el tiempo transcurrido es mayor o igual a la duración
        if [ $elapsed_time -ge $duration ]; then
            break
        fi
        # Imprimir los puntos
        for i in $(seq 1 $total_dots); do
            printf "%${i}s" | tr ' ' '.'
            sleep $interval
        done
    done
    # OPCIONAL: Imprimir un mensaje final cuando la carga haya terminado
}
