require "mailgun_scrapper/version"
require_relative "./mailgun_scrapper/query"
require_relative "./mailgun_scrapper/parser"

module MailgunScrapper
  class Scrapper
    @api_key = ''
    @api_version = 'v2'
    @api_host = 'api.mailgun.net'
    @domain = ''
    class << self
      attr_accessor :api_key,
                    :api_version,
                    :api_host,
                    :domain
    end
    def initialize(api_key, api_version = 'v2', api_host = 'api.mailgun.net', domain=  '')
      self.api_key = api_key
      self.api_version = api_version
      self.api_host = api_host
      self.domain = domain
    end

    def scrap(filters = {}, attributes = [])
      logs = MailgunScrapper::Query.new(options, @api_key, @api_version, @api_host, @domain).logs
      MailgunScrapper::Parser.new(logs, attributes).events
    end
  end
end
