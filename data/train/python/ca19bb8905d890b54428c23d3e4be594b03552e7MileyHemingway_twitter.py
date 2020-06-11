import twitter
import markov

message = markov.main()
print message

api_file = open('api.txt')
api_contents = api_file.read()
api_contents_list = api_contents.split()

api_dict = {}

for item in api_contents_list:
	key_value = item.split(',')
	api_dict[key_value[0]] = key_value[1]


api = twitter.Api(
	consumer_key = api_dict['api_key'],
    consumer_secret = api_dict['api_secret'], 
    access_token_key = api_dict['access_token'], 
    access_token_secret = api_dict['access_token_secret']
    )

status = api.PostUpdate(message)