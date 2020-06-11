EntrarController = RouteController.extend({

});

SairController = RouteController.extend({

});

MudarSenhaController = RouteController.extend({

});

CriarContaController = RouteController.extend({

});

EditarPerfilController = RouteController.extend({

});

Router.route('/entrar', {
    name: 'entrar'
});

Router.route('/criarconta', {
    name: 'criarConta'
});

Router.route('/sair', {
    name: 'sair'
});

Router.route('/mudarsenha', {
    name: 'mudarSenha'
});

Router.route('/editarperfil', {
    name: 'editarPerfil'
});