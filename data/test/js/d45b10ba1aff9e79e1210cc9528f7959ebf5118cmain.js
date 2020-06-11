import MotorController from './modules/MotorController';
import ClampController from './modules/ClampController';
import SensorsController from './modules/SensorsController';
import IA from './IA/IA';
import server from './controlPannel/server';


let log = require('./libs/logger').getLogger(module);

server
    .start()
    .then(function() {
        log.info('[WEB] Server listening on *:8080');
        let modules = {};

        let motorController = new MotorController(0x02, 15);
        modules.motorController = motorController;

        let clampController = new ClampController(0x03, 13);
        modules.clampController = clampController;

        // let sensorsController = new SensorsController(0x04, 11);
        // modules.sensorsController = sensorsController;

        let ia = new IA(modules);
        server.bind(modules);
    })
    .catch(function(err) {
        log.error(err);
    });