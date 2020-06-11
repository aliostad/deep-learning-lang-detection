module.exports = function(app) {

    var serviceGroups = require('../../server/service-groups');

    app.get('/api/service-groups', function(req, res) {
        res.json(serviceGroups.find());
    });

    app.post('/api/service-groups', function(req, res) {
        res.json(serviceGroups.create(req.body));
    });

    app.get('/api/service-groups/:serviceGroupId', function(req, res) {
        res.json(
            serviceGroups.findById(req.params.serviceGroupId)
        );
    });

    app.post('/api/service-groups/:serviceGroupId', function(req, res) {
        res.json(
            serviceGroups.findById(req.params.serviceGroupId)
                .then(function(service) {
                    if (!service) throw new Error("Service not found");

                    return serviceGroups.update(service, req.body);
                })
        );
    });

    app.delete('/api/service-groups/:serviceGroupId', function(req, res) {
        res.json(
            serviceGroups.findById(req.params.serviceGroupId)
                .then(function(service) {
                    if (!service) throw new Error("Service not found");

                    return serviceGroups.delete(service);
                })
        );
    });

};
