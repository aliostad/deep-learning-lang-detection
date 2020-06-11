/**
 * @author Charlie Calvert
 */


$(document).ready(function() {
    "use strict";
    function Foo() {}  // constructor
    Foo.prototype = { name: "Foo" };
    Foo.bar = 333;
    var foo = new Foo();
    console.log(foo.name);

    var showPrototype = new elf.ShowPrototype();
    showPrototype.showPrototype(foo);

    showPrototype.bar = 3;
    Array.prototype.foo = "Goober";    
    var a = new Array();
    showPrototype.showPrototype(a);
    showPrototype.display(a.foo);
    a.bar = 5;
    showPrototype.showKeys(a);  //jshint ignore: line
    showPrototype.showKeys(new Object()); //jshint ignore: line
    showPrototype.showKeys(showPrototype);
    showPrototype.showKeys(foo);
    showPrototype.showKeys(Foo);
    showPrototype.showPrototype(new Object());
});
