function httpError ( message, code ) {

    var err = new Error( message );
    err.status = code;

    return err;

}


exports.system = function ( message ) {

    return httpError( message, 500 );

};


exports.auth = function ( message ) {

    return httpError( message, 401 );

};


exports.notAuthorized = function ( message ) {

    return httpError( message, 403 );

};


exports.resourceNotFound = function ( message ) {

    return httpError( message, 404 );

};


exports.conflict = function ( message ) {

    return httpError( message, 409 );

};
