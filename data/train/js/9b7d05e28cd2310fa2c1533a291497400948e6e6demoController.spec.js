describe("{%= name %} - Controllers",function(){
    var $rootScope,$controller;

    beforeEach(module('{%= sterileName %}'));
    beforeEach(inject(function(_$rootScope_,_$controller_){
        $rootScope = _$rootScope_;
        $controller = _$controller_;
    }));

    describe("demoController",function(){
        var demoControllerScope,demoController;

        beforeEach(function() {
            demoControllerScope = $rootScope.$new();
            demoController = $controller('demoController',{$scope:demoControllerScope});
        });

        it("should have a method called 'hello' that returns 'world'",function(){
            expect(demoController.hello()).toEqual("world");
        });
    });
});
