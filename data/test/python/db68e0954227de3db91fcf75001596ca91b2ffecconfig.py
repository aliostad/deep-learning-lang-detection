import al_papi

class Config(object):
  """
    Config class is used to set your api key before making any API requests.::
    
      al_papi.Config.setup("your-api-key")
    
    Once your api key is set up you can make requests to the API.
  """
  default_host = "http://api.authoritylabs.com"
  port         = 80
  api_key      = ""

  @staticmethod
  def setup(api_key):
    Config.api_key = api_key

  @staticmethod
  def create():
    return Config(Config.api_key)

  def __init__(self, api_key):
    self.api_key = api_key
  
