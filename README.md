# Cenário de exemplo: domínio 'company'

Duas empresas (Provider e Consumer), 1 nó ordenador, 1 canal de comunicação entre os participantes.

## Participantes
   - orderer.company.com
   - peer0.provider.company.com
   - peer1.provider.company.com
   - peer0.consumer.company.com
   - peer1.consumer.company.com

## Pre-Reqs

- Docker >= 18.09.0
- Docker-compose >= 1.24
- Node.js 11.15.x
- npm >= 6.9.0
- curl >= 7.x

## Setup

      $ git clone https://github.com/fsanti68/hyperledger-fabric-1.4-setup
      $ ./downloadBinaries.sh

O script cria a pasta _bin_ contendo os binários do Hyperledger.

## Criando os certificados digitais dos participantes

O cryptogen é o utilitário que cria os certificados X.509. Os certificados podem ser criados com qualquer outra ferramenta, como por ex. o openssl ou certificados de mercado (emissor externo).

O arquivo __crypto-config.yaml__ contém a definição de topologia da rede e permite gerar o conjunto de chaves para as organizações.

Para criar, executar no diretório _network_:

      $ ../bin/cryptogen generate --config=./crypto-config.yaml

## Criando o bloco gênesis e o canal

O _gênesis_ é o bloco inicial da _ledger_ e o comando __configtxgen__:
1. cria o bloco _gênesis_
2. cria o canal de comunicação entre os participantes
3. configura a rede com dados do nó ordenador (_orderer_), os nós âncora de cada organização (no mínimo um peer âncora para cada organização) e o MSP (_membership service provider_), que realiza a autenticação dos usuários e a emissão e validação dos certificados.

Os comandos abaixos realizam estas tarefas:

      $ ../bin/configtxgen -profile OrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
      $ ../bin/configtxgen -profile OrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID companychannel
      $ ../bin/configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ProviderMSPanchors.tx -channelID companychannel -asOrg ProviderMSP
      $ ../bin/configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ConsumerMSPanchors.tx -channelID companychannel -asOrg ConsumerMSP

Todos os artefatos são gerados no diretório network/channel-artifacts.

## Iniciando os containers

      $ docker-compose up -d

### Configurando os peers participantes

      $ docker exec -it cli bash

#### Criando o canal _companychannel_ e adicionando os participantes

Ao usar o container __cli__, o chaveamente entre um peer e outro é realizado pelas variáveis de ambiente:

      $ echo $CORE_PEER_ADDRESS
      $ echo $CORE_PEER_MSPCONFIGPATH
      $ echo $CORE_PEER_LOCALMSPID

      $ peer channel create -o orderer.company.com:7050 -c companychannel -f ./channel-artifacts/channel.tx

Adicionando o peer0 do Provider

      $ peer channel join -b companychannel.block

Adicionando o peer1 do Provider

      $ export CORE_PEER_ADDRESS=peer1.provider.company.com:7051
      $ peer channel join -b companychannel.block

Adicionando o peer0 do Consumer

      $ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/consumer.company.com/users/Admin\@consumer.company.com/msp/
      $ export CORE_PEER_ADDRESS=peer0.consumer.company.com:7051
      $ export CORE_PEER_LOCALMSPID=ConsumerMSP
      $ peer channel join -b companychannel.block

... e o peer1

      $ export CORE_PEER_ADDRESS=peer1.consumer.company.com:7051
      $ peer channel join -b companychannel.block

#### Peer âncora no canal

O último passo da configuração é atualizar o peer âncora no canal com os arquivos gerados pelo __configtxgen__.

Este passo só é executado nos peers âncora (e não em todos). Neste caso, vamos usar somente o peer0 de cada organização:

Seleciona o peer0 da organização 'Provider'

      $ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin\@provider.company.com/msp/
      $ export CORE_PEER_ADDRESS=peer0.provider.company.com:7051
      $ export CORE_PEER_LOCALMSPID=ProviderMSP

Atualizando o canal para o _peer0.provider_:

      $ peer channel update -o orderer.company.com:7050 -c companychannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx

