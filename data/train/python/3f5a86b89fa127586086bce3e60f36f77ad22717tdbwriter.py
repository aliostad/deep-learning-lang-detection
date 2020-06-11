from datetime import datetime
from time import sleep
import random
from tempodb import Client, DataPoint
import tempodb
from os import getenv

API_KEY = getenv('API_KEY')
assert API_KEY, "API_KEY is required"

API_SECRET = getenv('API_SECRET')
assert API_SECRET, "API_SECRET is required"

SERIES_KEY = getenv('SERIES_KEY', 'prng')
API_HOST = getenv('API_HOST', tempodb.client.API_HOST)
API_PORT = int(getenv('API_PORT', tempodb.client.API_PORT))
API_SECURE = bool(getenv('API_SECURE', True))

client = Client(API_KEY, API_SECRET, API_HOST, API_PORT, API_SECURE)

while True:
    client.write_key(SERIES_KEY, [DataPoint(datetime.now(), random.random() * 50.0)])
    sleep(1)
