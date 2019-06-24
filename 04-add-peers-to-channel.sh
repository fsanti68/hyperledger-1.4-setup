#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Adiciona os peers no canal.                                    *"
echo "*                                                                *"
echo "******************************************************************"

usage() {
   echo "Usage: $0"
   echo "As seguintes variáveis de ambiente são requeridas:"
   echo "  - CHANNELID=<channel id>"
   echo "  - PEERID=<peer id>"
   echo "  - COMPANYDOMAIN=<company.com>"
   echo "  - MSPID=<CompanyMSP>"
   exit 1
}

[[ ! -v CHANNELID ]] && usage
[[ ! -v PEERID ]] && usage
[[ ! -v COMPANYDOMAIN ]] && usage
[[ ! -v MSPID ]] && usage

CWD=$PWD
cd network

add_to_channel_command="peer channel join -b $CHANNELID.block"

echo "- Add $1 to channel $CHANNELID"
echo docker exec -it -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$COMPANYDOMAIN/users/Admin@$COMPANYDOMAIN/msp" -e "CORE_PEER_LOCALMSPID=$MSPID" -e "CORE_PEER_ADDRESS=$PEERID.$COMPANYDOMAIN:7051" cli $add_to_channel_command

cd $CWD
echo "Done."
