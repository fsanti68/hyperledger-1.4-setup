#!/bin/bash

set -e
CWD=$PWD
cd network

echo "******************************************************************"
echo "*                                                                *"
echo "* Criação do canal 'companychannel' no orderer.company.com       *"
echo "*                                                                *"
echo "******************************************************************"
create_channel_command="peer channel create -o orderer.company.com:7050 -c companychannel -f ./channel-artifacts/channel.tx"

# remember: this is the 'cli' path, not the peer one...
echo "- Create channel: $create_channel_command"
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin@provider.company.com/msp" -e "CORE_PEER_LOCALMSPID=ProviderMSP" -e "CORE_PEER_ADDRESS=peer0.provider.company.com:7051" cli $create_channel_command

cd $CWD
echo "Done."
