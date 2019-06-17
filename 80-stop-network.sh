#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Interrompendo o docker compose                                 *"
echo "*                                                                *"
echo "******************************************************************"

CWD=$PWD
cd network

docker-compose down

cd $CWD
echo "Done."

