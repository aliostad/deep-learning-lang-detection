// # Service Controller

var ServiceController = function() { 
  
  return {
    run: function(req, res) {
      var service_id = req.params.service_id;

      mysql.query("SELECT * FROM services WHERE services.cached_slug = ? LIMIT 1", [ service_id ], function(err, service_r) {
        if (err || service_r.length == 0) return res.send(Helpers.error("Unknown service: " + service_id));
        var service = service_r[0];

        mysql.query("SELECT * FROM service_connections WHERE service_connections.app_id = ? AND service_id = ? LIMIT 1", [req.app.id, service.id], function(err, service_connection_r) {
          if (err || service_connection_r.length == 0) return res.send(Helpers.error("No Service Connection for " + service_id + " enable the service connection on our website."));

          var service_connection = new ServiceConnection.Instance(service_connection_r[0], service);

          service_connection.run(req, res);
          return true;
        });
        return true;
      });

      return true;
    }
  };

};

exports.build = function() {
  return ServiceController.call(this);
};
