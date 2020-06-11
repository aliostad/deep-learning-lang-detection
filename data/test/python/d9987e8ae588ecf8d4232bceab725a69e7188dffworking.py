# to get wordnik: 
# pip install wordnik

# to get SQLAlchemy:
# pip install SQLAlchemy


WORDNIK_API_KEY = '9145508c698b2bf9890060e81550248ff6aacbf7cefc957f6'
VOCAB_DB_LOCATION = 'vocab.db'

import sqlite3
from wordnik import *

conn = sqlite3.connect(VOCAB_DB_LOCATION)
c = conn.cursor()

# wordnik business
apiUrl = 'http://api.wordnik.com/v4'
apiKey = WORDNIK_API_KEY
client = swagger.ApiClient(apiKey, apiUrl)

wordApi = WordApi.WordApi(client)
for word in c.execute('SELECT stem FROM WORDS'):
	definitions = wordApi.getDefinitions(word[0])
	print word[0], ': ', definitions[0].text