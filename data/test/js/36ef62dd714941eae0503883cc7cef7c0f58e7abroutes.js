var meta = {source: 'routes.js'};

module.exports = function (api) {
    api.corsOptions = {
        origin: api.config.server.hostClient,
        methods: ['GET', 'PUT', 'POST']
    };

    api.router.options('/:controller', api.cors(api.corsOptions));

    api.router.get('/authenticate', api.cors(api.corsOptions), api.auth.buildSession);
    api.router.post('/login', api.cors(api.corsOptions), api.auth.login, api.auth.buildSession);
    api.router.post('/register', api.cors(api.corsOptions), api.response.register);
    api.router.post('/logout', api.cors(api.corsOptions), api.auth.logout);
    api.router.get('/user', api.cors(api.corsOptions), api.auth.ensureAuthenticated, api.response.userInfo);
};

