require './lib/chunker'
require './lib/emphasis_renderer'
require './lib/strong_renderer'
require './lib/unordered_list_renderer'
require './lib/ordered_list_renderer'
require './lib/link_renderer'
require './lib/header_renderer'
require './lib/paragraph_renderer'

class Renderer
  def self.render(markdown)
    chunks = Chunker.chunk(markdown)
    parsed_chunks = self.parse(chunks)
    parsed_chunks.join
  end

  # TODO: Find better ways to handle edge cases
  def self.parse(chunks)
    chunks.map do |chunk|
      chunk = self.parse_formatting(chunk)
      chunk = self.parse_strong(chunk)
      chunk = self.parse_emphasize(chunk)
      chunk = self.parse_links(chunk)
      self.parse_headers_and_paragraphs(chunk)
    end
  end

  def self.parse_formatting(chunk)
    if chunk.start_with?("*")
      chunk = UnorderedListRenderer.render(chunk)
    elsif chunk.start_with?("1.")
      chunk = OrderedListRenderer.render(chunk)
    end

    chunk
  end

  def self.parse_strong(chunk)
    strong_symbol_count = chunk.count("**")
    if strong_symbol_count > 0 && strong_symbol_count.even?
      chunk = StrongRenderer.render(chunk)
    end

    chunk
  end

  def self.parse_emphasize(chunk)
    emphasize_symbol_count = chunk.count("*")
    if emphasize_symbol_count > 0 && emphasize_symbol_count.even?
      chunk = EmphasisRenderer.render(chunk)
    end

    chunk
  end

  def self.parse_links(chunk)
    link_open_symbol_count = chunk.count("[")
    link_close_symbol_count = chunk.count("]")
    if link_open_symbol_count > 0 && (link_open_symbol_count == link_close_symbol_count)
      chunk = LinkRenderer.render(chunk)
    end

    chunk
  end

  def self.parse_headers_and_paragraphs(chunk)
    if chunk.start_with?("#")
      chunk = HeaderRenderer.render(chunk)
    elsif !chunk.start_with?("<ul>") && !chunk.start_with?("<ol>")
      chunk = ParagraphRenderer.render(chunk)
    end

    chunk
  end
end

