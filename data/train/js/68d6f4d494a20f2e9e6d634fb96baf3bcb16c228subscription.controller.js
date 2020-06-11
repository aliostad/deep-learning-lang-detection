/**
 * Created by sachin.pande on 25/02/2015.
 */
var Show = require('../show/show.model');

exports.subscribe = function (req, res, next) {
    Show.findById(req.body.showId, function (err, show) {
        if (err) return next(err);
        show.subscribers.push(req.user.id);
        show.save(function (err) {
            if (err) return next(err);
            res.sendStatus(200);
        });
    });
};

exports.unsubscribe = function (req, res, next) {
    Show.findById(req.body.showId, function (err, show) {
        if (err) return next(err);
        var index = show.subscribers.indexOf(req.user.id);
        show.subscribers.splice(index, 1);
        show.save(function (err) {
            if (err) return next(err);
            res.sendStatus(200);
        });
    });
};