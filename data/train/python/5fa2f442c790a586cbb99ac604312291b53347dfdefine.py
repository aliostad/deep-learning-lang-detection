from wordnik.wordnik import *
apiUrl= 'http://api.wordnik.com/v4'
apiKey ='your wordnik api key here'

client = swagger.ApiClient(apiKey, apiUrl)

wordApi =WordApi.WordApi(client)
def define(word):
    definations = wordApi.getDefinitions(word.strip(),sourceDictionaries='wiktionary',limit=1)
    if(definations):
        meaning= ' "[i]'+ definations[0].partOfSpeech[0] + '.[/i]"' + ' "' + definations[0].text + '"'
        return meaning.encode('ascii', errors='ignore')
    else:
        return "Enter proper word!"
