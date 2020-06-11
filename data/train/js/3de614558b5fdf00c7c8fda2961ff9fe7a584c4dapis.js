var processor = require("../../processor/processor"),
    mongoose = require('mongoose'),
    API = mongoose.model('API');

var adminApisController = (function () {
    "use strict";

    var path = 'admin/apis',
        view_path = 'admin/apis';

    function index(req, res) {
        API.find(function (err, apis) {
            res.render(view_path + '/index', { title: 'APIs', apis: apis });
        });
    }

    function show(req, res) {
        API.findById(req.params[0], function (err, api) {
            if (typeof req.param('populateData') !== "undefined") {
                api.populateData();

                req.flash('success', api.title + ' API is checking for data. Please wait...');
                return res.redirect('/' + path + '/' + api._id);
            }

            res.render(view_path + '/show', { title: api.title, api: api });
        });
    }

    function build(req, res) {
        API.findById(req.params[0], function (err, api) {
            // Make API url
            res.render(view_path + '/build', { title: api.title, api: api });
        });
    }

    function create(req, res) {
        var api;

        if (req.method === 'POST') {
            api = new API(req.param('api'));

            api.save(function (error) {
                if (error) {
                    res.flash('error', error);
                    return res.render(view_path + '/create', { title: 'New API', api: api });
                }

                req.flash('success', api.title + ' API successfully created.');
                return res.redirect('/' + path + '/' + api._id);
            });
        } else {
            if (req.xhr) {
                processor.head(req.query.url, function (result) {
                    return res.send(result.data);
                });
            } else {
                api = new API();
                return res.render(view_path + '/create', { title: 'New API', api: api });
            }
        }
    }

    function update(req, res) {
        API.findById(req.params[0], function (err, api) {

            if (req.method === 'PUT') {
                var key;

                for (key in req.param('api')) {
                    if (req.param('api').hasOwnProperty(key)) {
                        if (key !== '_id') {
                            if (req.param('api')[key] !== api[key]) {
                                api[key] = req.param('api')[key];
                            }
                        }
                    }
                }

                api.save(function (error) {
                    if (error) {
                        res.flash('error', error);
                        return res.render(view_path + '/update', { title: 'Edit ' + api.title, api: api });
                    }

                    req.flash('success', api.title + ' API successfully updated.');
                    return res.redirect('/' + path + '/' + api._id);
                });
            } else {
                return res.render(view_path + '/update', { title: 'Edit ' + api.title, api: api });
            }

        });
    }

    function destroy(req, res) {
        res.send(200, 'Destroy');
    }

    return {
        path: path,
        index : index,
        show : show,
        build : build,
        create : create,
        update : update,
        destroy : destroy
    };
}());

module.exports = adminApisController;