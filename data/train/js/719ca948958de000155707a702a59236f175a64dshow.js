var Datastore = require('nedb');
var Q = require('q');

if (typeof db == 'undefined') 
	db = {};

db.show = new Datastore("show.db");
db.show.loadDatabase();

db.show.persistence.setAutocompactionInterval(3600000); /// Compact every hour.

function Show() {
	this.name = null;
	this.seasons = [];
	
	Show.setupMethods(this);
}

Show.setupMethods = function(show) {
	show.save = function() {
		var deferred = Q.defer();	
		
		if (show._id) {
			db.show.update({_id : show._id}, show, {}, function(err) {
				if (err) {
					deferred.reject(new Error(err));
				} else {
					deferred.resolve(show);
				}
			});
		} else {
			db.show.insert(show, function(err, newDoc) {
				if (err) {
					deferred.reject(new Error(err));
				} else {
					show._id = newDoc._id;
					deferred.resolve(show);
				}
			});
		}
		
		return deferred.promise;
	};
	
	show.planNextCheck = function(seconds) {
		show.nextCheck = new Date(new Date().getTime() + seconds * 1000).toJSON();		
	};
};

Show.getAll = function(done) {
	db.show.find({}, function(err, show) {
		if (err) {
			console.log(err);
			done(err, null);
		}
		
		for (index in show) {
			var show = show[index];
			Show.setupMethods(show);
		}

		done(null, show);
	});
};

Show.findOne = function(what) {
	var deferred = Q.defer();	
	db.show.findOne(what, function (err, show) {
		if (err) {
			deferred.reject(new Error(err));
		} else {
			if (show) {
				Show.setupMethods(show)
			}
			deferred.resolve(show);
		}
	});
	return deferred.promise;
};

Show.find = function(byWhat, done) {
	db.show.find(byWhat, function(err, show) {
		if (err) {
			console.log(err);
			done(err, null);
		}
		
		for (index in show) {
			var show = show[index];
			Show.setupMethods(show);
		}

		done(null, show);
	});
};

Show.findById = function(id) {
	return Show.findOne({_id : id});
};

Show.removeById = function(id, done) {
	db.show.remove({_id : id}, done);
};

module.exports.Show = Show;