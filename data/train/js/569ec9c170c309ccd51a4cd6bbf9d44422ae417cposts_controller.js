var locomotive = require('locomotive')
  , Controller = locomotive.Controller;

var PostsController = new Controller();

PostsController.index = function() {
  this.title = 'Locomotive' ;
  this.render();
}


PostsController.new = function() {
  this.title = 'NEW Posts' ;
  this.render();
}


PostsController.create = function(){
	this.title = "CREATE method" ;
	this.render();
}

PostsController.show = function(){
	this.title = "SHOW controller";
	this.render();
}

PostsController.edit = function(){
	this.title = "EDIT controller";
	this.render();
}


PostsController.update = function(){
	this.title = "Update controller";
	this.render();
}

PostsController.destroy = function(){
	this.title = "Destroy controller";
	this.render();
}


PostsController.schema = function(){
	this.title = "SCHEMA Controller";
	this.render({ format: 'json' });
}


module.exports = PostsController;
