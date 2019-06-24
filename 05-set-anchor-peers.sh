#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Seleciona os anchor peers.                                     *"
echo "*                                                                *"
echo "******************************************************************"

usage() {
   echo "Usage: $0"
   echo "As seguintes variáveis de ambiente são requeridas:"
   echo "  - CHANNELID=<channel id>"
   echo "  - ORDERER=<orderer.company.com:7050>"
   echo "  - PEERID=<peer id>"
   echo "  - COMPANYDOMAIN=<company.com>"
   echo "  - MSPID=<CompanyMSP>"
   exit 1
}

[[ ! -v CHANNELID ]] && usage
[[ ! -v ORDERER ]] && usage
[[ ! -v PEERID ]] && usage
[[ ! -v COMPANYDOMAIN ]] && usage
[[ ! -v MSPID ]] && usage

CWD=$PWD
cd network

echo "- Set $PEERID.$COMPANYDOMAIN as 'anchor'"
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$COMPANYDOMAIN/users/Admin@$COMPANYDOMAIN/msp/
export CORE_PEER_ADDRESS=$PEERID.$COMPANYDOMAIN:7051
export CORE_PEER_LOCALMSPID=$MSPID
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli peer channel update -o $ORDERER -c $CHANNELID -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx

cd $CWD
echo "Done."
