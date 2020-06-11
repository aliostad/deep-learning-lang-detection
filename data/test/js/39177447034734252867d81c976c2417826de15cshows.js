'use strict';

var mongoose = require('mongoose'),
    Show = mongoose.model('Show'),
    _ = require('lodash');

/**
 * Find show by id
 */
exports.findShow = function(req, res, next, id) {
    Show.load(id, function(err, show) {
        if (err) return next(err);
        if (!show) return next(new Error('Failed to load show ' + id));
        req.show = show;
        next();
    });
};

/**
 * Create an show
 */
exports.create = function(req, res) {
    var show = new Show(req.body);
    show.user = req.user;

    show.save(function(err) {
        if (err) {
            res.render('error', {
                status: 500
            });
        } else {
            res.jsonp(show);
        }
    });
};

/**
 * Update a show
 */
exports.update = function(req, res) {
    var show = req.show;

    show = _.extend(show, req.body);

    show.save(function(err) {
        if (err) {
            res.render('error', {
                status: 500
            });
        } else {
            res.jsonp(show);
        }
    });
};

/**
 * Delete a show
 */
exports.destroy = function(req, res) {
    var show = req.show;

    show.remove(function(err) {
        if (err) {
            res.render('error', {
                status: 500
            });
        } else {
            res.jsonp(show);
        }
    });
};

/**
 * Show an show
 */
exports.show = function(req, res) {
    res.jsonp(req.show);
};

/**
 * List of Shows
 */
exports.all = function(req, res) {
    Show.find().sort('-created').populate('theater', 'name').exec(function(err, shows) {
        if (err) {
            res.render('error', {
                status: 500
            });
        } else {
            res.jsonp(shows);
        }
    });
};
