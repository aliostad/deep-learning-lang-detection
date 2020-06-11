import ServiceManager from "../src/ServiceManager";

class MyAbstractFactory {}
class MyInitializer {}

let serviceManager = new ServiceManager({
    aliases: {
        m: "Tob\\Service\\ModuleService"
    },
    services: {},
    abstract_factories: [
        new MyAbstractFactory()
    ],
    delegators: {},
    shared: {
        "Tob\\Service\\ModuleService": true
    },
    shared_by_default: true,
    factories: {
        "Tob\\Service\\ModuleService": "Tob\\Service\\ModuleServiceFactory",
        "Tob\\Service\\ModuleDataService": "Tob\\Service\\ModuleServiceFactory"
    },
    initializers: [
        new MyInitializer()
    ]
});


let service = serviceManager.get("Tob\\Service\\ModuleService");

let service = serviceManager.build("Tob\\Service\\ModuleService");



serviceManager