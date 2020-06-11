require_relative '../lib/heading.rb'
require_relative '../lib/paragraph.rb'
require_relative '../lib/unordered_list.rb'
require_relative '../lib/ordered_list.rb'
require_relative '../lib/emphasis.rb'
require_relative '../lib/strongtag.rb'
require_relative '../lib/chunkify.rb'
require_relative '../lib/chunk_grouper.rb'

class Chisel
  attr_reader :document
  def parse(document)
    chunkify = Chunkify.new
    chunk_grouper = ChunkGrouper.new
    heading = Heading.new
    paragraph = Paragraph.new
    unordered_list = UnorderedList.new
    emphasis = Emphasis.new
    strongtag = StrongTag.new
    document = chunkify.divide(document)
    grouped = chunk_grouper.group(document)

    parsed_doc = document.inject([]) do |parsed, chunk|
      if grouped[chunk] == :heading
        parsed << heading.parse(chunk)
      elsif grouped[chunk] == :paragraph
        parsed << paragraph.parse(chunk)
      elsif grouped[chunk] == :unordered_list
        parsed << unordered_list.parse(chunk)
      end
    end

    parsed_doc.each do |chunk|
      chunk = emphasis.parse(chunk)
      chunk = strongtag.parse(chunk)
      puts "#{chunk}"
    end
  end
end
