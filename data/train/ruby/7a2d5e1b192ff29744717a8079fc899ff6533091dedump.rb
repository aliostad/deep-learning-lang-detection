require '~/Data-Mining/lib/setup.rb'
require 'yaml'

@db = DB.new 'test'

@db['chunk_sets'].find({'chunks' => { '$type' => 2 } }).each do |chunk_set|
  relations = {}
  YAML::load(chunk_set['relations']).each{|k, v| relations[k.to_s] = v}
  chunks = YAML::load(chunk_set['chunks'])
  relevant_chunks = [];
  chunks.each do |chunk| 
    if !relevant_chunks.map{|c| c[:text]}.include? chunk[:text]
      relevant_chunks << chunk
    end
  end

  @db['chunk_sets'].update(chunk_set, { "$set" => { "relations" => relations, "chunks" => relevant_chunks } })
end
