module HappyApi
  module Configuration
    def self.included(base)
      base.class_eval do
        extend ClassMethods

        include HTTParty
      end
    end

    module Excpetions
      class InvalidApiAddress < ArgumentError; end
    end

    module ClassMethods

      URL_REGEXP = Regexp.new("((https?|ftp|file):((//)|(\\\\))+[\w\d:\#@%/;$()~_?\+-=\\\\.&]*)")

      # Configuration block that yields this class
      def configure_api(&block)
        block.call(self)

        base_uri(self.api_end_point)
        format(api_request_format)
      end

      def api_primary_key
        @api_primary_key ||= :id
      end
      
      def api_primary_key=(new_api_primary_key)
        @api_primary_key = new_api_primary_key.to_sym
      end

      def api_population_mode
        @api_population_mode ||= :strict
      end

      def api_population_mode=(new_population_mode)
        if [:strict, :loose].include?(new_population_mode.to_sym)
          @api_population_mode = new_population_mode.to_sym
        end
      end

      def strict_population?
        api_population_mode == :strict
      end

      def loose_population?
        api_population_mode == :loose
      end

      def api_request_format
        @api_request_format ||= :json
      end

      def api_request_format=(new_request_format)
        if [:json, :xml].include?(new_request_format.to_s.downcase.to_sym) 
          @api_request_format = new_request_format.to_s.downcase.to_sym
        else
          @api_request_format = :json
        end
      end

      # Getter for the API resource name
      def api_resource_name
        @api_resource_name ||= self.name.underscore.pluralize
      end

      def api_resource_name=(new_resource_name)
        @api_resource_name = new_resource_name.underscore.pluralize
      end

      # Setter for the base url to access the API
      def api_base_url=(new_api_base_url)
        if (new_api_base_url =~ URL_REGEXP).nil?
          raise HappyApi::Configuration::Excpetions::InvalidApiAddress, "'#{new_api_base_url}' is an invalid url"
        end
        @api_base_url = new_api_base_url
        base_uri(self.api_end_point)
      end

      # Getter for the API base url
      def api_base_url
        @api_base_url ||= "http://localhost"
      end

      # Setter for the API port
      def api_port=(new_api_port)
        @api_port=new_api_port.to_i
      end

      # Getter for the API Port
      def api_port
        @api_port ||= 80
      end

      # Getter for the calculated end point for the API
      def api_end_point
        if self.api_port.to_i != 80
          "#{self.api_base_url}:#{self.api_port}"
        else
          self.api_base_url
        end
      end

      # Verbose mode for Typhoeus's cUrl calls
      def api_verbose=(verbose_mode)
        verbose_mode = [true, false].include?(verbose_mode) ? verbose_mode : false
        Typhoeus::Config.verbose = verbose_mode
      end

      def api_conn=(new_conn)
        @conn = new_conn
      end

      protected 
      
      def api_conn
        self
      end

    end # ClassMethods
  end
end