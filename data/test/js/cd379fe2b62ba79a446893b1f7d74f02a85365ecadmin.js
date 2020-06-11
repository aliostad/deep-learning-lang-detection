var Admin = require('../../../models/admin').Admin;

exports.get = function(req, res, next) {
    Admin.find({}, function (err, admins) {
        var message = {
            action: "get admins"
        };

        if(err){
            message.message = err.message ? err.message : err;
            return res.send(message);
        }

        if(!admins){
            message.message = "Admins not found!";
            return res.send(message);
        }

        message.message = "ok";
        message.admins = admins;

        return res.send(message);
    })
}