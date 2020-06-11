'use strict';

var enumServiceState = require('../enums/servicestate');

var StateMachineService = {};
StateMachineService[enumServiceState.CREATED] = {};
StateMachineService[enumServiceState.CREATED][enumServiceState.DESISTED] 				= true;
StateMachineService[enumServiceState.CREATED][enumServiceState.PROCESSING] 				= true;
StateMachineService[enumServiceState.CREATED][enumServiceState.ABANDONED_BY_BANK]	 	= true;
StateMachineService[enumServiceState.CREATED][enumServiceState.ABANDONED_BY_GAMBLER] 	= true;
StateMachineService[enumServiceState.CREATED][enumServiceState.ABANDONED_BY_TRADER] 	= true;
StateMachineService[enumServiceState.PROCESSING] = {};
StateMachineService[enumServiceState.PROCESSING][enumServiceState.COMPLETED] 			= true;
StateMachineService[enumServiceState.PROCESSING][enumServiceState.ERROR]	 			= true;

module.exports = StateMachineService;