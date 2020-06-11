module Chunks
  class PageRepository
    def find(id)
      Chunks::Page.find(id)
    end
    
    def update(page, attrs)
      attrs = attrs.with_indifferent_access
      update_chunks(page, attrs.delete(:chunks_attributes)) if attrs[:chunks_attributes]
      page.attributes = attrs
      page.valid? && Chunks::Page.transaction { page.save && page.chunks.map(&:save) }
    end
    
    
    private
    
    def update_chunks(page, chunks_attrs)
      existing_chunks = page.chunks
      chunks_attrs.values.each do |attrs|
        if Boolean.parse(attrs.delete(:_destroy))
          if attrs[:id]
              chunk = acquire_chunk(page, existing_chunks, attrs)
              page.remove_chunk(chunk) 
          end
        else
          chunk = acquire_chunk(page, existing_chunks, attrs)
          if Boolean.parse(attrs.delete(:_unshare))
            chunk = chunk.usage_context.unshare
          end
          update_chunk(chunk, attrs)
        end
      end
      page.chunks_order_has_changed!
    end
    
    def update_chunk(chunk, attrs)
      if chunk.shared?
        chunk.attributes = attrs.slice(:container_key, :position)
      else
        chunk.attributes = attrs.except(:id, :type)
      end
    end
    
    def acquire_chunk(page, existing_chunks, attrs)
      if attrs[:id]
        acquire_existing_chunk(existing_chunks, attrs) || include_shared_chunk(page, attrs)
      else
        add_new_chunk(page, attrs)
      end
    end
    
    def acquire_existing_chunk(existing_chunks, attrs)
      chunk = existing_chunks.find { |c| c.id == attrs[:id].to_i }
      existing_chunks.delete_first_occurance(chunk)
    end
    
    def include_shared_chunk(page, attrs)
      chunk = Chunks::Chunk.find(attrs[:id])
      page.add_chunk(chunk, attrs[:container_key], attrs[:position])
      chunk
    end
    
    def add_new_chunk(page, attrs)
      chunk = attrs[:type].to_class.new
      page.add_chunk(chunk, attrs[:container_key], attrs[:position])
      chunk
    end
  end
end