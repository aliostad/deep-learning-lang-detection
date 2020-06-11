exports.attachHandlers = function attachHandlers(server) {
    /* Loading common file used in whole admin module */
    require(__dirname + '/admin.module.js')(server);
    /* Dashboard controller */
    require(__dirname + '/controller/admin.controller.dashboard.js')(server);
    /* Products controller */
    require(__dirname + '/controller/admin.controller.products.js')(server);
    /* Clients controller */
    require(__dirname + '/controller/admin.controller.clients.js')(server);
    /* Profile controller */
    require(__dirname + '/controller/admin.controller.profile.js')(server);
    /* Logs controller */
    require(__dirname + '/controller/admin.controller.logs.js')(server);
};