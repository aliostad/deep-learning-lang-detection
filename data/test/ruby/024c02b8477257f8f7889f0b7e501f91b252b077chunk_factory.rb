FactoryGirl.define do
  factory :chunk, class: Chunks::BuiltIn::Text do |chunk|
  chunk.title   { "Title From FactoryGirl" }    
  chunk.content { "This is a Text Chunk" }
  end

  factory(:text_chunk, parent: :chunk, class: Chunks::BuiltIn::Text) {}
  factory(:html_chunk, parent: :chunk, class: Chunks::BuiltIn::Html) {}
  factory(:markdown_chunk, parent: :chunk, class: Chunks::BuiltIn::MarkdownWiki) {}

  factory :chunk_usage, class: Chunks::ChunkUsage do |usage|
    usage.chunk         { FactoryGirl.create(:chunk) }
    usage.page          { FactoryGirl.create(:page) }
    usage.container_key { :content }
  end

  sequence(:shared_count)
  factory :shared_chunk, class: Chunks::SharedChunk do |shared|
    shared.chunk  { FactoryGirl.create(:chunk) }
    shared.name   { "FactoryGirl shared ##{generate(:shared_count)}" }
  end
end