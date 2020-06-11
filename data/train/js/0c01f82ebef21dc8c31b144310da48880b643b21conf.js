var config = {};

config.runLocal = true;

config.api= {};

if (config.runLocal) {
	config.api.ip = "localhost";
} else {
    // Mac
	config.api.ip = "192.168.1.9";
}

config.api.port = "9000";
config.api.base ="http://" + config.api.ip + ":" +config.api.port + "/";
config.api.urls = { 
	customerList: config.api.base + "api/customers/current",
	employeeList: config.api.base + "api/employees",
    productList: config.api.base + "api/products",
    customerById: function(id) {
        return config.api.base + "api/customers/" + id;
    }
};

var constant = {};
constant.cartSlider = {"REMOVE_ITEM": 2, "CURRENT_ITEM":1, "ADD_ITEM": 0};

constant.storage = {};
constant.storage.loggedEmployee = "lastLogged";


/*
config.api.url + 'api/customer'*/