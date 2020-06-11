#!flask/bin/python
from flask import Flask, jsonify, request, render_template
import requests

app = Flask(__name__)
port=2000


def getProviders_f(broker_url, scope, entity):
    target_url = broker_url+"/getProviders"
    r = requests.get(target_url, params={'scope': scope, 'entity': entity})
    return r.content

def subscribe_f(broker_url, entity, scope_list, url, time):
    target_url = broker_url+"/subscribe"
    entity_a = entity.split('|')
    subscribe_tuple = {'entity': entity_a[1], 'type': entity_a[0], 'scopeList': scope_list, 'callbackUrl': url, 'time': time}
    r = requests.get(target_url, params=subscribe_tuple)
    return r.content

def getContext_f(broker_url, entities, scope_list):
    target_url = broker_url+"/getContext"
    getcontext_tuple = {'scopeList': scope_list, 'entities': entities}
    r = requests.get(target_url, params=getcontext_tuple)
    return r.content

@app.route('/getProviders')
def getProviders():
    broker_url = request.args.get('broker_url')
    scope= request.args.get('scope')
    entity= request.args.get('entity')
    result = getProviders_f(broker_url, scope, entity)
    return result

@app.route('/subscribe')
def subscribe():
    broker_url = request.args.get('broker_url')
    entity = request.args.get('entity')
    scope_list = request.args.get('scope_list')
    url = request.args.get('url')
    time = request.args.get('time')
    result = subscribe_f(broker_url, entity, scope_list, url, time)
    return result

@app.route('/getContext')
def getContext():
    broker_url = request.args.get('broker_url')
    entity = request.args.get('entity')
    scope_list = request.args.get('scope_list')
    result = getContext_f(broker_url, entity, scope_list)
    return result

@app.route('/')
def index():
    getp_entity=''
    getp_scope='test5'
    subs_entity='username|anderson'
    subs_scopes='test2,scope2'
    subs_url= 'http://localhost:'+str(port)
    subs_time= '30'
    getc_entities='username|anderson'
    getc_scopes='test2'

    return render_template("index.html", broker_url="http://localhost:5000",
                           getp_entity=getp_entity, getp_scope=getp_scope,
                           subs_entity=subs_entity, subs_scopes=subs_scopes, subs_url=subs_url, subs_time=subs_time,
                           getc_entities=getc_entities, getc_scopes=getc_scopes)

if __name__ == '__main__':
    app.run(debug=True, use_reloader=True, port=port)
