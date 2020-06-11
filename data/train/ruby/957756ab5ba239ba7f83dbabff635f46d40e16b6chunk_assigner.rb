require './lib/header_chunk'
require './lib/paragraph_chunk'
require './lib/unordered_list_chunk'
require './lib/ordered_list_chunk'

class ChunkAssigner
  attr_reader :inputs, :chunks

  def initialize(input)
    @inputs = input
  end

  def assign
    @chunks = inputs.map do |input|
      assign_chunk(input)
    end
  end

  private

  def assign_chunk(input)
    if is_a_header?(input)
      HeaderChunk.new(input)
    elsif is_an_unordered_list?(input)
      UnorderedListChunk.new(input)
    elsif is_an_ordered_list?(input)
      OrderedListChunk.new(input)
    else
      ParagraphChunk.new(input)
    end
  end

  def is_a_header?(chunk)
    chunk.start_with?('#')
  end

  def is_an_ordered_list?(chunk)
    chunk.start_with?('1. ')
  end

  def is_an_unordered_list?(chunk)
    chunk.start_with?('* ')
  end
end
