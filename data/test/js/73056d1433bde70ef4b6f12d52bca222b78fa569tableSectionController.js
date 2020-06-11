'use strict';

var tableSectionControllerDirective = function () {
  return {
    require: "macTableSection",
    link: function (scope, element, attrs, controller) {
      var Controller, lastController;
      scope.$watch(function () {
        Controller = scope.$eval(attrs.macTableSectionController);
        if (Controller && Controller !== lastController) {
          controller.table.load(attrs.macTableSection, null, Controller);
          lastController = Controller;
        }
        return lastController;
      });
    }
  };
};

module.exports = tableSectionControllerDirective;
