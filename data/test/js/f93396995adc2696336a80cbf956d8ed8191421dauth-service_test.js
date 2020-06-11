describe('service:AuthService', function(){
    var authService,
        userService,
        $httpBackend;

    beforeEach(function($provide){
        $provide.value('view.main.services.authService.AuthService', mockAuthService)
    });

    beforeEach(function(){
        module('app.services');

        inject(function($injector){
            $httpBackend = $injector.get('$httpBackend');
            authService = $injector.get('view.main.services.authservice.AuthService');
            userService = $injector.get('view.main.services.user.UserService');
        })
    })

})