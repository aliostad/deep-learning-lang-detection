
var postsControllerHelper = require('../helpers/posts-controller-helper');

var app = require('../app');

var PostController = (function () {

  function PostController (name, service) {
    this.name = name;
    this.service = service;
    this.deps = [ '$scope' ];
    this.controller = createNewController();
  }

  PostController.prototype = {

    inject: function () {

      var controller = createNewController(this);
      this.deps.push(controller);
      app.controller(this.name, this.deps);

    }

  };

  return PostController;

})();

function createNewController (self) {
    
  function Controller ($scope) {
  
    postsControllerHelper.assignPosts($scope, self.service);
  
  }

  return Controller;

}

module.exports = PostController;