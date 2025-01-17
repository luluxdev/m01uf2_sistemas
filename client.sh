#!/bin/bash

if [ "$1" == "" ]
then
    echo "Debes indicar la dirección del servidor."
    echo "Ejemplo:"
    echo -e "\t$0 127.0.0.1"
    exit 1
fi

IP_SERVER=$1

IP_CLIENT=`ip a | grep "scope global" | xargs | cut -d " " -f 2 | cut -d "/" -f 1`
PORT="2022"

echo "Cliente de Dragón Magia Abuelita Miedo 2022"

echo "1. ENVÍO DE CABECERA"

echo "DMAM $IP_CLIENT" | nc 127.0.0.1 $PORT

DATA=`nc -l $PORT`

echo "3. COMPROBANDO HEADER"
if [ "$DATA" != "OK_HEADER" ] 
then
    echo "ERROR 1: el header se envió incorrectamente" >&2
    exit 1
fi

echo "4. Enviando el FILE_NAME"

FILE_NAME="dragon.txt"
FILE_NAME_MD5=`echo -n "$FILE_NAME" | md5sum | cut -d ' ' -f 1`

echo "FILE_NAME $FILE_NAME $FILE_NAME_MD5" | nc $IP_SERVER $PORT

echo "7. RECIBIENDO COMPROBACIÓN FILE_NAME"
DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_NAME" ]
then
    echo "ERROR 2: el nombre o su hash se enviaron incorrectamente" >&2
    exit 2
fi

echo "8. ENVIANDO CONTENIDO"

cat "client/$FILE_NAME" | nc $IP_SERVER $PORT

echo "11. ENVIANDO HASH DEL CONTENIDO"

FILE_CONTENT_MD5=`md5sum "client/$FILE_NAME" | cut -d ' ' -f 1`
echo "FILE_MD5 $FILE_CONTENT_MD5" | nc $IP_SERVER $PORT

DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_MD5" ]
then
    echo "ERROR 3: el contenido o su hash no coincidieron" >&2
    exit 3
fi

echo "13. PROCESO COMPLETADO CORRECTAMENTE"
