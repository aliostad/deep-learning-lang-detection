require 'kanpachi/api'
require 'kanpachi/api_list'
require 'kanpachi/dsl/api'

module Kanpachi
  # Extending the top level module to add dsl methods
  #
  # @api public
  module DSL
    private

    def api(name, &block)
      api = Kanpachi::APIList.find(name) || Kanpachi::API.new(name)
      dsl = API.new(api)
      dsl.instance_eval &block
      Kanpachi::APIList.add(api)
      api
    end
  end
end

# Extend the main object with the DSL methods. This allows top-level calls
# without polluting the object inheritance tree.
self.extend Kanpachi::DSL