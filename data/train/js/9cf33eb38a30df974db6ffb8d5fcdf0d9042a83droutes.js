/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/proveedors', require('./api/proveedor'));
  app.use('/api/categorias', require('./api/categoria'));
  app.use('/api/ubicacions', require('./api/ubicacion'));
  app.use('/api/ejemplars', require('./api/ejemplar'));
  app.use('/api/estadoejemplars', require('./api/estadoejemplar'));
  app.use('/api/prestamos', require('./api/prestamo'));
  app.use('/api/estadoprestamos', require('./api/estadoprestamo'));
  app.use('/api/reservas', require('./api/reserva'));
  app.use('/api/subscripcions', require('./api/subscripcion'));
  app.use('/api/rols', require('./api/rol'));
  app.use('/api/articulos', require('./api/articulo'));
  app.use('/api/things', require('./api/thing'));
  app.use('/api/users', require('./api/user'));

  app.use('/auth', require('./auth'));
  
  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendfile(app.get('appPath') + '/index.html');
    });
};
