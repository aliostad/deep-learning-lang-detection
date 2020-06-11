require_relative 'api'
require_relative 'api_declaration'
require_relative 'resource_listing'

module SwaggerYard
  class Parser
    attr_reader :listing

    def initialize
      @listing = ResourceListing.new
    end

    def run(yard_objects)
      api_declaration = ApiDeclaration.new
      retain_api = true
      
      yard_objects.each do |yard_object|
        case yard_object.type
        when :class
          break unless retain_api = api_declaration.add_listing_info(yard_object)
        when :method
          api = Api.new(yard_object)
          api_declaration.add_api(api) if api.valid?
        end
      end

      if retain_api
        @listing.add(api_declaration)
        api_declaration
      else
        nil
      end
    end
  end
end