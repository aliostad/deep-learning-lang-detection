var express = require('express');
var router = express.Router();
var AuthService = require('../services/auth_service');
var UserService = require('../services/user_service');
var OrderService = require('../services/order_service');
var ProductService = require('../services/product_service');
var PlaceService = require('../services/place_service');

router.get('/', function(req, res) {
    res.json({
        message: 'welcome to use go2fish api'
    });
});

/************************* User API ***************************************/
router.post('/users', UserService.createUser);
router.get('/users/:user_email/:role_id', UserService.checkUserExist);
router.post('/auth', UserService.authenticate);
router.get('/users', [AuthService.checkToken , AuthService.checkAdminRole ], UserService.getAllUsers);
router.put('/users/:user_id', [AuthService.checkToken], UserService.updateUser);
router.delete('/users/:user_id', [AuthService.checkToken, AuthService.checkAdminRole], UserService.removeUser);
router.delete('/tokens/:user_id' , [AuthService.checkToken] , AuthService.removeToken );

/************************* Order API ***************************************/
router.post('/orders/:user_id',[AuthService.checkToken] , OrderService.addOrder );
router.get('/orders/:user_id/:order_id?',[AuthService.checkToken] , OrderService.findOrder );
router.put('/orders/:user_id/:order_id',[AuthService.checkToken] , OrderService.updateOrder );
router.delete('/orders/:user_id/:order_id',[AuthService.checkToken] , OrderService.removeOrder );

/************************* Product API ***************************************/
router.get('/products', ProductService.getProducts);
router.post('/products',[AuthService.checkToken , AuthService.checkAdminRole], ProductService.addProduct);
router.put('/products/:product_id',[AuthService.checkToken, AuthService.checkAdminRole], ProductService.updateProduct );
router.delete('/products/:product_id',[AuthService.checkToken, AuthService.checkAdminRole], ProductService.removeProduct );


/************************* Place API ***************************************/
router.get('/places', PlaceService.getPlaces);
router.post('/places', [AuthService.checkToken, AuthService.checkAdminRole] , PlaceService.addPlace);
router.put('/places/:place_id', [AuthService.checkToken, AuthService.checkAdminRole] , PlaceService.updatePlace);
router.delete('/places/:place_id', [AuthService.checkToken, AuthService.checkAdminRole] , PlaceService.removePlace);

module.exports = router;
