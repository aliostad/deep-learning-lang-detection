angular
  .module('app')
  .controller('ProgramInformationController', ProgramInformationController);

function ProgramInformationController() {
  var vm = this;
  vm.showBackpack = false;
  vm.showMobile = false;
  vm.showCloset = false;
  vm.showGarden = false;
  vm.showSoup = false;
  vm.showGeneral = true;
  alert('hi');

  // vm.showProgram = showProgram;

  function showProgram(program) {
    hideAll();

    if (program === "backpack")
      vm.showBackpack = true;
    else if (program === "mobile")
      vm.showMobile = true;
    else if (program === "closet")
      vm.showCloset = true;
    else if (program === "garden")
      vm.showGarden = true;
    else if (program === "soup")
      vm.showSoup = true;
    else
      vm.showGeneral = true;
  }

  function hideAll() {
    vm.showBackpack = false;
    vm.showMobile = false;
    vm.showCloset = false;
    vm.showGarden = false;
    vm.showSoup = false;
    vm.showGeneral = false;
  }
}
