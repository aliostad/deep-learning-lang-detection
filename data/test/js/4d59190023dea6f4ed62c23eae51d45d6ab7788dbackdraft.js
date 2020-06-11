var Backdraft = function (config) {
    var meta    = {source: 'backdraft.js'};

    var api     = require('./loader')(config);

        var sessionConfig = {
            secret: api.config.server.sessionSecret
        };
        if (api.config.database_auth.name && api.config.database_auth.host && api.config.database_auth.port) {
            sessionConfig = {
                secret: api.config.server.sessionSecret,
                store: new api.MongoStore({
                    db: api.config.database_auth.name,
                    host: api.config.database_auth.host,
                    port: api.config.database_auth.port
                })
            };
        } 


        // Configuration
        //api.app.configure(function () {

            if (config.app.templates) {
              api.app.set('views', config.app.templates);
              api.app.set('view engine', 'jade');
              api.app.set('view options', { layout: false });
            }

            if (config.app.public) {
              api.app.use(api.serveStatic(config.app.public));
            }

            api.app.use(api.bodyParser.json());
            api.app.use(api.bodyParser.urlencoded());
            api.app.use(api.methodOverride());

            api.app.use(api.cookieParser());
            api.app.use(api.session(sessionConfig));

            api.app.use(api.auth.passport.initialize());
            api.app.use(api.auth.passport.session());

            /*
                api.app.use(express.csrf());

                api.app.use( function (req, res, next) {
                res.locals._csrf = req.csrfToken();

                res.header("Cache-Control", "no-cache, no-store, must-revalidate");
                res.header("Pragma", "no-cache");
                res.header("Expires", 0);
                res.header("X-Content-Type-Options", "nosniff");

                next();
                });
            */
            api.app.use(api.security.crossDomain);

        //});


        // Setup routes
        require('./routes')(api);
        var implementPath = (api.config.api.path) ? api.config.api.path : api.config.app.path;
        api.app.use(implementPath, api.router);

        api.prototype = {
            config: config,
            log: api.log,
            routes: {
              get: function(name, cb) { api.app.get(name, cb)},
              put: function(name, cb) { api.app.put(name, cb)},
              post: function(name, cb) { api.app.post(name, cb)},
              delete: function(name, cb) { api.app.delete(name, cb)}
            },
            authenticated: {
              get: function(name, cb) { api.app.get(name, api.auth.ensureAuthenticated, cb)},
              put: function(name, cb) { api.app.put(name, api.auth.ensureAuthenticated, cb)},
              post: function(name, cb) { api.app.post(name, api.auth.ensureAuthenticated, cb)},
              delete: function(name, cb) { api.app.delete(name, api.auth.ensureAuthenticated, cb)}
            },          
            model: api.model,
            view: api.view,
            controller: api.controller
        };

        api.handler.serverProcess(
                api.http.createServer(api.app).listen(api.config.server.port, api.config.server.host, function () {
                    api.log('Listening on upstream url: ' + api.config.server.host + ':' + api.config.server.port);
                })
        );


    // Error Handler
    api.app.use(api.handler.error);

    // Not Found Handler
    //api.app.use(api.handler.notFound);

    return api;
};

module.exports = function (settings) {
    var api = new Backdraft(settings);
    return api.prototype;
};
