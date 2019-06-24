#!/bin/bash

set -e

echo "******************************************************************"
echo "*                                                                *"
echo "* Instanciar o chaincode no canal                                *"
echo "*                                                                *"
echo "******************************************************************"

usage() {
   echo "Usage: $0 <chaincode name> <function name> <arguments>"
   echo "As seguintes variáveis de ambiente são requeridas:"
   echo "  - CHANNELID=<channel id>"
   echo "  - PEERID=<peerid>"
   echo "  - COMPANYDOMAIN=<company.com>"
   echo "  - MSPID=<CompanyMSP>"
   exit 1
}

[[ $# -lt 2 ]] && usage
[[ ! -v CHANNELID ]] && usage
[[ ! -v PEERID ]] && usage
[[ ! -v COMPANYDOMAIN ]] && usage
[[ ! -v MSPID ]] && usage

CWD=$PWD
cd network

chaincode=$1
functionName=$2
functionArgs='{"Function":"'$functionName'", "Args":['
if [[ $# -gt 2 ]]; then
   shift
   shift
   while test $# -gt 0
   do
      functionArgs=$functionArgs'"'$1'"',
      shift
   done
   functionArgs=${functionArgs::-1}']}'
else
   functionArgs+=']}'
fi

instantiate_chaincode="peer chaincode query -n $chaincode -c '$functionArgs' -C $CHANNELID"
echo $instantiate_chaincode

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$COMPANYDOMAIN/users/Admin\@$COMPANYDOMAIN/msp/
export CORE_PEER_ADDRESS=$PEERID.$COMPANYDOMAIN:7051
export CORE_PEER_LOCALMSPID=$MSPID
docker exec -it -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" cli $instantiate_chaincode

cd $CWD
echo "Done."
