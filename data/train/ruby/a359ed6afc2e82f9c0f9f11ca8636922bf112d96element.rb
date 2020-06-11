require "bbcode/node_list"

module Bbcode
	class Element
		def initialize( handler_element )
			@handler_element = handler_element
		end

		def tagname
			@handler_element.tagname
		end

		def attributes
			@handler_element.attributes
		end

		def []( key )
			@handler_element.attributes[key]
		end

		def source
			@handler_element.source
		end

		def source_wraps_content( content = nil )
			"#{@handler_element.start_source}#{content || self.content}#{@handler_element.end_source}"
		end

		def content
			NodeList.new @handler_element.handler, @handler_element.childs.map{ |child_handler_element| child_handler_element.is_a?(String) ? child_handler_element : child_handler_element.element }
		end

		def to_s
			@handler_element.handler.apply_element_handler_for_element self
		end
	end
end