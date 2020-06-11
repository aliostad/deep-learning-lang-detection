#!flask/bin/python
__author__ = 'anderson'

from flask import Flask, jsonify, request, render_template
import requests
import os

app = Flask(__name__)

def advertise_f(xml_string, broker_url):
    target_url = broker_url+"/advertisement"
    r = requests.post(target_url, xml_string)
    return r.content

def update_f(xml_string, broker_url):
    target_url = broker_url+"/update"
    r = requests.post(target_url, xml_string)
    return r.content

@app.route('/advertise')
def advertise():
    xml_string= request.args.get('xml_string')
    broker_url = request.args.get('broker_url')
    result = advertise_f(xml_string,broker_url)
    return result

@app.route('/update')
def update():
    xml_string = request.args.get('xml_string')
    broker_url = request.args.get('broker_url')
    result = update_f(xml_string,broker_url)
    return result

@app.route('/getContext', methods=['GET'])
def get_context():
    scope_list = request.args.get('scope_list')
    entities = request.args.get('entities')
    r = '<contextML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://ContextML/1.6c" ' \
        'xsi:schemaLocation="http://ContextML/1.7http://cark3.cselt.it/schemas/ContextML-1.6.c.xsd">' \
        '<ctxEls><ctxEl><contextProvider id="testProv" v="1.0.0" />' \
        '<entity id="username" type="anderson" /><scope>test2</scope>' \
        '<timestamp>2013-09-10T14:57:18+02:00</timestamp><expires>2013-09-10T14:57:48+02:00</expires>' \
        '<dataPart><par n="lat">49.424978</par>                ' \
        '<par n="lon">7.750602</par>            ' \
        '</dataPart></ctxEl></ctxEls></contextML>'
    return r

@app.route('/')
def index():
    with open(os.path.dirname(os.path.abspath(__file__)) + '/adv.xml', 'r') as f:
        adv_xml= f.read()
    with open(os.path.dirname(os.path.abspath(__file__)) + '/upd.xml', 'r') as f:
        upd_xml= f.read()
    return render_template("index.html", broker_url="http://localhost:5000", adv_xml=adv_xml, upd_xml=upd_xml)

if __name__ == '__main__':
    app.run( use_reloader=True, port=3000)
