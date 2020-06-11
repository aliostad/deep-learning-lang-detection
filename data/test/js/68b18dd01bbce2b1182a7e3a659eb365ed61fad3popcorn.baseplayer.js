Popcorn.player( "baseplayer", {
  _setup: function( options ) {
    var media = this,
        seeking = false;    
    Popcorn.player.defineProperty( media, "seeking", {
      set: function( isSeeking ) {
        if ( seeking != isSeeking ) {
          seeking = isSeeking;
          if ( seeking ) {
            media.dispatchEvent( "seeking" );
          } else {
            media.dispatchEvent( "seeked" );
          }
        }        
      },
      get: function() {
        return seeking;
      }
    });
    media.readyState = 4;
    media.dispatchEvent( "loadedmetadata" );
    media.dispatchEvent( "loadeddata" );
    media.dispatchEvent( "canplaythrough" );
  }
});
