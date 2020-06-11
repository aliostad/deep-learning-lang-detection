# Getting the write permission

import flickr_api
API_KEY =  'api-key'
API_SECRET = 'api-secret'
flickr_api.set_keys(api_key = API_KEY, api_secret = API_SECRET)
a = flickr_api.auth.AuthHandler() #creates the AuthHandler object
perms = "write" # set the required permissions
url = a.get_authorization_url(perms)
print url

# Run up to this point and go to url
# Copy the oauth_verification

a.set_verifier("oauth-verifier")
flickr_api.set_auth_handler(a)




# Uploading image to flickr

import flickr_api 
filename = "./flickrauth"

API_KEY =  'api-key'
API_SECRET = 'api-secret'
flickr_api.set_keys(api_key = API_KEY, api_secret = API_SECRET)

a = flickr_api.auth.AuthHandler.load(filename)
flickr_api.set_auth_handler(a)

flickr_api.upload(photo_file = "image-path", title = "My title")
