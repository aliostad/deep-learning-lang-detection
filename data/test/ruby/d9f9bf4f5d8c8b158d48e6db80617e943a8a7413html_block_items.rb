
class HtmlBlockItems
  attr_accessor :markdown

  def initialize(markdown)
    @markdown = markdown
  end

  def process_block_items
    generate_unordered_list
    generate_ordered_list
    generate_paragraphs
  end

  def generate_unordered_list
    @markdown = get_chunks.map do |chunk|
      if chunk.match(/^\* (.*)/).nil? || chunk.empty?
        chunk
      else
        chunk = "<ul>" + chunk.gsub(/^\* (.*)/, "    <li>\\1</li>") + "\n  </ul>"
      end
      chunk
    end.join("\n\n")
  end

  def generate_ordered_list
    @markdown = get_chunks.map do |chunk|
      if chunk.match(/^\d+\. (.*)/).nil? || chunk.empty?
        chunk
      else
        chunk = "<ol>\n" + chunk.gsub(/^\d+\. (.*)/, "    <li>\\1</li>") + "\n  </ol>"
      end
    end.join("\n\n")
  end

  def generate_paragraphs
    @markdown = get_chunks.map do |chunk|
      if header?(chunk) || chunk.empty?
        chunk
      else
        "<p>\n  #{chunk}\n</p>\n"
      end
    end.join("\n\n")
  end

  private

  def get_chunks
    markdown.split("\n\n")
  end

  def header?(chunk)
    chunk[0] == "#"
  end

end
