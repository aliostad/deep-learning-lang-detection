(function( globals, document ) {

  var MessageBus = function() {
    this.subscribers = {}
  };

  MessageBus.prototype.subscribe = function( message_type, callback ) {
    if ( !this.subscribers[message_type] ) {
      this.subscribers[message_type] = [];
    }

    this.subscribers[message_type].push( callback );
  };

  MessageBus.prototype.publish = function( message_type, message ) {
    var subscribers = this.subscribers[message_type];

    if ( !subscribers ) { return; }

    var i = 0,
        subscriber = null;

    for ( i in subscribers ) {
      subscriber = subscribers[i];

      subscriber( message_type, message );
    }
  };

  // to use:
  // message_bus.subscribe( 'fire', function( msg_type, msg ) { ... } );
  // message_bus.publish( 'fire', 'boobies' );

  globals.MessageBus = MessageBus;

})( window, document );
