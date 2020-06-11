require 'openssl'

def chunk_foreach(io, sha, step)
  io.read_elem(:chunk, sha) do |chunk_file|
    sha_control = Digest::SHA1.new
    yield chunk_file
    sha_control << chunk_file
    raise if sha_control.hexdigest != sha
  end
end

def file_foreach_chunk(io, sha)
  io.read_elem(:file, sha) do |file|
    file.each_line do |chunk_sha|
      chunk_sha = chunk_sha.strip
      yield chunk_sha if not chunk_sha.empty?
    end
  end
end

def file_foreach(io, sha, step)
  sha_control = Digest::SHA1.new
  file_foreach_chunk(io, sha) do |chunk_sha|
    chunk_foreach(io, chunk_sha, step) do |buf| 
      yield buf
      sha_control << buf
    end
  end
  raise if sha_control.hexdigest != sha
end

def file_foreach(io, sha, step)
  io.read_elem(:file, sha) do |file|
    sha_control = Digest::SHA1.new
    file.each_line do |chunk_sha|
      chunk_sha = chunk_sha.strip
      if not chunk_sha.empty?
        chunk_foreach(io, chunk_sha, step) do |buf| 
          yield buf
          sha_control << buf
        end
      end
    end
    raise if sha_control.hexdigest != sha
  end
end


def tree_foreach(io, sha)
  #go through each tree entry and check the names
  io.read_elem(:tree, sha) do |tree_file|
    sha_control = Digest::SHA1.new
    r = Regexp.new '(?<is_directory?>\d) (?<mode>\d{3}) (?<sha>\h{40}) (?<filename>.*)'
    tree_file.each_line do |line|
      l = r.match(line)
      yield l if l
      sha_control << line 
    end
    puts "failure: #{sha} != #{sha_control.hexdigest} - raise" if sha_control.hexdigest != sha
  end
end

def root_foreach(io, &block)
  io.list_elem(:root, &block)
end
