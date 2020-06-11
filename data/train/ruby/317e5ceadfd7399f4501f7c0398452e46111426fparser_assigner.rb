require './paragraph_parser'
require './header_parser'
require './strong_parser'
require './emphasis_parser'
require './unordered_list_parser'
require './ordered_list_parser'
require 'pry'

class ParserAssigner

  def assign_chunk(chunk)
    chunk = outer_tags(chunk)
    chunk = inner_tags(chunk)
  end

  def outer_tags(chunk)
    if chunk[0] == "#"
      head = HeaderParser.new(chunk)
      chunk = head.header_parser
    elsif chunk.start_with?("* ")
      ulist= UnorderedListParser.new(chunk)
      chunk = ulist.unordered_list_parser
    elsif chunk.start_with?("1. ")
      olist = OrderedListParser.new(chunk)
      chunk = olist.ordered_list_parser
    else
      paragraph = ParagraphParser.new(chunk)
      chunk = paragraph.paragraph_parser
    end
  end

  def inner_tags(chunk)
    if chunk.include?("**")
      strong = StrongParser.new(chunk)
      chunk = strong.strong_parser
    elsif chunk.include?("*")
      emphasis = EmphasisParser.new(chunk)
      chunk = emphasis.emphasis_parser
    else
      chunk
    end
  end

end
