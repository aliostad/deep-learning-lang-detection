API_KEYS = YAML.load_file(Rails.root.join('config', 'api_keys.yml'))

# Twitter API Keys
TWITTER_API_KEY                 = API_KEYS['twitter']['api_key']
TWITTER_API_SECRET              = API_KEYS['twitter']['api_secret']
TWITTER_API_ACCESS_TOKEN        = API_KEYS['twitter']['api_access_token']
TWITTER_API_ACCESS_TOKEN_SECRET = API_KEYS['twitter']['api_access_token_secret']

# Facebook API Keys
FACEBOOK_API_KEY    = API_KEYS['facebook']['api_key']
FACEBOOK_API_SECRET = API_KEYS['facebook']['api_secret']

#Souncloud API Keys
SOUNDCLOUD_API_KEY = API_KEYS['soundcloud']['api_key']

#Songkick API Keys
SONGKICK_API_KEY = API_KEYS['songkick']['api_key']

#Youtube API Keys
YOUTUBE_API_KEY = API_KEYS['youtube']['api_key']
YOUTUBE_API_SECRET = API_KEYS['youtube']['api_key']
YOUTUBE_API_CODE = API_KEYS['youtube']['code']