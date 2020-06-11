require 'json'
require 'net/http'

class FlyingV
  def self.get(key)
    res = Net::HTTP.get(URI.parse("http://api.openkeyval.org/#{key}"))
    JSON.parse(res)
  rescue JSON::ParserError
    res
  end
  
  def self.post(key, value)
    value = value.to_json if(value.is_a?(Hash) or value.is_a?(Array))
    Net::HTTP.post_form(URI.parse("http://api.openkeyval.org/#{key}"), {'data' => value})
  end
  
  def self.post_file(key, path)
    size = File.size(path)
    content = File.open(path).read
    original_name = File.basename(path)
    self.post(key, {"content" => content, "original_name" => original_name})
  end
  
  def self.put_file(key, path)
    size = File.size(path)
    chunks = (size / 2048.0).ceil
    return self.post_file(key, path) if(chunks == 1)
    original_name = File.basename(path)
    content = File.open(path).read
    next_chunk_key = nil
    chunk_keys = []
    sanity_check = ""
    chunks.downto(1) do |i|
      k = "#{key}_chunk_#{i}"
      chunk_keys << k
      if(i == chunks)
        chunk_content = content[((i-1)*2048)..-1]
      else
        chunk_content = content[((i-1)*2048)..(i*2048-1)]
      end
      sanity_check += chunk_content
      puts "storing key: #{k}, content size #{chunk_content.size}"
      self.post(k, {
        "content" => chunk_content, 
        "master_key" => key, 
        "chunk" => i, 
        "next" => next_chunk_key})
      next_chunk_key = k
    end
    puts "sanity check size = #{sanity_check.size}, content size = #{content.size}"
    self.post(key, {
      "original_name" => original_name,
      "chunk_keys" => chunk_keys.reverse})  
  end
  
  def self.get_file(key, target_path)
    master = self.get(key)
    f = File.open(target_path, "w")
    master["chunk_keys"].each do |chunk_key|
      chunk = self.get(chunk_key)
      puts "master key sanity check PASSED! -- getting #{chunk_key}" if(chunk["master_key"] == key)
      f.write(chunk["content"])
    end
    f.close
    puts "complete"
  end
end