module( "core.Model", {
    setup: function() {
        Model.removeAllServices();
    }
});

var TestService = Service.extend({
    isAdded: false,
    init: function( name ) {
        this._super( name );
    },
    added: function() {
        this.isAdded = true;
    },
    removed: function() {
        this.isAdded = false;
    }
});

test( "serviceIsAdded", 4, function() {
    var service = new TestService( "testName", {});
    
    Model.addService( service );
    
    ok( Model.hasService( "testName" ), "service is added" );
    ok( service.isAdded, "service added() is called" );
    
    raises( function() {
        Model.addService( service );
    }, "raises error if service already added" );
    
    strictEqual( Model.getService( "testName" ), service, "fetched service is equal" );
});

test( "serviceIsRemoved", 2, function() {
    var service = new TestService( "testName", {});
    
    Model.addService( service );
    Model.removeService( "testName" );
    
    ok( !Model.hasService( "testName" ), "service is removed" );
    ok( !service.isAdded, "service removed() is called" );
});