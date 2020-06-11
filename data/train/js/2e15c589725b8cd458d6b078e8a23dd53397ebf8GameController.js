function GameController() {
  var babyController;
  var burpController;
  var foodController;

  function setBaby(controller) {
    babyController = controller;
  }

  function setBurp(controller) {
    burpController = controller;
  }

  function setFood(controller) {
    foodController = controller;
  }

  function preload() {
    babyController.preload();
    //foodController.preload();
    //burpController.preload();
  }

  function init() {
    babyController.init();
    //foodController.init();
    //burpController.init();
  }

  function create() {
    babyController.create();
    //foodController.create();
    //burpController.create();
  }

  function update() {
    babyController.update();
    foodController.update();
    //burpController.update();
  }

  return {
    preload: preload,
    init: init,
    create: create,
    update: update,
    setBaby: setBaby,
    setBurp: setBurp,
    setFood: setFood
  }
}