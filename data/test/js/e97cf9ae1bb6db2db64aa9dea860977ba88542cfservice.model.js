define([
    'utils',
    'services/testOne.service'
], function (utils, serviceTestOne) {

    return {

        _name: 'serviceModel',

        _services: [
            {
                id: 'simpleService',
                service: serviceTestOne,
                method: 'simpleService',
                setModelAttr: 'simpleService'
            },
            {
                id: 'doubleSerialService',
                service: serviceTestOne,
                method: 'doubleSerialService',
                setModelAttr: 'doubleSerialService'
            },
            {
                id: 'doubleSerialServiceRepeated',
                service: serviceTestOne,
                method: 'doubleSerialServiceRepeated',
                setModelAttr: 'doubleSerialServiceRepeated'
            },
            {
                id: 'doubleParallelService',
                service: serviceTestOne,
                method: 'doubleParallelService',
                setModelAttr: 'doubleParallelService'
            },
            {
                id: 'doubleParallelServiceRepeated',
                service: serviceTestOne,
                method: 'doubleParallelServiceRepeated',
                setModelAttr: 'doubleParallelServiceRepeated'
            },
            {
                id: 'validateAndParseService',
                service: serviceTestOne,
                method: 'validateAndParseService',
                params: { code: 1 }
            }
        ],

        _appEvents: {
            'service:doubleSerialService': [
                { action: 'runModelMethod', method: 'callServiceById', value: 'doubleSerialServiceRepeated' }
            ]
        }

    };
});