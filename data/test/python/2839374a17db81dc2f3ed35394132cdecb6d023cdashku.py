""" 
Dashku.com API wrapper

""" 

import requests
import json

api_key = ""
api_url = "http://dashku.com"

### API SETTER METHODS

def set_api_key(value):
  
  """ Sets the API key that you will use to make API requests with

  Keyword arguments:
  value -- Your API key

  """
  
  global api_key 
  api_key = value
  return api_key

def set_api_url(value):
  
  """ Sets the url that the API uses, in case you're using a self-hosted 
  version of Dashku

  Keyword arguments:
  value -- The API url. In the module, this is http://dashku.com by default

  """ 
  
  global api_url 
  api_url = value
  return api_url