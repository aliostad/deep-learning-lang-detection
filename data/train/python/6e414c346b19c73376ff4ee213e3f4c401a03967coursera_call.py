import requests
from pprint import pprint

# The following suggests a well designed api such as coursera

simple_api_call = 'https://api.coursera.org/api/catalog.v1/courses/2'

an_api_call = 'https://api.coursera.org/api/catalog.v1/courses?fields=language,shortDescription'

api_call = 'https://api.coursera.org/api/catalog.v1/categories?id=1&fields=name,shortName&includes=courses'

complicated_api_call = 'https://api.coursera.org/api/catalog.v1/categories?id=1&fields=name,courses.fields(photo,universityLogo,language)&includes=courses'

print "A simple api call: "
print "-" * 10
pprint(requests.get(api_call).json())

print "Not a simple api call: "
print "-" * 10
pprint(requests.get(complicated_api_call).json())
