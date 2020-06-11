angular.module('betaberry.darkhounds.net').factory('serviceSession', ['observable', 'serviceAPI', 'serviceValidator', 'serviceMessages',
    function(observable, serviceAPI, serviceValidator, serviceMessages)         {
        var service         = observable.create();
        
        var _session        = null;
        serviceAPI.$on('logedin', function(data)                                {
            _session = data;
            service.$broadcast('changed');
        });
        serviceAPI.$on('logedout', function()                                   {
            _session = null;
            service.$broadcast('changed');
        });
        serviceAPI.$on('played', function(data)                                 {
            if (!_session) retun;
            _session.credits = data.credits;
            service.$broadcast('changed');
        });
        
        service.login       = function(email, password, callback)               {
            if (!serviceValidator.checkEmail(email)) serviceMessages.add('error', "Invalid Email");
            else if (!serviceValidator.checkPassword(password)) serviceMessages.add('error', "Invalid Password");
            else serviceAPI.login(email, password, callback);
            return service;
        };
        
        service.logout      = function(callback)                                {
            serviceAPI.logout(callback);
            return service;
        };

        service.isOpen      = function()                                        {
            return !!_session;
        };
        service.getName     = function()                                        {
            if (!_session) return "";
            var name    = "";
            if (_session.name)       name += _session.name;
            if (_session.lastName)   name += (name?" ":"") + _session.lastName;
            return name;
        };
        service.getCredits  = function()                                        {
            return _session?_session.credits:0;
        };
        
        return service;
    }
]);
