var funcionarioController = function ($scope) {
  $scope.pagina = "Funcionário";
}

// Injetando dependência
funcionarioController.$inject = ['$scope'];

var manterFuncionarioController = function ($scope, $routeParams) {
  $scope.pagina = "Novo Funcionário";
  $scope.id = $routeParams.id;
}

// Injetando dependência
manterFuncionarioController.$inject = ['$scope'];

// Adicionando controller ao module
app.controller('funcionarioController', funcionarioController);
app.controller('manterFuncionarioController', manterFuncionarioController);