CREATE DATABASE "honeypotSSH"

CREATE TABLE SERVER (
  ID SERIAL  NOT NULL ,
  NAME VARCHAR(255)    ,
  IP VARCHAR(20)    ,
  PORT VARCHAR(20)     ,
  START_TIME TIMESTAMP    ,
  CONFIGURATION TEXT     ,
PRIMARY KEY(ID));

CREATE TABLE CONNECTIONS (
  ID SERIAL   NOT NULL ,
  HONEYPOT VARCHAR(255), 
  SESSION INTEGER    ,
  IP VARCHAR(20)    ,
  COUNTRY VARCHAR(255),
  PORT VARCHAR(20)    ,
  CLIENT VARCHAR(255)    ,
  LOGIN VARCHAR(255)    ,
  PASSWORD VARCHAR(255)    ,
  AUTHENTICATED VARCHAR(255)    ,
  COMMANDS TEXT    ,
  START_TIME TIMESTAMP    ,
  FINISH_TIME TIMESTAMP      ,
PRIMARY KEY(ID));

CREATE PROCEDURAL LANGUAGE 'plpythonu' HANDLER plpython_call_handler; 

CREATE FUNCTION country_from_ip() RETURNS trigger AS '
import urllib2 
from HTMLParser import HTMLParser  
class MyHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.start = 0 
        self.country = 0 
        self.found = 0 
        self.data = []
    def handle_starttag(self, tag, attrs):
        if tag == "th":
            self.start = 1
        elif tag == "td" and self.country:
            self.found = 1 
            self.country = 0
    def handle_endtag(self, tag):
        if tag == "th":
            self.start = 0 

    def handle_data(self, data):
        if self.start and data == "Country:":
            self.country = 1
        elif self.found :
            self.data.append(data)
            self.found = 0

id = TD["new"]["id"]
ip = TD["new"]["ip"]
if ip:
    p = MyHTMLParser()
    f = urllib2.urlopen("http://whatismyipaddress.com/ip/" + ip)
    html = f.read()
    p.feed(html)
    p.close()
    update_plan = plpy.prepare("UPDATE connections SET country = $2 WHERE id = $1", ["int", "text"])
    plpy.execute(update_plan, [id, p.data[0]])
' LANGUAGE plpythonu;

CREATE TRIGGER update_country
AFTER INSERT ON connections
FOR EACH ROW
EXECUTE PROCEDURE country_from_ip();