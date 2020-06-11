#!/usr/bin/ruby
# @Author: Stéphane Vialette
# @Date:   2014-03-27 03:58:12
# @Last Modified by:   Stéphane Vialette
# @Last Modified time: 2014-04-30 23:25:22

module OCS
  module Rb
    module Core
      module Wrapper
        class Id

          #
          #
          #
          def initialize(id = nil)
            @id    = id
            @chunk = 0
          end

          # Get a new message id
          #
          # @return [Integer]
          def id
            @id = OCS::Core::MessageIdServer.new_message_id if @id.nil?
            @id
          end
          private :id

          #
          #
          # @return [Integer]
          def chunk
            @chunk = @chunk + 1
            @chunk
          end
          private :chunk

          #
          #
          # @return [Hash] [description]
          def id_and_serial
            {
              :message_id => id,
              :chunk      => chunk
            }
          end
          private :id_and_serial

          #
          #
          # @return [Hash]
          def wrap(message)
            message.merge!(id_and_serial)
            message
          end

          # Delete :message_id and :chunk keys in message
          #
          # @return [Hash] [description]
          def self.unwrap(message)
            message.delete(:message_id)
            message.delete(:chunk)
            message
          end

        end # class Id
      end # module Wrapper
    end # Core
  end # module Rb
end # module OCS
