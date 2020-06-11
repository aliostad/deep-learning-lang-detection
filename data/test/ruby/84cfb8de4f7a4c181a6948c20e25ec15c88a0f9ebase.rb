module Bbcode
	class Base
		@@handlers = HashWithIndifferentAccess.new

		attr_reader :locals

		def initialize(parser, string)
			@parser = parser
			@string = string
		end

		def to(handler_name, locals = {})
			handler = Bbcode.handler handler_name
			raise "Handler #{handler} isn't registered." if handler.nil?
			handler.locals = locals.with_indifferent_access
			@parser.parse @string, handler
			result = handler.get_document.content.to_s
			handler.clear
			result
		end

		def self.register_handler(name, handler)
			puts "WARNING: Bbcode::Base.register_handler is deprecated. Use Bbcode.register_handler instead."
			Bbcode.register_handler(name, handler)
		end
	end
end