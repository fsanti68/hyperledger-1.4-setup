#!/bin/bash

set -e
CWD=$PWD
cd network

echo "******************************************************************"
echo "*                                                                *"
echo "* Instanciar o chaincode 'demo' no canal                         *"
echo "*                                                                *"
echo "******************************************************************"
instantiate_chaincode="peer chaincode instantiate -o orderer.company.com:7050 -C companychannel -l node -n demo -v 1.0 -c '{\"Args\":[]}'"

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin\@provider.company.com/msp/
export CORE_PEER_ADDRESS=peer0.provider.company.com:7051
export CORE_PEER_LOCALMSPID=ProviderMSP
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli $instantiate_chaincode

cd $CWD
echo "Done."
