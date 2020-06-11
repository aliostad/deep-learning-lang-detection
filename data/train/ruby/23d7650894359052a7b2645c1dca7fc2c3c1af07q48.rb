=begin

48. 名詞から根へのパスの抽出

=end

require_relative 'q41'

class Object
  def iterate
    Enumerator.new do |yielder|
      v = self
      loop do
        yielder << v
        v = yield(v)
      end
    end
  end

end

# ------------------------------------------------
def next_chunk(chunk, env)
  if chunk.dst==-1
    nil
  else
    env[chunk.dst]
  end
end

def path_to_root(chunk, env)
  chunk.iterate { |c| next_chunk(c, env) }.take_while { |c| c!=nil }
end

def render_path(path)
  path.map { |c| c.unpunctuated_text }.join(' -> ')
end

Noun_p = proc { |m| m.pos == '名詞' }

def main
  doc = load_document

  paths = doc.flat_map do |sent|
    sent.select { |c| c.morphs.any?(&Noun_p) }
      .map { |chunk| path_to_root(chunk, sent) }
  end

  paths.each do |p|
    puts render_path(p)
  end
end

main if __FILE__ == $0
