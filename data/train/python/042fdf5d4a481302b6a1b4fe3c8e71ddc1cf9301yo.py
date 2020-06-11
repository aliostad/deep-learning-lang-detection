#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests

class api():
    def __init__(self, api_key):
        self.api_key = api_key

    def yoall(self):
        requests.post("http://api.justyo.co/yoall/",
                data={'api_token': self.api_key})

    def yo(self, username):
        requests.post("http://api.justyo.co/yo/",
                data={'api_token': self.api_key, 'username': username})

    def subscribers_count(self):
        r = requests.get("http://api.justyo.co/subscribers_count/",
                params={'api_token': self.api_key})
        return r.json()['result']
