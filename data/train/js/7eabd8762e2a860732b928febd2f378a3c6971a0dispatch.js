( function( global ) {
  "use strict";

  // FIXME: Replace with an implementation that supports announcing multiple variables

  function Dispatch() {

    this.nature = 'dispatch';
    this.o = global.jQuery({});
  }

  Dispatch.prototype.on = function () { this.o.on.apply( this.o, arguments ); };
  Dispatch.prototype.once = function () { this.o.one.apply( this.o, arguments ); };
  Dispatch.prototype.off = function () { this.o.off.apply( this.o, arguments ); };
  Dispatch.prototype.announce = function () { this.o.trigger.apply( this.o, arguments ); };
  Dispatch.prototype.publish = Dispatch.prototype.announce;

  global.Dispatch = Dispatch;

})( this );
