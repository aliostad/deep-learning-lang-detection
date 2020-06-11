var R2L2Presentation = angular.module('R2L2Presentation', []);

R2L2Presentation.controller('ClienteController', ClienteController);
R2L2Presentation.controller('PedidoController', PedidoController);
R2L2Presentation.controller('ProdutoController', ProdutoController);
R2L2Presentation.controller('UsuarioController', UsuarioController);


R2L2Presentation.service('ClienteService', ClienteService);
R2L2Presentation.service('PedidoService', PedidoService);
R2L2Presentation.service("ProdutoService", ProdutoService);
R2L2Presentation.service('UsuarioService', UsuarioService);
