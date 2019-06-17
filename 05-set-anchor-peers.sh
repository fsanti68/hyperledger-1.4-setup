#!/bin/bash

set -e
CWD=$PWD
cd network

echo "******************************************************************"
echo "*                                                                *"
echo "* Seleciona os anchor peers:                                     *"
echo "*    - peer0.provider.company.com                                *"
echo "*    - peer0.consumer.company.com                                *"
echo "*                                                                *"
echo "******************************************************************"
echo "- Set peer0.provider as 'anchor'"
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin@provider.company.com/msp/
export CORE_PEER_ADDRESS=peer0.provider.company.com:7051
export CORE_PEER_LOCALMSPID=ProviderMSP
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli peer channel update -o orderer.company.com:7050 -c companychannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx

echo "- Set peer0.consumer as 'anchor'"
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/consumer.company.com/users/Admin@consumer.company.com/msp/
export CORE_PEER_ADDRESS=peer0.consumer.company.com:7051
export CORE_PEER_LOCALMSPID=ConsumerMSP
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli peer channel update -o orderer.company.com:7050 -c companychannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx

cd $CWD
echo "Done."
