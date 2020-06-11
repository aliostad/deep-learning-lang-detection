require 'time'
require 'schemad/extensions'

module Schemad
  class TypeHandler
    include Extensions
    extend Forwardable

    UnknownHandler = Class.new(Exception)

    def self.register(handler)
      @types ||= {}

      handler.handles.each do |type|
        @types[type] = handler
      end
    end

    def initialize(type=:string)
      handler = handlers[type]

      raise UnknownHandler, "No known handlers for #{classify(type)}" if handler.nil?

      @handler = handler.new
    end

    def_delegators :@handler, :parse

    private
    def handlers
      self.class.instance_variable_get(:@types) || {}
    end
  end
end
