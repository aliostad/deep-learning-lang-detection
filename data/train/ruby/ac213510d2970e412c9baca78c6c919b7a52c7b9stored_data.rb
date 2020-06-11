require 'open-uri'
require 'dalli'

class StoredData
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def client
    @client ||= Dalli::Client.new('localhost:11211')
  end

  def get
    if data = get_
      data
    else
      puts 'talking to web'
      data = open(self.url).read
      set_(data)
      data
    end
  end

private

  def read_size(chunk)
    return nil unless chunk
    size = chunk[-4..-1].to_i
    chunk[-4..-1] = ""
    size
  end

  def write_size(chunk, size)
    chunk << size.to_s.rjust(4, '0')
  end

  def append_size(chunks)
    write_size(chunks.first, chunks.size)
    chunks
  end

  def chunk_key(n)
    "#{url}#{n}"
  end

  def get_chunk(n)
    chunk = client.get(chunk_key(n))
    size = n == 0 ? read_size(chunk) : nil
    {
      chunk: chunk,
      size: size
    }
  end

  def get_
    size = 1
    n = 0
    chunks = []
    while n < size
      h = get_chunk(n)
      size = h[:size] if h[:size]
      chunks << h[:chunk]
      return nil unless h[:chunk]
      n += 1
    end
    chunks.join
  end

  def set_(data)
    size = append_size(chunks_for(data)).each_with_index.map do |chunk, n|
      client.set(chunk_key(n), chunk)
    end.size
  end

  def chunks_for(data)
    data.chars.each_slice(100000).map(&:join)
  end
end
