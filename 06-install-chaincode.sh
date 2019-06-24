#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Instalar o chaincode em um peer                                *"
echo "* Obs: precisa ser executado me cada peer da rede                *"
echo "*                                                                *"
echo "******************************************************************"

usage() {
   echo "Usage: $0 chaincode_name version"
   echo "As seguintes variáveis de ambiente são requeridas:"
   echo "  - PEERID=<peerid>"
   echo "  - COMPANYDOMAIN=<company.com>"
   echo "  - MSPID=<CompanyMSP>"
   exit 1
}

[[ $# -lt 2 ]] && usage
[[ ! -v PEERID ]] && usage
[[ ! -v COMPANYDOMAIN ]] && usage
[[ ! -v MSPID ]] && usage

install_chaincode="peer chaincode install -n $1 -v $2 -l node -p /opt/gopath/src/github.com/chaincode/$1"

CWD=$PWD
cd network

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$COMPANYDOMAIN/users/Admin\@$COMPANYDOMAIN/msp/
export CORE_PEER_ADDRESS=$PEERID.$COMPANYDOMAIN:7051
export CORE_PEER_LOCALMSPID=$MSPID
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli $install_chaincode

cd $CWD
echo "Done."
