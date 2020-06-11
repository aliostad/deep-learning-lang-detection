require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Swt::Internal::Image
  module PngChunkReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Swt::Internal::Image
      include ::Org::Eclipse::Swt
    }
  end
  
  class PngChunkReader 
    include_class_members PngChunkReaderImports
    
    attr_accessor :input_stream
    alias_method :attr_input_stream, :input_stream
    undef_method :input_stream
    alias_method :attr_input_stream=, :input_stream=
    undef_method :input_stream=
    
    attr_accessor :read_state
    alias_method :attr_read_state, :read_state
    undef_method :read_state
    alias_method :attr_read_state=, :read_state=
    undef_method :read_state=
    
    attr_accessor :header_chunk
    alias_method :attr_header_chunk, :header_chunk
    undef_method :header_chunk
    alias_method :attr_header_chunk=, :header_chunk=
    undef_method :header_chunk=
    
    attr_accessor :palette_chunk
    alias_method :attr_palette_chunk, :palette_chunk
    undef_method :palette_chunk
    alias_method :attr_palette_chunk=, :palette_chunk=
    undef_method :palette_chunk=
    
    typesig { [LEDataInputStream] }
    def initialize(input_stream)
      @input_stream = nil
      @read_state = nil
      @header_chunk = nil
      @palette_chunk = nil
      @input_stream = input_stream
      @read_state = PngFileReadState.new
      @header_chunk = nil
    end
    
    typesig { [] }
    def get_ihdr_chunk
      if ((@header_chunk).nil?)
        begin
          chunk = PngChunk.read_next_from_stream(@input_stream)
          if ((chunk).nil?)
            SWT.error(SWT::ERROR_INVALID_IMAGE)
          end
          @header_chunk = chunk
          @header_chunk.validate(@read_state, nil)
        rescue ClassCastException => e
          SWT.error(SWT::ERROR_INVALID_IMAGE)
        end
      end
      return @header_chunk
    end
    
    typesig { [] }
    def read_next_chunk
      if ((@header_chunk).nil?)
        return get_ihdr_chunk
      end
      chunk = PngChunk.read_next_from_stream(@input_stream)
      if ((chunk).nil?)
        SWT.error(SWT::ERROR_INVALID_IMAGE)
      end
      case (chunk.get_chunk_type)
      when PngChunk::CHUNK_tRNS
        (chunk).validate(@read_state, @header_chunk, @palette_chunk)
      when PngChunk::CHUNK_PLTE
        chunk.validate(@read_state, @header_chunk)
        @palette_chunk = chunk
      else
        chunk.validate(@read_state, @header_chunk)
      end
      if (@read_state.attr_read_idat && !((chunk.get_chunk_type).equal?(PngChunk::CHUNK_IDAT)))
        @read_state.attr_read_pixel_data = true
      end
      return chunk
    end
    
    typesig { [] }
    def read_pixel_data
      return @read_state.attr_read_pixel_data
    end
    
    typesig { [] }
    def has_more_chunks
      return !@read_state.attr_read_iend
    end
    
    private
    alias_method :initialize__png_chunk_reader, :initialize
  end
  
end
