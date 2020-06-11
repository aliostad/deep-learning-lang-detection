module PatchHelper
  class << self
    HEADER_REGEX = /^@@ -(\d+)(,\d+)? \+(\d+)(,\d+)? @@.*$/

    def build_patch(patch)
      return [] unless patch
      result, chunk = [], {}
      s1 = s2 = 0
      patch.split("\n").each_with_index do |line, index|
        if (parts = line.match(HEADER_REGEX)).present?
          result << chunk if chunk.present?
          chunk = init_chunk(line)
          s2 = parts[1].to_i
          s1 = parts[3].to_i
        else
          if line[0] == '+'
            chunk['+'][s1] = [line, index, true]
            s1 += 1
          elsif line[0] == '-'
            chunk['-'][s2] = [line, index, true]
            s2 += 1
          else
            chunk['+'][s1] = [line, index]
            chunk['-'][s2] = [line, index]
            s1 += 1
            s2 += 1
          end
        end
      end
      result << chunk
    end

    def init_chunk(line)
      { '+' => {}, '-' => {}, 'header' => line }
    end
  end
end
