var api = require("../api/api.js");
var auth=require('../common/js/security');

exports.init = function (app) {
	// console.log("api call");
	app.post('/api/discount/:providerid/:branchid',auth,api.discountapi.addDiscount);
	app.get('/api/discount/:providerid/:branchid',auth,api.discountapi.getDiscountCodes);
	app.get('/api/products/:providerid/:branchid',auth,api.discountapi.getAllProducts);
	app.get('/api/discountedproducts/:branchid/:discountid',auth,api.discountapi.getDiscountedProducts);
	app.put('/api/discount/:discountid',auth,api.discountapi.updateDiscount);
	app.delete('/api/discount/:providerid/:branchid/:discountid',auth,api.discountapi.deleteDiscount);
	app.put('/api/discount/manageproducts/:branchid/:discountid',auth,api.discountapi.manageProductsToDiscountCode);
}