Seleciona o _peer0_ da organização 'Consumer':

      $ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/consumer.company.com/users/Admin\@consumer.company.com/msp/
      $ export CORE_PEER_ADDRESS=peer0.consumer.company.com:7051
      $ export CORE_PEER_LOCALMSPID=ConsumerMSP
      $ peer channel update -o orderer.company.com:7050 -c companychannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx



## Chaincode (_Smart Contract_)

Usando o smart contract de exemplo, _demo_, dentro do diretório _chaincode_. Este exemplo em Node.js provê dois métodos obrigatórios (_Init_ e _Invoke_) e dois métodos de negócio:
- _createEvent_: cadastra um produto na _ledger_
- _getEvent_: consulta um produto na _ledger_

### Instalando o chaincode na rede

Instalando no _peer0_ do _Provider_ pelo __cli__:

      $ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin\@provider.company.com/msp/
      $ export CORE_PEER_ADDRESS=peer0.provider.company.com:7051
      $ export CORE_PEER_LOCALMSPID=ProviderMSP
      $ peer chaincode install -n demo -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/demo

Instalando no _peer1_:

      $ export CORE_PEER_ADDRESS=peer1.provider.company.com:7051
      $ peer chaincode install -n demo -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/demo

Instalando no _peer0_ do _Consumer_:

      $ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/consumer.company.com/users/Admin\@consumer.company.com/msp/
      $ export CORE_PEER_ADDRESS=peer0.consumer.company.com:7051
      $ export CORE_PEER_LOCALMSPID=ConsumerMSP
      $ peer chaincode install -n demo -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/demo

E finalmente o _peer1_ do _Consumer_:

      $ export CORE_PEER_ADDRESS=peer1.consumer.company.com:7051
      $ peer chaincode install -n demo -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/demo

Após instalar o chaincode em todos os peers, é necessário instancia-lo no canal, caso contrário, não estará disponível para uso:

      $ peer chaincode instantiate -o orderer.company.com:7050 -C companychannel -l node -n demo -v 1.0 -c '{"Args":[]}'

Esta execução pode demorar um pouco.

## Executando operações na ledger através do chaincode

Uma vez instalado e instanciado o _chaincode_, é possível executar operações no _ledger_. Por exemplo, a partir do _peer0_ do _Provider_ podemos registrar um produto (_createEvent_):

      $ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/provider.company.com/users/Admin\@provider.company.com/msp/
      $ export CORE_PEER_ADDRESS=peer0.provider.company.com:7051
      $ export CORE_PEER_LOCALMSPID=ProviderMSP

      $ peer chaincode invoke -n demo -c '{"Args":["1abf", "notification 1ABF", "2019-06-12T12:54:02.000"], "Function":"createEvent"}' -C companychannel

E em seguida consultar (_getEvent_):

      $ peer chaincode query -n demo -c '{"Args":["1abf"], "Function":"getEvent"}' -C companychannel

## Inspecionando o chaincode em Node.js em tempo de execução

As instruções abaixo são específicas para _chaincodes_ em _Node.js_ e devem ser executadas fora do ___cli___.

      $ cd chaincode/demo
      $ npm install
      $ CORE_CHAINCODE_ID_NAME="demo:1.0" node --inspect demo.js --peer.address localhost:7052

Em seguida é possível depurar execuções pelo navegador, abrindo _chrome://inspect/devices_, selecionando o arquivo _demo.js_ e em seguida com Ctrl-P abrindo o _demo.js_. Nesta janela é possível incluir breakpoints e acompanhar a execução dos métodos.


## Observações

### Instâncias de Orderers, Kafka e ZooKeeper
No exemplo acima, foi considerado um único orderer. Para ambientes produtivos isso não é recomendado, portanto devem ser criadas instâncias adicionais de orderers e os nós de comunicação (Kafka) e coordenaçao de cluster (zookeeper).

Compare os arquivos de configuração com seus correspondentes _*-prod-sample.yaml_.
