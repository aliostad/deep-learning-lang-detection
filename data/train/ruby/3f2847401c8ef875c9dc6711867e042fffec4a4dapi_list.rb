module Kanpachi
  # Module to keep track of all APIs
  #
  # @api public
  module APIList
    module_function

    @list ||= {}

    # Returns a hash of APIs
    #
    # @return [Hash<Kanpachi::API>] All the added APIs.
    # @api public
    def to_hash
      @list
    end

    # Returns an array of APIs
    #
    # @return [Array<Kanpachi::API>] List of added APIs.
    # @api public
    def all
      @list.values
    end

    # Add a resource to the list
    #
    # @param [Kanpachi::API] The API to add.
    # @return [Hash<Kanpachi::API>] All the added APIs.
    # @raise DuplicateAPI If a resource is being duplicated.
    # @api public
    def add(api)
      @list[api.name] = api
    end

    # Delete a resource to the list
    #
    # @param [String] The name of the API to delete.
    # @api public
    def delete(name)
      @list.delete(name)
    end

    # Returns a API based on its name
    #
    # @param [String] name The name of the API you are looking for.
    # @return [Kanpachi::API] The found API.
    #
    # @api public
    def find(name)
      @list[name]
    end

    # Clears all APIs
    #
    # @api public
    def clear
      @list = {}
    end
  end
end
