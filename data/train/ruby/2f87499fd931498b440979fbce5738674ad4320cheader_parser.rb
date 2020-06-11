require 'pry'
class HeaderParser

  attr_reader :chunk

  def initialize(chunk)
    @chunk = chunk
  end

  def header?
    chunk[0] == "#"
  end

  def first_space
    chunk.index(" ")
  end

  def text_start
    1 + first_space
  end

  def text_body
    chunk[text_start..-1]
  end

  def header_number
    text_start - 1
  end

  def header_parser
    if header?
      "<h#{header_number}>#{text_body.strip}</h#{header_number}>"
    else
      "#{chunk}"
    end
  end
end

if __FILE__ == $0
  header = HeaderParser.new
  p header.header_parser
end
