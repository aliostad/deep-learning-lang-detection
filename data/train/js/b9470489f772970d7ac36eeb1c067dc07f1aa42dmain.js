define(
  ["./macros/controller","./macros/array-controller","./macros/object-controller","exports"],
  function(__dependency1__, __dependency2__, __dependency3__, __exports__) {
    "use strict";
    var controller = __dependency1__["default"] || __dependency1__;
    var arrayController = __dependency2__["default"] || __dependency2__;
    var objectController = __dependency3__["default"] || __dependency3__;

    __exports__.controller = controller;
    __exports__.arrayController = arrayController;
    __exports__.objectController = objectController;
  });