#!/bin/bash

# Parámetro optativo -d: Borra el entorno y mata los procesos en segundo plano
if [[ "$1" == "-d" ]]; then
    pkill -f "consolidar.sh"
    rm -rf "$HOME/EPNro1"
    echo "Entorno y procesos eliminados exitosamente."
    exit 0
fi

if [[ -z "$FILENAME" ]]; then
    echo "Debe definir previamente la variable de ambiente FILENAME."
    echo "Ejecute export FILENAME=nombre_archivo en la terminal (reemplazando nombre_archivo con el nombre que necesite.)"
    exit 1
fi

opcion_elegida=""

until [[ "$opcion_elegida" == "7" ]]
do
    clear
    echo "---------------------------------"
    echo "       SISTEMA DE ALUMNOS        "
    echo "---------------------------------"
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Listado ordenado por padron"
    echo "4) Top 10 notas mas altas"
    echo "5) Buscar por padron"
    echo "6) Visualizar log"
    echo "7) Salir"
    echo "---------------------------------"
    read -p "Elija una opcion: " opcion_elegida

    case $opcion_elegida in
        1)
            if [ -d "$HOME/EPNro1" ]; then
                echo "El entorno ya existe en $HOME/EPNro1."
            else
                if [[ ! -f "consolidar.sh" ]]; then
                    echo "Error: El archivo consolidar.sh no se encuentra en el directorio actual."
                else
                    mkdir -p "$HOME/EPNro1/entrada"
                    mkdir -p "$HOME/EPNro1/salida"
                    mkdir -p "$HOME/EPNro1/procesado"
                    cp consolidar.sh "$HOME/EPNro1/"
                    chmod +x "$HOME/EPNro1/consolidar.sh"
                    echo "Entorno creado en $HOME/EPNro1."
                fi
            fi
            ;;
        2)
            if [[ ! -f "$HOME/EPNro1/consolidar.sh" ]]; then
                echo "Primero debe crear el entorno (opción 1)."
            else
                if pgrep -f "consolidar.sh" > /dev/null; then
                    echo "El proceso consolidar.sh ya se encuentra corriendo en segundo plano."
                else
                    bash "$HOME/EPNro1/consolidar.sh" &
                    echo "El proceso consolidar.sh ha sido ejecutado correctamente."
                fi
            fi
            ;;
        3)
            if [[ ! -f "$HOME/EPNro1/salida/$FILENAME.txt" ]]; then
                echo "No existe el archivo $FILENAME.txt en la carpeta de salida."
            else
                sort -n "$HOME/EPNro1/salida/$FILENAME.txt"
            fi
            ;;
        4)
            if [[ ! -f "$HOME/EPNro1/salida/$FILENAME.txt" ]]; then
                echo "No existe el archivo $FILENAME.txt en la carpeta de salida."
            else
                # Se ordenan las notas (quinta columna) de mayor a menor y se muestran las 10 primeras
                sort -n -r -k 5 "$HOME/EPNro1/salida/$FILENAME.txt" | head -n 10
            fi
            ;;
        5)
            if [[ ! -f "$HOME/EPNro1/salida/$FILENAME.txt" ]]; then
                echo "No existe el archivo $FILENAME.txt en la carpeta de salida."
            else
                read -p "Ingrese numero de padron: " padron
                grep -E "^$padron[[:space:]]" "$HOME/EPNro1/salida/$FILENAME.txt" || echo "Padron no encontrado."
            fi
            ;;
        6)
            if [[ ! -f "$HOME/EPNro1/procesado.log" ]]; then
                echo "No existe el archivo .log."
            else
                cat "$HOME/EPNro1/procesado.log"
            fi
            ;;
        7)
            echo "Saliendo del sistema"
            ;;
        *)
            echo "Opcion no valida. Intente de nuevo."
            ;;
    esac
    if [[ "$opcion_elegida" != "7" ]]; then
        echo ""
        echo -n "Enter para continuar"
        read
    fi
done
