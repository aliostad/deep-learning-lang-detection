from mpd import MPDClient
from OSC import OSCServer


class OSC_MPD(object):
    def __init__(self, osc=('0.0.0.0', 8000), mpd=('127.0.0.1', 6600)):
        self.mpc = MPDClient()
        self.mpc.connect(mpd[0], mpd[1])
        self.server = OSCServer(osc)

        def musicManage(addr, tags, data, client_address):
            cmd = addr.strip('/').split('/')[-1]
            self.mpc.__getattr__(cmd)(*data)

        self.server.addMsgHandler('/bearstech/music/play', musicManage)
        self.server.addMsgHandler('/bearstech/music/pause', musicManage)
        self.server.addMsgHandler('/bearstech/music/next', musicManage)
        self.server.addMsgHandler('/bearstech/music/previous', musicManage)
        self.server.addMsgHandler('/bearstech/music/stop', musicManage)

    def serve_forever(self):
        self.server.serve_forever()
