var url = require("url");
var serviceListener = require("../model/serviceListener");
var Service = require("../model/service").Service;

function handleRequest(req, res) {
    var queryString = url.parse(req.url, true).query;
    if (req.method === "POST") {
        queryString = req.body;
    }
    var service;
    var action;
	
    if (queryString.action === "add") {
        service = new Service(0, '', 60, new Date(), new Date(), '', "enabled", '', '');
        action = "/addService";
    } else {
		if (!queryString.id) {
		    res.redirect('/viewServices');
			return;
		}
        var services = serviceListener.getServices();
        service = services[queryString.id];
        if (!service) {
            res.redirect('/viewServices');
            return;
        }
        action = "/editService";
    }

    res.render("services/viewService.jade", {
        service: service,
        title: "Health Dashboard -" + queryString.name + " Service",
        action: action
    });
}

exports.handleRequest = handleRequest;