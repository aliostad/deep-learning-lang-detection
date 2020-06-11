var mongoose = require('mongoose'),
	autoIncrement = require('mongoose-auto-increment');

var MODULE_NAME = 'ServicePartners';

var schema = mongoose.Schema({
		_id: Number,
		ServiceProvider: { type: Number, ref: 'service-provider' },
		Service: { type: Number, ref: 'service' },
		Partners: [{ type: Number, ref: 'service-provider' }]
	});
schema.plugin(autoIncrement.plugin, 'service-partners');

//STATIC METHODS
schema.statics.findByServiceAndPopulate = function(filter, callback) {
	this.find( filter )
		.populate(populateService)
		.populate(populatePartners)
		.exec(function(err, dbServicePartners){
			callback(err, dbServicePartners);
		});
};
/*schema.statics.findByServiceAndPopulate = function(serviceProviderId, serviceId, callback) {
	var populateService = { path: 'Service', match: { isEnabled: true } };
	var populatePartners = { path: 'Partners', match: { isEnabled: true } };
	this.find( {
			$and: [
			       { Service: serviceId },
			       { $or: [
			               { ServicePartners: serviceProviderId },
			               { ServicePartners: { $eq: {$size:0} }, ServiceProvider: { $ne: serviceProviderId } }
			       ] }
			]
		} )
		.populate(populateService)
		.populate(populatePartners)
		.exec(function(err, dbServicePartners){
			callback(err, dbServicePartners);
	});
};*/

module.exports = mongoose.model('service-partners', schema);
