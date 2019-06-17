#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Eliminando certificados, bloco gênesis e containers docker     *"
echo "*                                                                *"
echo "******************************************************************"

CWD=$PWD
rm -f network/channel-artifacts/*
rm -fr network/crypto-config/ordererOrganizations
rm -fr network/crypto-config/peerOrganizations

for x in $(docker ps | egrep 'fabric-|none' | awk '{ print $1 }'); do
   docker rm $x --force
done
docker volume prune

cd $CWD
echo "Done."
