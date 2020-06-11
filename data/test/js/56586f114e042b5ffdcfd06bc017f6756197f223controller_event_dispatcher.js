module.exports = (function() {

  function ControllerEventDispatcher(controller) {
    this.controller = controller;
  };

  ControllerEventDispatcher.withController = function(controller) {
    return new this(controller);
  };

  ControllerEventDispatcher.prototype.dispatchEvent = function(event) {
    switch (event.which) {
      case 13:
        this.controller.onKeyEnterPressed();
        break;
      case 37:
        this.controller.onKeyLeftPressed();
        break;
      case 38:
        this.controller.onKeyUpPressed();
        break;
      case 39:
        this.controller.onKeyRightPressed();
        break;
      case 40:
        this.controller.onKeyDownPressed();
        break;
      default:
    }
  };

  return ControllerEventDispatcher;
})();
