import json
import httplib2

class IOService:
    def __init__(self):
        self.controller = {}

    def setController(self, ip, port, user, passwd):
        self.controller["ip"] = ip
        self.controller["port"] = port
        self.controller["user"] = user
        self.controller["passwd"] = passwd

    def get(self, url):
        url = "http://" + str(self.controller["ip"]) + ":" + str(self.controller["port"]) + url
        
        h = httplib2.Http(".Cache")
        h.add_credentials(self.controller["user"], self.controller["passwd"])
        resp,content = h.request(url, "GET")
        
        return content

    def put(self, url, content):
        url = "http://" + str(self.controller["ip"]) + ":" + str(self.controller["port"]) + url
        
        h = httplib2.Http(".Cache")
        h.add_credentials(self.controller["user"], self.controller["passwd"])
        resp = h.request(url, "PUT", body=str(json.dumps(content)), \
                        headers={"Content-Type":"application/json"})

        print resp
    
