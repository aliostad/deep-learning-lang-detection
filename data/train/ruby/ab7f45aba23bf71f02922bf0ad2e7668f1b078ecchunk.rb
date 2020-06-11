require 'uri/common'

# A chunk is a pattern of text that can be protected
# and interrogated by a renderer. Each Chunk class has a 
# +pattern+ that states what sort of text it matches.
# Chunks are initalized by passing in the result of a
# match by its pattern. 

module Chunk
  class Abstract

    # automatically construct the array of derivatives of Chunk::Abstract
    @derivatives = [] 

    class << self 
      attr_reader :derivatives 
    end 
    
    def self::inherited( klass ) 
      Abstract::derivatives << klass 
    end 
    
    # the class name part of the mask strings
    def self.mask_string
      self.to_s.delete(':').downcase
    end

    # a regexp that matches all chunk_types masks
    def Abstract::mask_re(chunk_types)
      tmp = chunk_types.map{|klass| klass.mask_string}.join("|")
      Regexp.new("chunk([0-9a-f]+n\\d+)(#{tmp})chunk")
    end
    
    attr_reader :text, :unmask_text, :unmask_mode

	def initialize(match_data, content) 
          @text = match_data[0] 
          @content = content
          @unmask_mode = :normal
        end
	
    # Find all the chunks of the given type in content
    # Each time the pattern is matched, create a new
    # chunk for it, and replace the occurance of the chunk
    # in this content with its mask.
	def self.apply_to(content)
	  content.gsub!( self.pattern ) do |match|	
	    new_chunk = self.new($~, content)
            content.add_chunk(new_chunk)
            new_chunk.mask
          end
        end

        
	# should contain only [a-z0-9]
	def mask
	  @mask ||="chunk#{@id}#{self.class.mask_string}chunk"
	end

	# We should not use object_id because object_id is not guarantied 
	# to be unique when we restart the wiki (new object ids can equal old ones
	# that were restored form madeleine storage)  
	def id
	  @id ||= "#{@content.page_id}n#{@content.chunk_num}"
	end
	
        def unmask
          @content.sub!(mask, @unmask_text)
        end

        def rendered?
          @unmask_mode == :normal
        end

        def escaped?
          @unmask_mode == :escape
        end
        
        def revert
          @content.sub!(mask, @text)
          # unregister
          @content.delete_chunk(self)
        end

  end
end
