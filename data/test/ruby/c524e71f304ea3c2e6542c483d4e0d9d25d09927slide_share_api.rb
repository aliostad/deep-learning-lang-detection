require 'sha1'
require 'cgi'
require 'open-uri'
require 'nokogiri'

class SlideShareApi
  @@API_URL = "http://www.slideshare.net/api/2"

  def initialize(api_key, api_secret)
    @api_key = api_key
    @api_secret = api_secret
  end

  def get_slideshow_information(slideshow_id, slideshow_url = nil)
    # generate url
    api_url = "#{@@API_URL}/get_slideshow"
    # create hash
    timestamp = Time.now.to_i
    hash =  SHA1.hexdigest("#{@api_secret}#{timestamp}")
    # create the full query api
    full_api_url = "#{api_url}?api_key=#{@api_key}&ts=#{timestamp}&hash=#{hash}"
    full_api_url = !slideshow_id.nil? ? "#{full_api_url}&slideshow_id=#{slideshow_id}" : full_api_url
    full_api_url = !slideshow_url.nil? ? "#{full_api_url}&slideshow_url=#{CGI.escape(slideshow_url)}" : full_api_url
    # Fetch and parse the results
    result = Nokogiri::XML(open(full_api_url))
    return result
  end

  def get_slideshows_by_tag(tag, limit = 100, offset = 0, detailed = 0)
    # generate url
    api_url = "#{@@API_URL}/get_slideshows_by_tag"
    # create hash
    timestamp = Time.now.to_i
    hash =  SHA1.hexdigest("#{@api_secret}#{timestamp}")
    # create the full query api
    full_api_url = "#{api_url}?api_key=#{@api_key}&ts=#{timestamp}&hash=#{hash}&tag=#{CGI.escape(tag)}&limit=#{limit}&offset=#{offset}&detailed=#{detailed}"
    # Fetch and parse the results
    result = Nokogiri::XML(open(full_api_url))
    return result
  end

  def fetch_transcript(url)
    page = Nokogiri::HTML(open(url))
    return page.search("//ol[@class='transcripts h-transcripts']/li/text()").to_s
  end
end