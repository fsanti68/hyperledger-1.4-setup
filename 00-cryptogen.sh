#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Criação dos certificados dos participantes                     *"
echo "*                                                                *"
echo "******************************************************************"
CWD=$PWD
cd network

../bin/cryptogen generate --config=./crypto-config.yaml

cd $CWD
echo "Done."
