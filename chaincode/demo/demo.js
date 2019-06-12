
const shim = require('fabric-shim')

var DemoSmartContract = class {

    /**
     * Part of ChaincodeInterface. This method is called once when the chaincode is instantiated in the channel.
     * Can be used to perform an initial load on the ledger. 
     */
    async Init() {
        console.log('Init called')
        return shim.success('Chaincode instantiated');
    }

    /**
     * Part of ChaincodeInterface. This method is called for each transaction performed using this chaincode.
     */
    async Invoke(stub) {
        console.log('Invoke called')

        let ret = stub.getFunctionAndParameters();
        let creator = stub.getCreator();

        if (creator) {
            console.log(creator.mspid + ' invoking...');
        }

        let methodToInvoke = this[ret.fcn];
        if (!methodToInvoke) {
            shim.error(new Error('method name must be informed'));
        }

        try {
            let payload = await methodToInvoke(stub, ret.params);
            return shim.success(payload);
        } catch (e) {
            return shim.error(e);
        }
    }

    /**
     * Registers an event in the ledger (event id, event name and timestamp).
     * @param {Object} stub provided by fabric-shim
     * @param {Array} args array of strings with event information, for example: ["event identifier", "event name", "timestamp"].
     */
    async createEvent(stub, args) {
        if (args.length < 3) {
            throw new Error('Number of arguments is invalid. Provide 3 (event id, event name and timestamp).')
        }

        let eventId = args[0];
        let eventName = args[1];
        let timestamp = args[2];

        let _event = {
            name: eventName,
            timestamp: timestamp
        };

        await stub.putState(eventId, Buffer.from(JSON.stringify(_event)));
    }

    /**
     * Query an event in the ledger using its identifier.
     * @param {Object} stub provided by fabric-shim,
     * @param {Array} args array of string with query parameters. In this case, only one argument is required. E.g, ["eventId"].
     */
    async getEvent(stub, args) {

        if (args.length < 1) {
            throw new Error('Event id must be informed');
        }

        let eventId = args[0];
        var bytes = await stub.getState(eventId);
        if (!bytes || bytes.toString().length <= 0) {
            throw new Error('Event with identifier ' + eventId + ' not found');
        }
        return bytes;
    }
}

let chaincode = new DemoSmartContract()
shim.start(chaincode)