# coding: utf-8

from cocaine.context import Log, Dispatch
from cocaine.http import http

from hashlib import sha512

log = Log()
dispatch = Dispatch()

@http
def hash_headers(request, response):
    def process():
        result = "<html><head>Hash</head>%s</html>\r\n" % sha512(str(request.headers)).hexdigest()
        
        response.writeHead(200, {
            'Content-Type': 'text/plain'
        })
        
        response.write(result)
        response.close()

    request.on("request", process)

dispatch.on("hash", hash_headers)
