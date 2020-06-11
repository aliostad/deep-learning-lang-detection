define(["kendo", "cart", "config"], function (kendo, cart, config) {
    return {
        baseserviceItemViewModel: {
            onAddToCart: function (clickEvt) {
                var serviceItem = clickEvt.data;
                cart.add(serviceItem);

                // force refresh of data bindings.
                var aid = serviceItem.get("serviceItemId");
                serviceItem.set("serviceItemId", -1);
                serviceItem.set("serviceItemId", aid);
            },
            serviceItemUnitPrice: function (serviceItem) {
                return kendo.toString(parseFloat(serviceItem.get("serviceItemUnitPrice")), "c");
            },
            serviceItemDescription: function (serviceItem) {
                return serviceItem.get("serviceItemDescription");
            },
            serviceItemNotes: function (serviceItem) {
                return serviceItem.get("serviceItemNotes");
            },
            qtyInCart: function (serviceItem) {
                var cartItem = cart.find(serviceItem.get("serviceItemId"));
                if(cartItem) {
                    return cartItem.get("qty");
                } else {
                    return "";
                }
            },
            buttonClasses: function (serviceItem) {
                if(this.qtyInCart(serviceItem) !== "") {
                    return "km-icon cartQty";
                } else {
                    return "km-icon km-add";
                }
            }
        }
    };
});