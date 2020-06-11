module Merchantry
  class Request
    class InitProcess < Merchantry::Request
      PATH         = "process/initProcess"
      PROCESS_NAME = "initProcessRequest"

      PROCESS_KEYS = {
        :orders                => 'IMPORT_FROM_RETAILER.ORDERS',
        :refunds               => 'IMPORT_FROM_RETAILER.REFUNDS',
        :category_tree         => 'IMPORT_FROM_RETAILER.CATEGORY_TREE',
        :rmas                  => 'IMPORT_FROM_RETAILER.RMAS',
        :product_auth_response => 'IMPORT_FROM_RETAILER.PRODUCT_AUTH_RESPONSE',
        :product_response      => 'IMPORT_FROM_RETAILER.PRODUCT_RESPONSE',
        :listing_response      => 'IMPORT_FROM_RETAILER.LISTING_RESPONSE'
      }

      def initialize(type)
        @type = type
        init_process_base[:processCode] = process_code
      end

      def process_id
        nokogiri_response.xpath("processResultDto/processId").text
      end

      private

      def init_process_data
        {
          :channelName => Merchantry::Request::CHANNEL_NAME,
          :processCode => process_code
        }.to_xml(root: 'initProcessRequest')
      end

      def feed_file
        @feed_file ||= Merchantry::File.new('order_test.xml', 'rb').tap do |file|
          file.content_type = "application/octet-stream"
        end
      end

      def process_code
        PROCESS_KEYS.fetch(@type)
      end
    end
  end
end

