#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Iniciando o docker compose                                     *"
echo "*                                                                *"
echo "******************************************************************"

CWD=$PWD
cd network

docker-compose up -d

cd $CWD
echo "Done."

