
$LOAD_PATH << './lib'
require 'welo'
require 'json'

class Foo
  include Welo::Resource
  perspective :default, [:object_id]
end

class Chunk
  include Welo::Resource
  perspective :default, [:index, :data, :chunk, :foos]
  relationship :foos, :Foo, [:many]
  relationship :chunk, :Chunk, [:one]
  embedding :chunk, :default
  embedding :foos, :default
  attr_reader :index, :data, :chunk, :foos
  def initialize(index, chunk=nil)
    @index = index
    @data = random_garbage
    @chunk = chunk
    @foos = []
  end

  def random_garbage
    (1 .. 10).map{|i| rand(256)}.pack('C*').unpack('H2'*10).join
  end
end

chunks = (1 .. 3).inject(nil){|c,idx| Chunk.new(idx,c)}
2.times{ chunks.foos << Foo.new }

p chunks.structure_pairs(:default)
p chunks.to_serialized_hash(:default)
puts chunks.to_json(:default)

