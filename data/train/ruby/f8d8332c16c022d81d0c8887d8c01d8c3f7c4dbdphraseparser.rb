class PhraseParser 
  def initialize(chars, string)
    @string = string
    @chars = chars
  end

  def parse
    lines = []
    while ! @string.empty?
      lines << get_line
    end
    lines
  end
  
  private

  def get_line
    valid_line = extract_valid_line(get_chunk)
    clean_up_string(valid_line.length)
    valid_line
  end

  def get_chunk
    @string[0,@chars+1]
  end

  def extract_valid_line(chunk)
    return chunk if chunk.length < @chars 
    valid_line = get_valid_chunk(chunk)
    valid_line.rstrip
  end

  def get_valid_chunk(chunk)
    return chunk if is_complete_chunk?(chunk) 
    range = @chars 
    while range > 0 
      valid_line = chunk[0,range] if is_complete_chunk?(chunk[0,range])
      range -= 1 
      break if valid_line
    end
    valid_line
  end

  def is_complete_chunk?(chunk)
    return true if chunk.end_with?(" ")
    false
  end

  def clean_up_string(spaces)
    @string[0,spaces] = ""
    @string.lstrip!
  end
end

