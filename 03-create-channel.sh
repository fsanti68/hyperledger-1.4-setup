#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Criação do canal no orderer                                    *"
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


create_channel_command="peer channel create -o $ORDERER -c $CHANNELID -f ./channel-artifacts/channel.tx"

# remember: this is the 'cli' path, not the peer one...
echo "- Create channel: $create_channel_command"
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$COMPANYDOMAIN/users/Admin@$COMPANYDOMAIN/msp" -e "CORE_PEER_LOCALMSPID=$MSPID" -e "CORE_PEER_ADDRESS=$PEERID.$COMPANYDOMAIN:7051" cli $create_channel_command

cd $CWD
echo "Done."
