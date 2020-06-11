function TodosController(TodosFactory) {
  const controller = this;

  function init() {
    controller.list = TodosFactory.list;
    controller.inputText = '';
  }

  controller.isSubmitButtonDisabled = () => {
    return !controller.inputText;
  };

  controller.isClearButtonDisabled = () => {
    return controller.list.length < 1;
  };

  controller.add = () => {
    TodosFactory.add(controller.inputText); 
    controller.inputText = '';
  };

  controller.clear = () => {
    TodosFactory.clear();
  };

  init();
}
TodosController.$inject = ['TodosFactory'];

angular
  .module('todosApp')
  .controller('TodosController', TodosController);
