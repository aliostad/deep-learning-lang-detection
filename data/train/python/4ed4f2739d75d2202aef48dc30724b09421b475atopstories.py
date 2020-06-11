__author__ = 'dewaka'

import news.nyapi
import requests

API_INFO = {
    "top_stories": {
        "api_root" : 'http://api.nytimes.com/svc/topstories/v1/home.json?api-key={0}',
        "api_key": news.nyapi.NY_TOPSTORIES_KEY
    },
    "popular_stories": {
        "api_root" : 'http://api.nytimes.com/svc/mostpopular/v2/mostviewed/Business%20Day/1.json?offset={0}&api-key={1}',
        "api_key": news.nyapi.NY_POPULARSTORIES_KEY
    }
}

class NyTimes:
    def _topstories_api(self):
        api = API_INFO['top_stories']
        return api['api_root'].format(api["api_key"])

    def _popular_stories_api(self, offset):
        api = API_INFO['popular_stories']
        url = api['api_root'].format(offset, api["api_key"])
        return url

    def daily_popular_stories(self, offset, **kwargs):
        req = requests.get(self._popular_stories_api(offset))
        #print req.text
        return req.json()

    def top_stories(self, **kwargs):
        req = requests.get(self._topstories_api())
        return req.json()
