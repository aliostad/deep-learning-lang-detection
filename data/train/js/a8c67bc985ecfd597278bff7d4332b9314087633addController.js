angular.module('Supermarket')
    .controller('AddProductController', function ($http) {
        var controller = this;
        controller.products = [];
        controller.successMessage = {};
        controller.showSuccessMessage = false;

        controller.addProduct = function () {
            var product = {}
            product.name = controller.name;
            product.price = controller.price;
            $http({
                url: 'rest/product',
                method: "POST",
                data: product
            }).success(function (response) {
                controller.showSuccessMessage = true;
                controller.successMessage = response;
                controller.name = "";
                controller.price = "";
            });
        }

    });
