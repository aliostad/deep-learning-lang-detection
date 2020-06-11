angular.module('Supermarket')
    .service('CartDataSharingService', function() {
        var service = this;
        service.cart = [];

        service.getCart = function(){
          return service.cart;
        };

        service.addToCart = function (cartItem) {
            for (var i = 0; i < service.cart.length; i++) {
                if (service.cart[i].name == cartItem.name) {
                    service.cart[i].quantity = service.cart[i].quantity + cartItem.quantity;
                    service.cart[i].totalPrice=service.cart[i].quantity*service.cart[i].price;
                    return;
                }
            }
            cartItem.totalPrice=cartItem.quantity*cartItem.price;
            service.cart.push(cartItem);
        };
    });