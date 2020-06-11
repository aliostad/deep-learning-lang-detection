# FIWARE ORION CLIENT
#
#
# Usage:
# from orionclient import attrib,contextbroker
# broker=contextbroker(url,auth)
# 
# Create Entity
# broker["id"]=attrib(height=10, width=100A)
# 
# Update Value
# broker["id"]["height"]=100
#
# Retrieve Value
# print(broker["id"]["height"])

import requests
requests.packages.urllib3.disable_warnings() 
import urllib
import json
from collections import UserDict 
import logging

logger=logging.getLogger(__name__)


class ContextBrokerError(Exception) :
    pass


class attrib(UserDict) :

    def as_list(self) :
        r=[]
        for (k,v) in self.items() :
            d=dict(name=k,value=str(v))
            if (type(v)==float) :
                d["type"]="float"
            else :
                if (type(v)==int) :
                    d["type"]="integer"
                else :
                    d["type"]="string"
            r.append(d)
        return(r)

class cb_entity() :

    def __init__(self,theid,thebroker) :
        self.id=theid
        self.broker=thebroker


    def values(self) :
        r=self.broker.request("v1/contextEntities/%s" % (self.id))
        if r["statusCode"]["code"]=="200" :
            return r["contextElement"]
        else :
            raise ContextBrokerError(json.dumps(r["statusCode"]))

    def __iter__(self) :
        v=self.values()
        return((a["name"] for a in v["attributes"]))

           
    def __getitem__(self,key) :
        r=self.broker.request("v1/contextEntities/%s/attributes/%s" % (self.id,key))
        if "attributes" in r and r["attributes"][0]["name"]==key :
            v=r["attributes"][0]
            try :
                if v["type"]=="float" :
                    return float(v["value"])
                if v["type"]=="integer" :
                    return int(v["value"])
            except ValueError :
                pass
            return v["value"]
        else :
            raise KeyError("%s: %s" % (key,json.dumps(r["statusCode"])))

    def __setitem__(self,key,val) :
        r=self.broker.request("v1/contextEntities/%s/attributes/%s" % (self.id,key),
                                   verb="post",
                                   data=json.dumps(dict(value=val)))
        if r["code"]=="200" :
            return
        else :
            raise ContextBrokerError(json.dumps(r["statusCode"]))

    

class contextbroker() :
    
    def __init__(self,url,**param) :
        self._url=url
        param.update(dict(headers={'Content-Type' : 'application/json', 
                                   'Accept' : 'application/json'}))
        self._param=param


    def request(self,path,verb="get",**mparam):
        if mparam :
            param=self._param.copy()
            param.update(**mparam)
        else :
            param=self._param
        try :
            method=getattr(requests,verb)
        except AtttributeError as e:
            raise AttributeError("verb can be get, put, post - got %s" % verb)
        return method(urllib.parse.urljoin(self._url,path),**param).json()


    def __getitem__(self,key) :
        return cb_entity(key,self)
   

    def __setitem__(self,key,ob) :
        data=json.dumps({ 'attributes' : ob.as_list()})
        r=self.request("v1/contextEntities/%s" % key,
                            verb="post",
                            data=data
                            )
        logger.debug("set %s to %s : %s" % (key,data,json.dumps(r)))


    def version(self):
        return self.request("version")


        



if __name__ == '__main__' :
    from test.auth import auth
    import sys
    # logging.basicConfig(level=logging.DEBUG,file=sys.stdout)
    broker=contextbroker("https://orion.robo.report:1027",**auth)
    print("Version = %s" % broker.version())
    print("Creating Room1")
    broker["Room1"]=attrib(temperature=20.5,pressure=744,light="red")
    print("Room 1:%s" % broker["Room1"].values())
    try :
        print("Room 2:%s" % broker["Room2"].values())
    except Exception as e:
        logger.exception(e)
    print("Setting temperature to 30")
    broker["Room1"]["temperature"]=30.0
    print("Geting temperature")
    print("Here it's %s" % broker["Room1"]["temperature"])
    print("Getting non-existent air")
    try :
        print("%s" % broker["Room1"]["air"])
    except Exception as e :
        logger.exception(e) 
    print("Setting non-existent ambience")
    try :
        broker["Room1"]["ambience"]="10"
    except Exception as e :
        logger.exception(e) 
    print("Setting new value light")
    broker["Room1"]["light"]="red"
    print("Room 1:%s" % broker["Room1"].values())
    for a in broker["Room1"] :
        print("%s=%s" % (a,broker["Room1"][a]))






