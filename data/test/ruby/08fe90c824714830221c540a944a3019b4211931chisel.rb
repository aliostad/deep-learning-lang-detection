require '../lib/header'
require '../lib/emphasis'
require '../lib/strong_tag'
require '../lib/list'
require '../lib/chunk'
require '../lib/paragraph'


class Chisel

  def linesplit
    chunks = Chunk.new.file_intake(file)
  end

  def grandfather_parse(text_file)
    chunks = linesplit(text_file)
    case chunks
      when header?
        to_header
      when unordered_list?
        to_unordered_list
      when ordered_list?
        to_ordered_list
      when strong_tag?
        to_strong_tag
      when emphasis?
        to_emphasis
      else
        to_paragraph
    end
  end

  def header?
    chunk.start_with?("#")
  end

  def to_header
    Header.new.header_render(chunk)
  end


  def unordered_list?
    chunk.start_with?("* ")
  end

  def to_unordered_list
    Line.new.unordered_list_render(chunk)
  end

  def ordered_list?
    chunk.start_with?(1.to_s)
  end

  def to_ordered_list
    Line.new.ordered_list_render(chunk)
  end

  def strong_tag?
    chunk.include("**")
  end

  def to_strong_tag
    StrongTag.new.strong_tag_render(chunk)
  end

  def emphasis?
    chunk.include("*")
  end

  def to_emphasis
    Emphasis.new.emphasis_render(chunk)
  end

  def paragraph?
    chunk.include("#") || chunk.include("* ") || chunk.include(1.to_s)
  end

  def to_paragraph
    Paragraph.new.paragraph_render(chunk)
  end


end
