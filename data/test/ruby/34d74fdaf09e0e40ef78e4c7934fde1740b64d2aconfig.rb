require 'HTTParty'

# make sure to setup the Appen Global keys and secret in your environment or equivilent.
# these values should generally not be stored in your code.
API_KEY = ENV['APPEN_GLOBAL_API_KEY']
API_SECRET = ENV['APPEN_GLOBAL_API_SECRET']

# this is the code specified for you project. see project manager if you don't your project_code value.
PROJECT_CODE = 'alpha_1'

# configure paths to API
API_URI = 'https://api-global-stage.appen.com'
API_VERSION = '/api/v2'
API_URI_CHECKUP = API_URI + '/checkup'
#API_URI_STATUS = API_URI + '/agp_status/' + API_KEY
API_URI_STATUS = API_URI + '/checkup'
API_URI_SUBMIT = API_URI + API_VERSION + '/submit/' + API_KEY
API_URI_RESULTS = API_URI + API_VERSION + '/results/' + API_KEY
API_URI_PROJECT_STATUS = API_URI + API_VERSION + '/project_status/' + API_KEY
