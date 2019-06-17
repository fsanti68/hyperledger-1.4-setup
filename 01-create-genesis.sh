#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Criação do bloco genesis e do canal                            *"
echo "*                                                                *"
echo "******************************************************************"

CWD=$PWD
cd network

../bin/configtxgen -profile OrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
../bin/configtxgen -profile OrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID companychannel
../bin/configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ProviderMSPanchors.tx -channelID companychannel -asOrg ProviderMSP
../bin/configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ConsumerMSPanchors.tx -channelID companychannel -asOrg ConsumerMSP


cd $CWD
echo "Done."
