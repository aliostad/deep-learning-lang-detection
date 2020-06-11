require 'rapleaf_api'

#************************#
#***RAPLEAF API SEARCH***#
#************************#

#Query the Rapleaf API with the 'rapleaf_api' gem and return the result
module Stalky
  class Rapleaf
    def self.search(param)
        puts "Rapleaf search..."
        
        #How do I get from config/initializers/stalky.rb ?
        rapleaf_api_key = "965b2d768c13f2e5d3967ebae375fe4e"
        
        api = RapleafApi::Api.new(rapleaf_api_key)
        
        #rapleaf api only lets you query by email address'
        hash = api.query_by_email(param)
        
        #this is just dumping all results for now
        hash.each {|key, value| puts "#{key}: #{value}"}
      end
  end
end
