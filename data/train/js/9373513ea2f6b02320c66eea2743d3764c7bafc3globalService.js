app.service('global', function($cookieStore, $location, $filter) {
    var globalService = {};
    globalService.user = null;
    globalService.isAuth = function (){
        if (globalService.user == null) {
            globalService.user = $cookieStore.get('user');
        }
        return (globalService.user != null);
    };
    globalService.setUser = function(newUser) {
        globalService.user = newUser;
        if (globalService.user == null) $cookieStore.remove('user');
        else $cookieStore.put('user', globalService.user);
    };
    globalService.getUser = function() {
        return globalService.user;
    };
    return globalService;
});
