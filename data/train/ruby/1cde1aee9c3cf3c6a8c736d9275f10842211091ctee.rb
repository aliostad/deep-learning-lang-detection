require 'digest/sha1'
require 'digest/sha2'

module Enumerable
  module Tee
    def tee(*procs)
      procs.map { |p| p.call(each) }
    end
  end
end

class IO
  module Chunkable
    CHUNK_SIZE = 1024

    def chunks(chunk_size = nil)
      chunk_size ||= CHUNK_SIZE

      Enumerator.new { |y| y << read(chunk_size) until eof? }
    end

    def each_chunk(chunk_size = nil)
      return chunks.each unless block_given?

      chunks.each { |*args| yield(*args) }
    end
  end

  module Digestable
    def digest_with(digest, chunk_size = nil)
      chunks(chunk_size).each { |chunk| digest << chunk }

      digest
    end

    def sha256(chunk_size = nil)
      digest_with(Digest::SHA2.new(256), chunk_size)
    end
  end

  module Tee
    def fiber_tee(*procs)
      ios = procs.map { |proc| FiberChunkedIO.new(&proc) }

      chunks.each do |chunk|
        ios.each do |io|
          io.write chunk
        end
      end
      ios.each { |io| io.close }

      ios.map { |io| io.result }
    end
    alias_method :tee, :fiber_tee
  end
end

class FiberChunkedIO
  def initialize(chunk_size = 1024, &block)
    @chunk_size = chunk_size
    @chunks = []
    @eof = false
    @fiber = Fiber.new do
      @result = block.call self
    end
    @fiber.resume
  end

  # Being a stream, it behaves like IO#eof? and blocks until the other end
  # sends some data or closes it.
  def eof?
    Fiber.yield

    @eof
  end

  def close
    @eof = true
    @fiber.resume
  end

  attr_reader :result

  def write(chunk)
    if chunk.size > @chunk_size
      raise ArgumentError.new('chunk size mismatch: ' <<
                              "expected #{@chunk_size}, got #{chunk.size}")
    end

    @chunks << chunk
    @eof = false
    @fiber.resume

    chunk.size
  end

  def read(chunk_size)
    unless chunk_size == @chunk_size
      raise ArgumentError.new('chunk size mismatch:' <<
                              " expected #{@chunk_size}, got #{chunk_size}")
    end

    @chunks.shift
  end

  include IO::Chunkable
end
