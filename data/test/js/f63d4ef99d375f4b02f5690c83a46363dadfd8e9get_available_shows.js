var Promise = require( 'promise' );
var _ = require( 'lodash' );
var path = require( 'path' );
var Show = require( '../models/show' );



function getFromShowRSS( showRSSUserID, baseDir ) {
  return require( '../lib/show_rss' ).showNames( showRSSUserID )
    .then(function( names ) {
      return names.map(function( name ) {
        return new Show( name, path.resolve( baseDir, name ) );
      });
    });
}

function getSubDirs( dir ) {
  return require( '../lib/subdirs' )( dir )
    .then(function( names ) {
      return names.map(function( name ) {
        return new Show( name, path.resolve( dir, name ) );
      });
    });
}

module.exports = function( showDirs, showRSSUserID ) {
  var defaultDir = showDirs[ 0 ];
  var showRSS = showRSSUserID ? getFromShowRSS( showRSSUserID, defaultDir ) : [];
  var showsFromDirs = showDirs.map( getSubDirs );

  return Promise.all( _.flatten([ showRSS, showsFromDirs ]) )
    .then(function( shows ) {
      var uniqueShows = _.flatten( shows ).reduce(function( dict, show ) {
        dict[ show.normalizedName ] = show;
        return dict;
      }, {});
      return _.values( uniqueShows );
    });
};