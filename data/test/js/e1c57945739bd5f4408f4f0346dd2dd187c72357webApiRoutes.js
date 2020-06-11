var express = require('express');
var api = express.Router();

var webApiCtrl = require('../controllers/webApiCtrl');

api.use(function timeLog(req, res, next) {
    console.log('Time: ', Date.now())
    next()
})

api.use(function checkApiToken(req, res, next) {
    next()
})

api.get('/', function (req, res) {
    let api_data = {
        'name': 'Web API Home Page'
    };
    res.send(api_data);
})

api.get('/getsiteusers', webApiCtrl.getAllSiteUsers);
api.post('/addsiteuser', webApiCtrl.AddSiteUser);
api.post('/editsiteuser', webApiCtrl.editSiteUser);
api.post('/deletesiteuser', webApiCtrl.deleteSiteUser);

api.get('/getlanguages', webApiCtrl.getAllLanguages);
api.post('/addlanguage', webApiCtrl.AddLanguage);
api.post('/editlanguage', webApiCtrl.editLanguage);
api.post('/deletelanguage', webApiCtrl.deleteLanguage);

api.get('/getdefaultcountries', webApiCtrl.getAllDefaultCountries);
api.get('/getcountries', webApiCtrl.getAllCountries);
api.post('/addcountry', webApiCtrl.AddCountry);
api.post('/editcountry', webApiCtrl.editCountry);
api.post('/deletecountry', webApiCtrl.deleteCountry);

api.get('/getcategories', webApiCtrl.getCategories);

api.get('/getproducts', webApiCtrl.getAllProducts);
api.post('/addproduct', webApiCtrl.AddProduct);
api.post('/editproduct', webApiCtrl.editProduct);
api.post('/deleteproduct', webApiCtrl.deleteProduct);
api.post('/addproductlocalize', webApiCtrl.AddProductLocalize);
api.post('/editproductlocalize', webApiCtrl.editProductLocalize);
api.get('/getproductlocalize/:id', webApiCtrl.getProductLocalizeByProductId);

api.get('/getslideimages', webApiCtrl.getAllSlideImages);
api.post('/addslideimage', webApiCtrl.AddSlideImage);
api.post('/deleteslideimage', webApiCtrl.deleteSlideImage);
api.post('/changeslideseq', webApiCtrl.changeSlideSequence);

api.get('/getappwords', webApiCtrl.getAllAppWords);
api.post('/addappword', webApiCtrl.AddAppWord);
api.post('/deleteappword', webApiCtrl.deleteAppWord);
api.post('/editappword', webApiCtrl.editAppWord);

api.get('/getapplocalize', webApiCtrl.getAllAppLocalize);
api.post('/addapplocalize', webApiCtrl.AddAppLocalize);
api.post('/deleteapplocalize', webApiCtrl.deleteAppLocalize);
api.post('/editapplocalize', webApiCtrl.editAppLocalize);

api.get('/getproductprices', webApiCtrl.getAllProductPriceByCountry);
api.post('/addproductprice', webApiCtrl.AddProductPriceByCountry);
api.post('/editproductprice', webApiCtrl.editProductPrice);
api.post('/deleteproductprice', webApiCtrl.deleteProductPrice);

api.get('/getproductprice/:id', webApiCtrl.getProductPriceById);
api.get('/getproduct/:id', webApiCtrl.getProductById);
api.get('/getcountry/:id', webApiCtrl.getCountryById);
api.get('/getlanguage/:id', webApiCtrl.getLanguageById);

api.get('/getproductcount', webApiCtrl.getProductCount);

api.get('/getmobileusers', webApiCtrl.getMobileUsers);
api.post('/deletemobileuser', webApiCtrl.deleteMobileUser);

api.post('/addconfig', webApiCtrl.AddConfig);
api.get('/getconfigs', webApiCtrl.getConfig);
api.post('/editconfig', webApiCtrl.editConfig);
api.get('/getconfig/:id', webApiCtrl.getConfigById);
api.post('/deleteconfig', webApiCtrl.deleteConfig);

module.exports = api