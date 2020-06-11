import re
from operator import attrgetter, itemgetter

class Router(object):

    def initializeApi(self, base_url, api_list):
        """RestEngine api router initialize"""

        self.base = base_url
        
        for api in api_list:
            if not api.startswith("/"): api = "/" + api
            if not api.endswith('/'): api += "/"
            self.validateApi(api)
            pattern = re.sub(r"/:\w+", "/\w*", api)
            pattern = re.sub(r"/numeric:\w+", "/\d*", pattern)
            self.addRestApi(api, pattern)
            print(api.count("/"), pattern, api)



    def addRestApi(self, api, regex_pattern):
        rest = self.rest
        word_count = api.count("/") - 1
        parameter_count = api.count(":")
        regex = re.compile("^" + regex_pattern + "$")
        new_api = {"api": api,
                   "pattern": regex_pattern,
                   "regex": regex,
                   "resource_count": word_count - parameter_count,
                   "priority": api.count("/numeric:")
                   }
        if rest.get(word_count) is None:
            rest[word_count] = []

        api_list = rest.get(word_count)

        for a in api_list:
            if a.get("pattern") == regex_pattern:  # maybe regex_pattern :S?
                print(new_api, a)
                raise "pattern duplicated"


        api_list = rest.get(word_count)
        api_list.append(new_api)
        api_list.sort(key=itemgetter("resource_count", "priority"))



    def findRestApi(self, path):

        if(path.startswith(self.base)):
            path = path[len(self.base):]
        if not path.endswith("/"):
            path += "/"

        api_list = self.rest.get(path.count("/") - 1)
        if(isinstance(api_list, list)):
           for api in api_list:
               regex = api.get("regex")
               if regex.match(path):
                   return api, path
        if(isinstance(api_list, dict)):
            regex = api_list.get("regex")
            if(regex.match(path)):
                return api_list, path

    def validateApi(self, api):
        """/resource(/:query)* | (/resource(/:query)+)+"""
        if not self.api_pattern.match(api):
            print(api)
            raise "pattern error"

