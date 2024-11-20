#!/bin/bash


PORT="2022"

echo "Servidor de Dragón Magia Abuelita Miedo 2022"

echo "0. ESCUCHAMOS"

DATA=`nc -l $PORT`

HEADER=`echo "$DATA" | cut -d " " -f 1`
IP=`echo $DATA | cut -d " " -f 2`

if [ "$HEADER" != "DMAM" ]
then
	echo "ERROR 1: Cabecera incorrecta"
	echo "KO_HEADER" | nc $IP $PORT
	exit 1
fi

echo "La IP del cliente es: $IP"

echo "2. CHECK OK - Enviando OK_HEADER"
echo "OK_HEADER" | nc $IP $PORT
DATA=`nc -l $PORT`

echo "5. COMPROBANDO PREFIJO"

PREFIX=`echo "$DATA" | cut -d ' ' -f 1`
FILE_NAME=`echo "$DATA" | cut -d ' ' -f 2`

if [ "$PREFIX" != "FILE_NAME" ]
then
	echo "ERROR 2: Prefijo incorrecto"
	echo "KO_FILE_NAME" | nc $IP $PORT
	exit 2
fi

echo "6. ENVIANDO OK_FILE_NAME"

echo "OK_FILE_NAME" | nc $IP $PORT

DATA=`nc -l $PORT`

echo "9. Recibiendo el dragón"
mkdir -p server
echo "$DATA" > "server/$FILE_NAME"
