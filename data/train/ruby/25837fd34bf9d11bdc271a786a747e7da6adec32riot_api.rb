require 'json'
require 'http'
require 'byebug'

URL = {
	base: "https://{proxy}.api.pvp.net/api/lol/(region)/(url)",
	summoner_by_name: "v{version}/summoner/by-name/{names}"
}

API_VERSIONS = {
	summoner: "1.4"
}

REGIONS = {
	north_america: "na"
}

module RiotAPI
	class LeagueAPI
		attr_accessor :region
		def initialize(api_key, region = REGIONS[:north_america])
			@api_key = api_key
			@region = region
		end


		# private
		def request(api_url, params = {})
			debugger
			args = { api_key: @api_key }
			params.each do |k, v|
				unless args.include(k)
					args[k] = v
				end
			end
			response = HTTP.get(
				api_url
				# params: args
			)
			a = JSON.parse(response)
			# puts a
		end

	end
end


#Some tests
include RiotAPI
rito = LeagueAPI.new(ENV['API_KEY'])

# data = rito.request("https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/FoxandLion?api_key=")
data = rito.request("https://na.api.pvp.net/api/lol/na/v2.2/matchlist/by-summoner/30090743?api_key=")
puts data
