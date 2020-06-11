
var app = angular.module("confencesApp")
    .factory( 'conferenceService',
    [ '$firebaseArray',
        function( $firebaseArray) {

            var service = { };

            service.ref = new Firebase( 'https://lfvargas1746.firebaseio.com/conferences' );
            service.ref2 = new Firebase( 'https://lfvargas1746.firebaseio.com/logins' );

            service.conferences = $firebaseArray( service.ref );
            service.logins = $firebaseArray( service.ref2 );

            service.addConference = function ( conf ) {
                service.conferences.$add( conf );
            };

            service.addLogin = function(login){
                service.logins.$add(login);
            };

            service.newConference = function () {
                return {
                    id            : "",
                    name          : "",
                    description   : "",
                    place         : "",
                    deadline      : "",
                    notification  : "",
                    event         : "",
                    gusta         : 0,
                    comentarios   :[],
                    temas         :[]
                };
            }

            service.newLogin = function(){
                return{
                    user          : "",
                    password      : ""
                };
            }

            service.currentConference = service.newConference();
            service.currentLogin = service.newLogin();

            service.setCurrentConference = function ( conf ) {
                service.currentConference = conf;
            }

            service.setCurrentConference2 = function ( conf ) {

                for(var j=0;j<service.conferences.length;j++)
                {
                    if(service.conferences[j]["id"]==conf)
                    {
                        service.currentConference = service.conferences[j];
                        break;
                    }
                }
                if(service.currentConference==null)
                {
                    window.alert("No hay ninguna conferencia con este id");
                }
            };

            service.favorito = function (conf ) {
                service.currentConference = conf;
                service.currentConference.gusta++;
            };

            service.setCurrentLogin = function(login){
                service.currentLogin = login;
            };

            service.addComentario = function(conf, login, comentario){
                service.currentConference = conf;
                service.currentLogin = login;
                if ( typeof conf.comentarios == 'undefined' ) {
                    conf.comentarios = [];
                }
                // service.currentConference.comentarios.$add(comentario);
                console.log(login);

                service.currentConference.comentarios.push({usuario:login, comment:comentario});
                service.createOrUpdate2(conf);
            };

            service.addTema = function(conf, tema){
                service.currentConference = conf;
                if ( typeof conf.temas == 'undefined' ) {
                    conf.temas = [];
                }

                service.currentConference.temas.push({tema:tema});
                service.createOrUpdate2(conf);
            };


            service.createOrUpdate = function( conf ) {
                if ( typeof conf.$id == 'undefined' ) {
                    service.conferences.$add( conf );
                } else {
                    service.conferences.$save( conf );
                }
            };
            service.createOrUpdate2 = function( conf ) {
                    service.conferences.$save( conf );

            };

            service.borrar = function(conf){
                service.conferences.$remove(conf)
            };

            service.createLogin = function(login){
                if(typeof login.$user == 'undefined'){
                    service.logins.$add(login);
                }
            };



            service.conferences.$watch( function(event) {
                console.log(event);
            });

            service.logins.$watch( function(event) {
                console.log(event);
            });

            return service;

        }]);