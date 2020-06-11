/**
 * Created by showie on 2/4/14.
 */

var server = require("./server");
var router = require("./router");
var requestHandlers = require("./requestHandlers");
var startController = require("./startController");
var formController = require("./formController");
var resultsController = require("./resultsController");

var handle = {};
handle["/"] = startController.start;
handle["/start"] = startController.start;
handle["/upload"] = formController.upload;
handle["/show"] = resultsController.show;

server.start(router.route, handle);