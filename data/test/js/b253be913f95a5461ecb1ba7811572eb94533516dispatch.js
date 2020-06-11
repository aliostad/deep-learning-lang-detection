//unit dispath
//contains all web logic

var log = require('./debug.js');


exports.dispatch = function(request, response) {
    var d = '';
    switch (request.method) {
        case 'GET':
            dispatchGet(request, response);
            break;
        case 'POST':
            dispatchPost(request, response);
            break;
    }
}

function dispatchGet(request, response){
    log.info('GET recieved');
    dispatchGetUrl(request, response);
}


function dispatchPost(request, response) {
    log.info('POST recieved');
    dispatchPostUrl(request, response);
}


function dispatchPostUrl(request, response){
    switch (request.url) {
        default:
            response.writeHead(500);
            response.end('Ressource not defined');
    }
}
function dispatchGetUrl(request, response) {
    switch (request.url) {
        case '/get-messages':
            
            break;
        default:
            response.writeHead(500);
            response.end('Ressource not defined');
    }
}
