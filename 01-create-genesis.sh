#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Criação do bloco genesis e do canal                            *"
echo "*                                                                *"
echo "******************************************************************"

usage() {
   echo "Usage: $0 <list of MSP id's>"
   echo "As seguintes variáveis de ambiente são requeridas:"
   echo "  - CHANNELID=<channel id>"
   exit 1
}

[[ ! -v CHANNELID ]] && usage

CWD=$PWD
cd network

../bin/configtxgen -profile OrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
../bin/configtxgen -profile OrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNELID

shift
while test ${#} -gt 0
do
   ../bin/configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/$1anchors.tx -channelID $CHANNELID -asOrg $1
   shift
done

cd $CWD
echo "Done."
