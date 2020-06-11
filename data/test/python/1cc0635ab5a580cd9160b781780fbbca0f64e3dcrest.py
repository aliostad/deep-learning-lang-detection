# preliminaries
import swagger_client

base_url = 'http://localhost:8200/api'
client_id = ''
client_secret = ''

# instantiate Auth API
unauthenticated_client = swagger_client.ApiClient(base_url)
#unauthenticated_authApi = api.ApiAuthApi(unauthenticated_client)

# authenticate client
#token = unauthenticated_authApi.login(client_id=client_id, client_secret=client_secret)
#client = api.ApiClient(base_url, 'Authorization', 'token ' + token.access_token)
client = swagger_client.ApiClient(base_url)

# instantiate Look API
api = swagger_client.DefaultApi(client)
model = swagger_client