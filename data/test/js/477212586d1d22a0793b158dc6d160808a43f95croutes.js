var PartidoController = require('../controllers/partidoController.js')
var EstadoController = require('../controllers/estadoController.js')
var CandidatoController = require('../controllers/candidatoController.js')
var ImagensController = require('../controllers/imagensController.js')

var routes = function(app, config) {
  var partidoController = new PartidoController(config)
  var estadoController = new EstadoController(config)
  var candidatoController = new CandidatoController(config)
  var imagensController = new ImagensController(config)

  app.get('/partidos', partidoController.getPartidos)

  app.get('/estados', estadoController.getEstados)

  app.get('/candidatos', candidatoController.listaCandidatos)
  app.get('/candidato/:id', candidatoController.getCandidato)

  app.post('/procura', imagensController.getSemelhante)
}

module.exports = routes
