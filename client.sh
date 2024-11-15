#!/bin/bash


PORT="2022"

echo "Cliente de Dragón Magia Abuelita Miedo 2022"

echo "1. ENVÍO DE CABECERA"

echo "DMAM" | nc 127.0.0.1 $PORT

DATA=`nc -l $PORT`

echo "3. COMPROBANDO HEADER"
# SI DATA ES DIFERENTE A OK_HEADER, MENSAJE
# DE ERROR Y EXIT 1
if [ "$DATA" != "OK_HEADER" ] 
then
	echo "ERROR 1: el header se envió incorrectamente"
	exit 1
fi

echo "4. Enviando el FILE_NAME"

FILE_NAME="dragon.txt"

echo "FILE_NAME $FILE_NAME" | nc localhost $PORT

echo "7. RECIBIENDO COMPROBACIÓN FILE_NAME"
DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_NAME" ]
then
	echo "ERROR 2: el nombre se envió incorrectamente"
	exit 2
fi

echo "8. ENVIANDO CONTENIDO"

cat client/$FILE_NAME | nc localhost $PORT
