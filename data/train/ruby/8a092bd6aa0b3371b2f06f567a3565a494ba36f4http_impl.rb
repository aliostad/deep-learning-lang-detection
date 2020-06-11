require 'ostruct'

### Base class for HTTP implementations
class HttpImpl
  attr_reader :name
  attr_reader :description
  attr_reader :available

  def initialize(filename, description, available)
    @name = File.basename(filename, ".rb")
    @description = description
    @available = available

    register()
  end

  ### Sends an HTTP GET to the specified URL
  def get(uri)
    #Subclasses must implement the method get_impl, which yields each chunk of the body
    stats = OpenStruct.new({:bytes => 0, :chunk_count => 0, :min_chunk_size => 0, :max_chunk_size => 0, :mean_chunk_size => 0})

    get_impl(uri) do |chunk|
      stats.bytes += chunk.length
      stats.chunk_count += 1
      stats.min_chunk_size = chunk.length if stats.min_chunk_size == 0 || stats.min_chunk_size > chunk.length
      stats.max_chunk_size = chunk.length if stats.max_chunk_size == 0 || stats.max_chunk_size < chunk.length
    end   
    
    stats.mean_chunk_size = (stats.bytes / stats.chunk_count)

    stats
  end

  ### Wrapper around protected get_impl for calling from testimpl.rb
  def test_get_impl(uri, &block)
      chunks = 0
      get_impl(uri) do |body|
        block.call(body)
        chunks += 1
      end

      chunks
  end

  private

  def register
    HttpImpls::register_impl(self)
  end

end

