#!/bin/bash

while true;
do
    for archivo in "$HOME/EPNro1/entrada/"*.txt; 
    do
        if [[ -f "$archivo" ]]; then
            cat "$archivo" >> "$HOME/EPNro1/salida/$FILENAME.txt"
            echo "$(date '+%d/%m/%Y %H:%M:%S') - Procesado archivo $(basename "$archivo")" >> "$HOME/EPNro1/procesado.log"
            mv "$archivo" "$HOME/EPNro1/procesado/"
        fi
    done

    sleep 5
done
