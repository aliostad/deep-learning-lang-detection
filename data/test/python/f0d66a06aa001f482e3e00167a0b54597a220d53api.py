import requests
import constants as const

class RiotAPI(object):

	def __init__(self, api_key, region):
		self.api_key = api_key
		self.region = region

	def _request(self, api_url, params={}):
		args = {"api_key": self.api_key}
		for key, value in params.items():
			if key not in args:
				args[key] = value
		response = requests.get(const.URL['base'].format(
				proxy=self.region,region=self.region,url=api_url),params=args)
		return response.json()

	def getSummoner(self, api_version, username):
		api_url = const.URL['summoner'].format(
				 version=const.API_VERSIONS[api_version],username=username)
		return self._request(api_url)

	def getMatch(self, api_version, matchID):
		api_url = const.URL['match'].format(
				version=const.API_VERSIONS[api_version],matchId=matchID)
		return self._request(api_url)

	def getLeague(self, api_version, summonerIDs):
		api_url = const.URL['league'].format(
			version=const.API_VERSIONS[api_version], summonerIds=summonerIDs)
		return self._request(api_url)
