#!/usr/bin/env python
import json
import httplib
import sys

def connect():

  # TODO don't hardocde the IP of the bridge :)
  #api = httplib.HTTPConnection('192.168.2.208', 80)
  api = httplib.HTTPConnection('192.168.1.244', 80)
  api.connect()
  api.url = '/api/1234567890/'
  return api

def getLights(api):
  api.request('GET', api.url + 'lights', json.dumps({}))
  return json.loads(api.getresponse().read())

def getLightState(api, id):
  api.request('GET', api.url + 'lights/' + str(id))
  return json.loads(api.getresponse().read())

def setLightState(api, id, state):
  api.request('PUT', api.url + 'lights/' + str(id) + '/state', json.dumps(state))
  return json.loads(api.getresponse().read())

