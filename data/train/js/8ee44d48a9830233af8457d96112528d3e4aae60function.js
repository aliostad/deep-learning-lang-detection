console.log('1:');
(function() {
    console.log(add(1, 2));
    function add(a, b) {
        return a + b;
    }
})();

console.log('2:');
(function() {
    //console.log(add(1, 2)); // ERROR
    var add = function (a, b) {
        return a + b;
    };
})();

console.log('3:');
a = 'a';
var o = {a: 'b'};
function showA() {
    console.log(this.a);
}
showA();
o.showA = showA;
o.showA();

console.log('4:');
function add(a, b) {
    return a + b;
}
console.log(add.name);
console.log(add.length);

console.log('5:');
a = 'a';
var o = {a: 'b'};
function showA() {
    console.log(this.a);
}
showA.call(this); // different in node and browser
showA.call(o);
