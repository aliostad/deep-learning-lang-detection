var log = console.log;
var Scope = require('./xscope.js');

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// test2. create a member
Scope.class('ControllerClass', {
    $inherits: 'Scope',
    memberOfControllerClass: 1
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Scope.class('ControllerA', {
    $inherits: 'ControllerClass',
    memberOfControllerA: 2
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Scope.class('ControllerB', {
    $inherits: 'ControllerClass',
    memberOfControllerB: 3
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Scope.class('MySpecialController', {
    $inherits: 'ControllerClass',
    $type: 'MySpecialController',

    a: {
        $type: 'ControllerA'
    },

    b: {
        $type: 'ControllerB'
    }
});

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var obj = Scope.instantiate('MySpecialController');


log( JSON.stringify(obj, null, 2) );


/*
Expected:

 {
 "$type": "MySpecialController",
 "$inherits": "ControllerClass",
 "memberOfControllerClass": 1,
 "a": {
 "$type": "ControllerA",
 "$inherits": "ControllerClass",
 "memberOfControllerClass": 1,
 "memberOfControllerA": 2
 },
 "b": {
 "$type": "ControllerB",
 "$inherits": "ControllerClass",
 "memberOfControllerClass": 1,
 "memberOfControllerB": 3
 }
 }
 */

