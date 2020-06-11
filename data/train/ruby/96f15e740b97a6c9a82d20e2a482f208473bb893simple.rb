class Simple < Card
  
  after_save :update_references
  
  def render
    content = self.body
    @chunks = []

    %W{TransclusionChunk WikiLinkChunk}.each do |processor_name|
      processor = processor_name.constantize
      content = content.gsub(processor.pattern) do 
        new_chunk = processor.new(self, $~, content)
        @chunks << new_chunk
        new_chunk.unmask
      end
    end
    
    content

  end
  
  def update_references
    render
    
    Reference.delete_all(["parent_id = ?", id])
    
    @chunks.each do |chunk|
        Reference.create! do |ref|
          ref.parent = self
          ref.child = chunk.card
          ref.reference_card_name = chunk.absolute_name
          ref.reference_type = chunk.ref_type
        end
    end    
  end

end