module Smooth
  module DslAdapter
    # Creates or opens an API definition
    def api(name, *args, &block)
      Smooth.current_api_name = name

      config_block = block_given?

      instance = Smooth.fetch_api(name) do |_key|
        options = args.dup.extract_options!

        Smooth::Api.new(name, options)
      end

      instance.tap { |obj| obj.instance_eval(&block) if config_block }
    end

    # Creates or opens a resource definition
    def resource(name, *args, &block)
      options = args.extract_options!

      api = case
        when options[:api].is_a?(Symbol) || options[:api].is_a?(String)
          Smooth.fetch_api(options[:api])
        when options[:api].is_a?(Smooth::Api)
          options[:api]
        else
          Smooth.current_api
      end

      api.resource(name, options, &block)
    end
  end
end
