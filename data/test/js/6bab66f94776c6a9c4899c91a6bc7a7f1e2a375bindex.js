var encryption = require('../utilities/cripto'),
    usersData = require('../data/usersData'),
    productsData = require('../data/productsData'),
    messagesData = require('../data/messagesData'),
    ordersData = require('../data/ordersData');

var UsersController = require('./UsersController')(usersData, productsData, encryption);
var ProductsController = require('./ProductsController')(usersData, productsData);
var LiveChatController = require('./LiveChatController')(messagesData);
var OrdersController = require('./OrdersController')(usersData, ordersData, productsData);
var HomeController = require('./HomeController')(productsData);
var CartController = require('./CartController')(usersData, productsData);

module.exports = {
  users: UsersController,
  products: ProductsController,
  liveChat: LiveChatController,
  orders: OrdersController,
  home: HomeController,
  cart: CartController
};
