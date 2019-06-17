#!/bin/bash

set -e
CWD=$PWD
cd network

echo "******************************************************************"
echo "*                                                                *"
echo "* Adiciona os peers no canal 'companychannel':                   *"
echo "*    - peer0.provider.company.com                                *"
echo "*    - peer1.provider.company.com                                *"
echo "*    - peer0.consumer.company.com                                *"
echo "*    - peer1.consumer.company.com                                *"
echo "*                                                                *"
echo "******************************************************************"
add_to_channel_command="peer channel join -b companychannel.block"

echo "- Add peer0.provider to channel"
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin@provider.company.com/msp" -e "CORE_PEER_LOCALMSPID=ProviderMSP" -e "CORE_PEER_ADDRESS=peer0.provider.company.com:7051" cli $add_to_channel_command

echo "- Add peer1.provider to channel"
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin@provider.company.com/msp" -e "CORE_PEER_LOCALMSPID=ProviderMSP" -e "CORE_PEER_ADDRESS=peer1.provider.company.com:7051" cli $add_to_channel_command

echo "- Add peer0.consumer to channel"
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/consumer.company.com/users/Admin@consumer.company.com/msp" -e "CORE_PEER_LOCALMSPID=ConsumerMSP" -e "CORE_PEER_ADDRESS=peer0.consumer.company.com:7051" cli $add_to_channel_command

echo "- Add peer1.consumer to channel"
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/consumer.company.com/users/Admin@consumer.company.com/msp" -e "CORE_PEER_LOCALMSPID=ConsumerMSP" -e "CORE_PEER_ADDRESS=peer1.consumer.company.com:7051" cli $add_to_channel_command

cd $CWD
echo "Done."
