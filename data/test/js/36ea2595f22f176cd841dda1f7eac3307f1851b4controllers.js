angular.module('starter.controllers', [])

.controller('AppCtrl', applicationController)

/*
 * Exemplo
 */
.controller('PlaylistsCtrl', function($scope) {
  $scope.playlists = [
    { title: 'Reggae', id: 1 },
    { title: 'Chill', id: 2 },
    { title: 'Dubstep', id: 3 },
    { title: 'Indie', id: 4 },
    { title: 'Rap', id: 5 },
    { title: 'Cowbell', id: 6 }
  ];
})

.controller('LoginCtrl', loginController)
.controller('PedidoListCtrl', pedidoListController)
.controller('PedidoCtrl', pedidoController)
.controller('RoteirosCtrl', roteirosController)
.controller('RoteiroOpcoesCtrl', roteiroOpcoesController)
.controller('SemPedidoCtrl', semPedidoController)
.controller('ClientesCtrl', clientesController)
.controller('ClienteDetalheCtrl', clienteDetalheController)
.controller('SemPedidoListCtrl', semPedidoListController);





