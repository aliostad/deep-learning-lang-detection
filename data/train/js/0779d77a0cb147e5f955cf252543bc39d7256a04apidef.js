var libString = require("../../lib/js/string");
var ucfirst = libString.ucfirst;


function extendApis(env){
//	console.log(env.apis);
	env.hasMultipart = false;
	if(!env.apis) env.apis = {};
	for(var key in env.apis){
		var api = env.apis[key];
		if(!api.type) api.type = false;
		if(api.multipart){
			env.hasMultipart = true;
		}
		if(api.isSignin)
			env.signinApi = api;
		else
			api.isSignin = false;
		if(api.isSignup)
			env.signupApi = api;
		else
			api.isSignup = false;
		if(api.isSignupSendCode)
			env.signupSendCodeApi = api;
		else
			api.isSignupSendCode = false;

		if(!api.fields) api.fields = [];

		if(!api.db) api.db = false;
		if(!api.fieldFromSchema) api.fieldFromSchema = false;
		else if(api.db){
			if(!env.schemas[api.db]){
				console.log("database " + api.db + " not exist");
				process.exit(1);
			}
			env.schemas[api.db].fields.slice(1).forEach(function(f){
				if(!f.auto) return api.fields.push(f);
			});
		}
		if(!api.name) api.name = key;
		if(!api.text) api.text = key;
		if(!api.route) api.route = key;
		if(!api.params) api.params = [];
		if(!api.querys) api.querys = [];
		if(!api.errorCode) api.errorCode = {};
		if(!api.isList) api.isList = false;
		if(!api.saveArg) api.saveArg = false;
		if(!api.saveRes) api.saveRes = false;
		if(!api.saveAuth) api.saveAuth = false;
		if(!api.auth) api.auth = false;
		if(!api.multipart) api.multipart = false;
		if(!api.withResult) api.withResult = false;
	}
}
module.exports.extendApis = extendApis;

