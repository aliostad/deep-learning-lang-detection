(function( angular ){
    'use strict';

    var flashMessageService = angular.module( 'gamesApp.flashMessageService', [] );

    flashMessageService.factory( 'FlashMessageService', [ '$rootScope', function( $rootScope ){

        var SUCCESS_MESSAGE_TYPE = 'flash-success';
        var ERROR_MESSAGE_TYPE   = 'flash-error';
        var INFO_MESSAGE_TYPE    = 'flash-info';
        var message;

        var setMessage = function( messageDetail ){

            message = messageDetail;

            $rootScope.$broadcast( 'flash:message' );
        };

        return {

            setSuccessMessage: function( message ){

                if( message ){

                    setMessage( { type: SUCCESS_MESSAGE_TYPE, msg: message } );
                }
            },

            setErrorMessage: function( message ){

                if( message ){

                    setMessage( { type: ERROR_MESSAGE_TYPE, msg: message } );
                }
            },

            setInformationMessage: function( message ){

                if( message ) {

                    setMessage( { type: INFO_MESSAGE_TYPE, msg: message } );
                }
            },

            getMessage: function(){

                return message;
            }
        };

    } ] );

}( angular ) );