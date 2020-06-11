require './lib/chunker'
require './lib/chunk_assigner'
require './lib/strong_chunk'
require './lib/em_chunk'
require './lib/link_chunk'

class Renderer

  def initialize(markdown)
    @markdown = markdown
  end

  def render
    chunked = chunk(@markdown)
    assigned_chunks = assign(chunked)
    html = convert_chunks_to_html(assigned_chunks)

    inline_html = convert_inline_chunks_to_html(html)
    inline_html.join
  end

  def chunk(input)
    Chunker.new(input).chunks
  end

  def assign(chunks)
    ChunkAssigner.new(chunks).assign
  end

  def convert_to_html(chunk)
    chunk.render
  end

  private


  def convert_inline_chunks_to_html(html)
    html.map do |chunk|
      converted_strongs = StrongChunk.new(chunk).render

      converted_ems = EmChunk.new(converted_strongs).render

      converted_links = LinkChunk.new(converted_ems).render
      converted_links
    end
  end

  def convert_chunks_to_html(assigned_chunks)
    assigned_chunks.map do |chunk|
      convert_to_html(chunk)
    end
  end
end
