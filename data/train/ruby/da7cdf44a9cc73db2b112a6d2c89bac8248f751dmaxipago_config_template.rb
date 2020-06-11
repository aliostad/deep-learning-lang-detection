# Set your key and id
MP_APIKEY = ENV['MP_APIKEY']
MP_ID = ENV['MP_ID']

# Set the Maxipago API version: currently (3.1.1.15)
MP_APIVERSION = "3.1.1.15"

# Maxipago API Urls - production
MP_URL_TRANSACTION = "https://api.maxipago.net/UniversalAPI/postXML"
MP_URL_API = "https://api.maxipago.net/UniversalAPI/postAPI"
MP_URL_RAPI =  "https://api.maxipago.net/ReportsAPI/servlet/ReportsAPI"

# Maxipago API Urls - development and test
URL_TEST_TRANSACTION = "https://testapi.maxipago.net/UniversalAPI/postXML"
URL_TEST_API = "https://testapi.maxipago.net/UniversalAPI/postAPI"
URL_TEST_RAPI = "https://testapi.maxipago.net/ReportsAPI/servlet/ReportsAPI"