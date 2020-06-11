var db = require('clusterz').db.new();
db.ls('worker.js', function onServices (error, services) {
    // error.should.not.be.an.Error
    // services.should.be.an.Array

    // Print clusters pid and number of forks
    services.forEach(function logEachService (service) {
        console.log(service.pid, service.forks.length);
    });

    // Add a new worker
    services.forEach(function forkEachService (service) {
        service.fork();
    });

    // Reload each service
    services.forEach(function reloadEachService (service) {
        service.reload();
    });
});

var service = require('clusterz').service.new();

// Catch errors

service.on('error', function onServiceError (error) {});

// Start service
service.start('worker.js');

// Reload service every 5 minutes
setInterval(function reloadService () {
    service.reload();
}, 1000 * 60 * 5);
