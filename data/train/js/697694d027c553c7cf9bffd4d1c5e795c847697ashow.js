Show = require('../models/show').Show,
    _ = require('underscore');


exports.list = function(req, res) {
    Show.all('_id name', function(err, shows) {
        res.render('show/list', { shows: shows});
    });
};

exports.get = function(req, res) {
    var showId = req.params.show;
    Show.findById(showId, function(err, show) {
        if (err) { next(err); }
        show.episodes = _.sortBy(show.episodes, function(i) {
            return (i.season * 1000) + i.number; // hack to do a sorting by multiple numerical keys
        });
        res.render('show/main', { show: show});
    });
};