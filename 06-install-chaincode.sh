#!/bin/bash

set -e
CWD=$PWD
cd network

echo "******************************************************************"
echo "*                                                                *"
echo "* Instalar o chaincode 'demo'                                    *"
echo "*                                                                *"
echo "******************************************************************"
install_chaincode="peer chaincode install -n demo -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/demo"

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin\@provider.company.com/msp/
export CORE_PEER_ADDRESS=peer0.provider.company.com:7051
export CORE_PEER_LOCALMSPID=ProviderMSP
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli $install_chaincode

export CORE_PEER_ADDRESS=peer1.provider.company.com:7051
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli $install_chaincode

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/consumer.company.com/users/Admin\@consumer.company.com/msp/
export CORE_PEER_ADDRESS=peer0.consumer.company.com:7051
export CORE_PEER_LOCALMSPID=ConsumerMSP
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli $install_chaincode

export CORE_PEER_ADDRESS=peer1.consumer.company.com:7051
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli $install_chaincode

cd $CWD
echo "Done."
