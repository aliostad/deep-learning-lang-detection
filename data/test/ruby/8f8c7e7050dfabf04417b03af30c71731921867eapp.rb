require 'sinatra/base'
require 'casa/publisher/persistence/memory_storage_handler'
require 'casa/publisher/strategy/all/sinatra'

module CASA
  module Publisher
    class App < Sinatra::Base

      @@storage_handler = false

      @@postprocess_handler = false

      def self.set_postprocess_handler handler

        @@postprocess_handler = handler

      end

      def self.set_storage_handler handler

        @@storage_handler = handler

      end

      def self.postprocess_handler

        @@postprocess_handler

      end

      def self.storage_handler

        @@storage_handler

      end

      get '/out/payloads' do

        handler = CASA::Publisher::Strategy::All::Sinatra.new self,
          'from_handler' => @@storage_handler,
          'postprocess_handler' => @@postprocess_handler

        handler.execute

      end

      get '/payloads' do

        call! env.merge("PATH_INFO" => '/out/payloads')

      end

    end
  end
end
