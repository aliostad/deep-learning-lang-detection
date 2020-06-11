BhProducts = function (productService, currencyService, pricingSchemaService){
    var self = this;

    if(!(productService instanceof ProductService))
        throw new Meteor.Error("Given product service is not instance of ProductService");

    if(!(currencyService instanceof CurrencyService))
        throw new Meteor.Error("Given product service is not instance of CurrencyService");

    if(!(pricingSchemaService instanceof PricingSchemaService))
        throw new Meteor.Error("Given product service is not instance of PricingSchemaService");

    this.productService = productService;	
    this.currencyService = currencyService;
    this.pricingSchemaService = pricingSchemaService;

    if(Meteor.isServer){
    	this.publish();
    }

    if(Meteor.isClient){
    	this.subscribe();
    }
}

BhProducts.prototype.constructor = BhProducts;

BhProducts.prototype.subscribe = function(){
	this.currencyService.subscribe();
	this.productService.subscribe();
    this.pricingSchemaService.subscribe();
}

BhProducts.prototype.publish = function(){
	this.currencyService.publish();
	this.productService.publish();
    this.pricingSchemaService.publish();
}

Products = new BhProducts(new ProductService(), new CurrencyService(), new PricingSchemaService());