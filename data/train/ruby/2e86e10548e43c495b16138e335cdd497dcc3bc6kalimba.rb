require "set"
require "active_model" # TODO: not all is required?

require "kalimba/version"
require "kalimba/exceptions"
require "kalimba/resource"

module Kalimba
  class << self
    def repository
      @repository ||= Persistence.repository(@repository_options || {})
    end

    # Set repository options
    #
    # @param [Hash] options options to be passed to the repository constructor
    # @return [void]
    def set_repository_options(options = {})
      @repository_options = options
    end
  end
end

require "kalimba/railtie" if defined?(Rails)
