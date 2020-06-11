'''
create web server (port:8888) on folder / and /ws
/ : do nothing
/ws : web socket server, save message to file
'''

from tornado import websocket, web, ioloop, httpserver
import json
import os
from datetime import datetime
import ttg

cl = []
save_page_count = 0
save_page_fname = ''
save_page_done_fname = ''

class IndexHandler(web.RequestHandler):
    def get(self):
        self.write("This tornado server to save page.")

class SocketHandler(websocket.WebSocketHandler):
    def check_origin(self, origin):
        return True

    def open(self):
        print('SocketHandler.open')
        if self not in cl:
            cl.append(self)

    def on_message(self, message):
        global save_page_count, save_page_fname, save_page_done_fname

        if os.path.isfile(save_page_done_fname):
            os.remove(save_page_done_fname)
        if os.path.isfile(save_page_fname):
            os.remove(save_page_fname)

        f = open(save_page_fname, mode='w')
        f.write(message)
        f.close()
        open(save_page_done_fname, mode='w').close()

        ttg.reform(message)
        save_page_count += 1
        print(save_page_count, datetime.now(), 'save page')

    def on_close(self):
        if self in cl:
            cl.remove(self)

app = web.Application([
    (r'/', IndexHandler),
    (r'/ws', SocketHandler),
])

if __name__ == '__main__':
    home_dir = os.getenv('HOME')
    http_server = httpserver.HTTPServer(app, ssl_options={
        "certfile": os.path.join(home_dir, "az-localhost.crt"),
        "keyfile": os.path.join(home_dir, "az-localhost.key"),
        }
    )
    save_page_fname = os.path.join(home_dir, "temp/savepage.txt")
    save_page_done_fname = os.path.join(home_dir, "temp/savepagedone")
    http_server.listen(8888)
    ioloop.IOLoop.instance().start()
