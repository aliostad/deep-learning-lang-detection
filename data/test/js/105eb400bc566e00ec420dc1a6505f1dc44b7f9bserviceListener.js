var dbManager = require("../db/dbManager").getInstance();
var logger = require("../helpers/logger").getInstance();
var config = require("../config/config");

var ONE_MIN = 1000 * 60;

var serviceMonitors = {};
var services = {};


function setServiceMonitors(monitors) {
    serviceMonitors = monitors;
}

function getServiceMonitors() {
    return serviceMonitors;
}

function getServiceMonitor(service_id) {
    if(!service_id){
        logger.error("service_id required");
        return null;
    }
    return serviceMonitors[service_id];
}

function setServices(serviceList) {
    services = serviceList;
}

function getServices() {
    return services;
}

function getServiceName(service_id) {
    if (services[service_id]) {
        return services[service_id].name;
    } else {
        return '';
    }
}

function getService(service_id) {
    if (services[service_id]) {
        return services[service_id];
    } else {
        return '';
    }
}

function logServicesToDb(service_id) {
    if (serviceMonitors == undefined) {
        return;
    }
    var serviceMonitor = serviceMonitors[service_id];
    if (serviceMonitor == undefined) {
        return;
    }
    var service = services[service_id];
    var serviceState = serviceMonitor.serviceState;
    if (serviceState !== undefined) {
        dbManager.saveServiceState(serviceMonitor, service);
    }
}

function logHealthCheckStateToDb(check_id, service_id) {
    if (serviceMonitors == undefined) {
        return;
    }
    var serviceMonitor = serviceMonitors[service_id];
    if (serviceMonitor == undefined) {
        return;
    }
    dbManager.saveHealthCheckState(check_id, serviceMonitor);
}

function handleMessage(msg) {
    var service_id = msg.service_id;
    var serviceMonitor = serviceMonitors[service_id];
    for (var i in serviceMonitor.rules) {
        var ruleState = serviceMonitor.rules[i].check(msg);
        serviceMonitor.updateRuleState(ruleState);
    }
}

function getHealthCheck(check_id, service_id) {
    if (!check_id) {
        logger.error("check_id need to be specified");
        return;
    }
    
    var serviceMonitors = getServiceMonitors();
    var serviceMonitor;
    if(service_id){
        serviceMonitor = serviceMonitors[service_id];
        if(!serviceMonitor){
            logger.error("Service not found with id " + check_id);
            return null;
        }
        serviceMonitors = {};
        serviceMonitors[service_id] = serviceMonitor;
    }

    for(var x in serviceMonitors){
        serviceMonitor = serviceMonitors[x];
        if (serviceMonitor.healthChecks) {
            var serviceMonitorHealthChecks = serviceMonitor.healthChecks;
            for (var index in serviceMonitorHealthChecks) {
                var healthCheck = serviceMonitorHealthChecks[index];
                if (healthCheck.id == check_id) {
                    return healthCheck;
                } 
            }
        }
    }
    logger.error("No healthcheck found with id " + check_id);
    return null;
}

function getAllHealthChecks(service_id) {

    var serviceMonitors = getServiceMonitors();
    var serviceMonitor;
    if(service_id){
        serviceMonitor = serviceMonitors[service_id];
        serviceMonitors = {};
        serviceMonitors[service_id] = serviceMonitor;
    }
    var healthChecks = {};
    for(var x in serviceMonitors){
        serviceMonitor = serviceMonitors[x];
        if (serviceMonitor && serviceMonitor.healthChecks) {
            healthChecks[serviceMonitor.service_id] = serviceMonitor.healthChecks;
        } 
    }
    
    return healthChecks;
}

function removeHealthCheck(service_id, check_id){
    if (check_id == undefined || service_id == undefined) {
        logger.error("check_id need to be specified");
        return;
    }
    var serviceMonitors = getServiceMonitors();
    var serviceMonitor = serviceMonitors[service_id];
    if(serviceMonitor){
        if(serviceMonitor.healthChecks){
            console.log("removed health check");
            delete serviceMonitor.healthChecks[check_id];
        }
        if(serviceMonitor.serviceState){
            if(serviceMonitor.serviceState.checkStates){
                console.log("removed health check state");
                delete serviceMonitor.serviceState.checkStates[check_id];
            }
        }
    }
}

function addService(service){
    if(service && service.id){
        services[service.id] = service;
        //service.timer = config.startDBTimer(service);
    }
}

exports.logServicesToDb = logServicesToDb;
exports.logHealthCheckStateToDb = logHealthCheckStateToDb;
exports.setServiceMonitors = setServiceMonitors;
exports.getServiceMonitors = getServiceMonitors;
exports.getServiceMonitor = getServiceMonitor;
exports.getServiceName = getServiceName;
exports.getServices = getServices;
exports.setServices = setServices;
exports.getService = getService;
exports.handleMessage = handleMessage;
exports.getHealthCheck = getHealthCheck;
exports.getAllHealthChecks = getAllHealthChecks;
exports.removeHealthCheck = removeHealthCheck;
exports.addService = addService;