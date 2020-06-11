# -*- coding: UTF-8 -*-

import requests
import json


def get_api(api_url, api_name, token, record_id=None):
    if not record_id:
        return requests.get('{}/{}/?token={}'.format(api_url, api_name, token))
    return requests.get('{}/{}/{}?token={}'.format(api_url, api_name,
                                                   record_id, token))


def post_api(api_url, api_name, token, data, _json=True):
    if _json:
        data = json.dumps(data)
    headers = {'Content-Type': 'application/json;charset=UTF-8'}
    return requests.post("{}{}?token={}".format(api_url, api_name, token),
                         data=data, headers=headers)
