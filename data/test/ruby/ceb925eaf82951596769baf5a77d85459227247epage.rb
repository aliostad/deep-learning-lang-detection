module Chunks
  class Page < ActiveRecord::Base
    has_many :chunk_usages, order: :position, autosave: true
    has_many :chunks, through: :chunk_usages
    private :chunk_usages # External users should always use #chunks.
    accepts_nested_attributes_for :chunks
    
    validates_associated :chunks, message: "are invalid (see below)"
    validates_presence_of :title, :template
    
    def template
      template_class = read_attribute(:template)
      template_class.is_a?(String) ? template_class.to_class : template_class
    end
    
    def containers
      @containers ||= template ? template.build_containers(self) : []
    end
    
    def container(key)
      containers.find { |c| c.key == key } || raise(Chunks::Error.new("#{template.title} pages do not have a container called '#{key}'"))
    end
    
    def chunks
      chunk_usages.map do |usage|
        chunk = usage.chunk
        chunk.usage_context = usage
        chunk
      end
    end
    
    def add_chunk(chunk, container_key, position=-1)
      usage = chunk_usages.build(chunk: chunk, container_key: container_key, position: position)
      chunk.usage_context = usage
    end
    
    def remove_chunk(chunk)
      chunk.usage_context.destroy
      chunk_usages.delete(chunk.usage_context)
    end
    
    def chunks_order_has_changed!
      chunk_usages.sort_by!(&:position)
    end
  end
end