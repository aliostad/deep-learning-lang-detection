(function(){
  "use strict";

  var base = require("./base.js"),
      ViewClass = require("../views/AdminShow.js"),

      AdminShowCtrl, _ptype;

  AdminShowCtrl = function(schemas){
    this.schemas = schemas;
    this.payload = {title: ""};
    this._view   = new ViewClass();
  };

  _ptype = AdminShowCtrl.prototype = base.getProto("std");
  _ptype._name = "AdminShow";

  _ptype.getShows = function(cb){
    this.schemas.Show.find({}, cb);
  };

  _ptype.addShow = function(showData, cb){
    var show = new this.schemas.Show({
      name: showData.name,
      picture: showData.picture
    });
    show.save(cb);
  };

  module.exports = AdminShowCtrl;
}());
