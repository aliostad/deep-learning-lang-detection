'use strict';

describe('casablanca.services', function () {

    beforeEach(module('casablanca.services'));

    describe('InfoService', function () {

        var infoService;
        beforeEach(inject(function (_InfoService_) {
            infoService = _InfoService_;
        }));

        //it('Should be Hello World from a Service', function () {
        //    expect(infoService.getInfo()).toBe("Hello World from a Service");
        //});
    });


    describe('LoginService', function () {
        var LoginService;
        beforeEach(inject(function (_LoginService_) {
            LoginService = _LoginService_;
        }));

        it('Should return user123', function () {
            var username = 'user123';
            LoginService.setUsername(username);
            expect(LoginService.getUsername()).toEqual(username);
        });

        it('Should return pass123', function () {
            var password = 'pass123';
            LoginService.setPassword(password);
            expect(LoginService.getPassword()).toEqual(password);
        });
    });
});