#import as needed from wordnik usage APIs
from wordnik import WordApi
from wordnik import swagger
apiUrl = 'http://api.wordnik.com/v4'
apiKey = '9fd570b79ede09df0600e002c6b0f9b14571c3ecfe4a35c13'


def definition(word):
    client = swagger.ApiClient(apiKey, apiUrl)
    wordApi = WordApi.WordApi(client)

    res = wordApi.getDefinitions(word, limit = 3)
    return [result.text for result in res]


def relatedwords(word):
    client = swagger.ApiClient(apiKey, apiUrl)
    wordApi = WordApi.WordApi(client)

    res = wordApi.getRelatedWords(word, limit = 10)
    return res