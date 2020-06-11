function serviceData(service_id){
	var mongoose         = require('mongoose');
	var mongoosePaginate = require('mongoose-paginate');
	var timestamps       = require('mongoose-timestamp');
	var collection       = 'service_data_' + service_id;
	
	var serviceDataSchema = new mongoose.Schema({
			status: String,
			status_code: String,
			source: String,
			message: {},
			content: String
			},{ strict: false });

	serviceDataSchema.plugin(mongoosePaginate);
	serviceDataSchema.plugin(timestamps);
	
	var service_data_model = mongoose.models['ServiceData_' + service_id];
	if(service_data_model){
		return ServiceData = service_data_model;
	} else {
		return mongoose.model('ServiceData_' + service_id, serviceDataSchema, collection);	
	}

}

module.exports = serviceData;