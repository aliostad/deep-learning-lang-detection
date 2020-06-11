class Atbash

  def self.encode(text)
    self.new(text).encode
  end

  attr_reader :text

  def initialize(text)
    @text = text
  end

  def encode
    chunks.map {|chunk| encode_chunk(chunk) }.join(' ')
  end

private

  def chunks
    chars.each_slice(CHUNK_SIZE)
  end

  def chars
    text.gsub(/\W+/, '').downcase.chars
  end

  def encode_chunk(chunk)
    chunk.map {|char| CIPHER_KEY.fetch(char, char) }.join
  end

  LETTERS = ('a'..'z').to_a
  CIPHER_KEY = Hash[LETTERS.zip(LETTERS.reverse)]
  CHUNK_SIZE = 5
end
