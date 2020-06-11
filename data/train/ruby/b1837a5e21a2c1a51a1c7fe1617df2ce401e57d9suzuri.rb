require "suzuri/version"

module Suzuri
  autoload(:Choice, 'suzuri/choice')
  autoload(:User, 'suzuri/user')
  autoload(:Item, 'suzuri/item')
  autoload(:Client, 'suzuri/client')
  autoload(:Operations, 'suzuri/operations')
  autoload(:SuzuriError, 'suzuri/suzuri_error')
  autoload(:APIConnectionError, 'suzuri/suzuri_error')
  autoload(:APIError, 'suzuri/suzuri_error')
  autoload(:Entity, 'suzuri/entity')

  @api_base = 'https://suzuri.jp/'
  @api_version = 'api/v1'
  @api_key = nil

  class << self
    def client
      @client ||= Client.new(@api_key, @api_base, @api_version)
    end

    def api_base=(new_value)
      @api_base = new_value
      @client = nil
    end

    def api_key=(new_value)
      @api_key = new_value
      @client = nil
    end

    def api_base
      @api_base
    end

    def api_key
      @api_key
    end
  end

end
