var CharacterController  = require('./controller/characterController');

function Router() {
  this.characterController = new CharacterController();
}

Router.prototype.configure = function(app) {
  app.get('/character', this.characterController.all.bind(this.characterController));
  app.get('/character/:id', this.characterController.single.bind(this.characterController));
  app.post('/character', this.characterController.add.bind(this.characterController));
  app.put('/character/:id', this.characterController.update.bind(this.characterController));
  app.delete('/character/:id', this.characterController.delete.bind(this.characterController));
};

module.exports = Router;
