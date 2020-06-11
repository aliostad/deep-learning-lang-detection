//
// http://codepen.io/rmirro/pen/diIjl
//
;(function () {
    'use strict';
    console.clear();

    function O() {
    }
    O.prototype.message = 'o';
    O.prototype.data = { message : 'o' };

    function OO() {
    }
    OO.prototype = Object.create( O.prototype );
    OO.constructor = OO;

    function OOO() {
    }
    OOO.prototype = Object.create( OO.prototype );
    OOO.constructor = OOO;


    var o = new O() ,
        oo = new OO() ,
        ooo = new OOO();

    console.log( '%O \n', O );
    console.log( 'o.message: %O , oo.message: %O , ooo.message: %O' , o , oo , ooo );
    console.log( 'o.message: %s , oo.message: %s , ooo.message: %s ' , o.message , oo.message , ooo.message );
    console.log( 'o.data.message: %s , oo.data.message: %s , ooo.data.message: %s \n' , o.data.message , oo.data.message , ooo.data.message );

    oo.message = 'oo';
    oo.data.message = oo.message;
    ooo.message = 'ooo';
    ooo.data.message = ooo.message;
    console.log( 'o.message: %s , oo.message: %s , ooo.message: %s ' , o.message , oo.message , ooo.message );
    console.log( 'o.data.message: %s , oo.data.message: %s , ooo.data.message: %s \n' , o.data.message , oo.data.message , ooo.data.message );

})();