describe('Controller: todo-list', function() {
    'use strict';
   var controller,
        scope;
   // Refresh the $filter every time.
   beforeEach(module('todoListControllerDemo'));
   beforeEach(inject(function(_$rootScope_, $controller) {
       scope = _$rootScope_.$new();
       controller = $controller('TodoListController',
        {$scope: scope});
        })
    );

    it('should start empty', function() {
        expect(controller.list.length).to.equal(0);
    });
    
   it('should add items', function() {
       controller.itemText = 'First item';
       controller.add(controller.itemText);
       expect(controller.list.length).to.equal(1);
       controller.itemText = 'Second item';
       controller.add(controller.itemText);
       expect(controller.list.length).to.equal(2);
       controller.remove(1);
       expect(controller.list.length).to.equal(1);
   });

});
