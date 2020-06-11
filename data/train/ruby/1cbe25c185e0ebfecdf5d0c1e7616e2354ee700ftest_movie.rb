lib = File.expand_path('../', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'httparty'
require 'json'
require 'ostruct'

module TestMovie
  class Movie
    def self.search(id) 
      api = TestMovie.api_key
      response = HTTParty.get("http://api.rottentomatoes.com/api/public/v1.0/movies/#{id}.json?apikey=#{api}")
      movie = JSON.parse(response.body)
      n = OpenStruct.new movie
      return n
    end
  end
  
  def api_key=(val)
    @api_key = val
  end

  def api_key
    @api_key
  end
  module_function :api_key=, :api_key
end