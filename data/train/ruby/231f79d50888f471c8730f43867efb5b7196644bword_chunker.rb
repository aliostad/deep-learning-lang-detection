# encoding: utf-8

class WordChunker

  def initialize(str, limit)
    @string = str
    @limit = limit
  end

  def chunk
    @stack = []
    @current_chunk = ""
    words.each do |word|
      if add_this_word_to_current_chunk?(word)
        @current_chunk << ( @current_chunk.empty? ? "" : " " ) + word
      else
        add_to_chunk(@current_chunk)
        @current_chunk = make_word_addable(word)
      end
    end
    add_to_chunk(@current_chunk)
  end

  def self.chunk str, limit
    chunker = self.new(str, limit)
    chunker.chunk
  end

  private

  def add_this_word_to_current_chunk?(word)
    @current_chunk.length + word.length + 1 <= @limit
  end

  def add_to_chunk(chunk)
    if !chunk.empty?
      @stack << chunk
    else
      @stack
    end
  end


  def words
    @string.split(/\s+/)
  end

  def make_word_addable (word)
    if word.length  <= @limit
      word
    else
      word[0..@limit-2] + "…"
    end
  end
end


class String
  def split_by_chunk_size(limit)
    chunker = WordChunker.new(self, limit)
    chunker.chunk
  end
end
