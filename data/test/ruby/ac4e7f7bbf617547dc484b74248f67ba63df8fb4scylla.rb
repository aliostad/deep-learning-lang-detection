require 'rubygems'
require 'yaml'
require 'optparse'
require 'ostruct'

require 'scylla/main'
require 'scylla/options'
require 'scylla/spawner'
require 'scylla/generator'


module Scylla
  
end


class Array
  def chunk(number_of_chunks)
    chunks = Array.new
    chunk_size = self.size / number_of_chunks
    remainder = self.size % number_of_chunks
    number_of_chunks.times do |c|
      if c < remainder
        chunks << self[((c*chunk_size)+c),(chunk_size+1)]
      else
        chunks << self[((c*chunk_size)+remainder),chunk_size]
      end
    end
    chunks
  end
  alias / chunk
end