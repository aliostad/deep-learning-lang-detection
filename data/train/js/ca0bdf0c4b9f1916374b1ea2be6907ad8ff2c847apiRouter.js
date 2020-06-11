/*jshint node: true */
// module.exports ==> exports


module.exports = function(app, logControllerApi, tokenSecurityControllerApi, authControllerApi, notifyControllerApi){
    
    app.post('/api/log/*(:token){0,1}', logControllerApi.log);
    app.post('/api/auditlog/*(:token){0,1}', logControllerApi.auditLog);
    
    app.get('/api/log/type/:type',authControllerApi.isAuthenticated,  logControllerApi.getLogs);
    app.get('/api/log',authControllerApi.isAuthenticated,  logControllerApi.getLogs);
    
    app.get('/api/auditlog',authControllerApi.isAuthenticated,  logControllerApi.getAllAuditLogs);
    app.get('/api/auditlog/type/:type',authControllerApi.isAuthenticated,  logControllerApi.getAuditLogsByType);
    app.get('/api/auditlog/type/:type/userid/:userid',authControllerApi.isAuthenticated,  logControllerApi.getAuditLogs);
    app.get('/api/auditlog/ip/:ip',authControllerApi.isAuthenticated,  logControllerApi.getAuditLogsIp);
    app.get('/api/auditlog/userid/:userid',authControllerApi.isAuthenticated,  logControllerApi.getAuditLogsUserId);

    
    app.get('/api/token',authControllerApi.isAuthenticated,  tokenSecurityControllerApi.getTokens);
    app.post('/api/token',authControllerApi.isAuthenticated,  tokenSecurityControllerApi.token);
    app.delete('/api/token/:id',authControllerApi.isAuthenticated,  tokenSecurityControllerApi.deleteToken);
    
    app.post('/api/login', authControllerApi.logIn);
    
    app.get('/api/log/analyze/:from/:to', logControllerApi.analyzeErrorLog);
    
    app.get('/api/notify', notifyControllerApi.notify);

    return app;
}


