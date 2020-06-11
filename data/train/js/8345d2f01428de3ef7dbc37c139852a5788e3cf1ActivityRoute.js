var $i;
var ActivityRoute = function(di) {
  $i = di;
  $i.graoExpress.get('/service/activity/count',
    $i.controllers.passport.service.validateJson, 
  	$i.controllers.activity.service.count);
  $i.graoExpress.get('/service/activity/:id', 
    $i.controllers.passport.service.validateJson,
  	$i.controllers.activity.service.get);
  $i.graoExpress.put('/service/activity/:id', 
    $i.controllers.passport.service.validateJson,
  	$i.controllers.activity.service.validate, 
    $i.controllers.activity.service.update);
  $i.graoExpress.del('/service/activity/:id', 
    $i.controllers.passport.service.validateJson,
  	$i.controllers.activity.service.destroy);
  $i.graoExpress.get('/service/activity', 
    $i.controllers.passport.service.validateJson,
  	$i.controllers.activity.service.query);
  $i.graoExpress.post('/service/activity/validate', 
    $i.controllers.passport.service.validateJson,
  	$i.controllers.activity.service.validate, 
  	function(req, res){ 
  	  res.json($i.event.newSuccess("Successful validation!").toJson()); 
    });
  $i.graoExpress.post('/service/activity', 
    $i.controllers.passport.service.validateJson,
  	$i.controllers.activity.service.validate, 
  	$i.controllers.activity.service.create);
  $i.graoExpress.get('/admin/activity', 
    $i.controllers.passport.service.validateTpl,
  	$i.controllers.activity.admin.dashboard);
};

module.exports = exports = ActivityRoute;