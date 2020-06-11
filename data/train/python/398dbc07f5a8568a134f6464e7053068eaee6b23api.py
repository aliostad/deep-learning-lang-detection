import os
import requests

from requests.auth import HTTPBasicAuth

if 'API_URL' in os.environ:
    API_URL = os.environ['API_URL']
    API_USER = os.environ['API_USER']
    API_PASSWORD = os.environ['API_PASSWORD']
else:
    API_URL = "http://localhost:8000/api/v1/"
    API_USER = "ken"
    API_PASSWORD = "emily"

AUTH = HTTPBasicAuth(API_USER, API_PASSWORD)


def get_score_attribute(slug):
    """ query API to get the data we need """
    #TODO: Add some caching
    if not slug:
        return None
    r = requests.get("{0}score-attributes/{1}/".format(API_URL, slug),
                     auth=AUTH)
    if r and r.status_code == 200:
        return r.json()
    else:
        return None
