class Mentions
  REGEXEN = {}
  REGEXEN[:valid_mention_preceding_chars] = /(?:[^a-zA-Z0-9_!#\$%&*@]|^|RT:?)/o
  REGEXEN[:at_signs] = /[@]/
  REGEXEN[:valid_mention_or_list] = /
    (#{REGEXEN[:valid_mention_preceding_chars]})  # $1: Preceeding character
    (#{REGEXEN[:at_signs]})                       # $2: At mark
    ([a-zA-Z0-9_]{1,20})                          # $3: Screen name
    (\/[a-zA-Z][a-zA-Z0-9_\-]{0,24})?             # $4: List (optional)
  /ox
  
  REGEXEN[:end_mention_match] = /\A(?:#{REGEXEN[:at_signs]}|:\/\/)/o
  
  DEFAULT_HIGHLIGHT_TAG = 'b'
  
  def self.wrap(text, options = {})
    hits = get(text).map {|h| h[:indices]}
    if hits.empty?
      return text
    end

    tag_name = options[:tag] || DEFAULT_HIGHLIGHT_TAG
    tags = ["<" + tag_name + ">", "</" + tag_name + ">"]

    chunks = text.split(/[<>]/)

    result = []
    chunk_index, chunk = 0, chunks[0]
    chunk_chars = chunk.to_s.to_char_a
    prev_chunks_len = 0
    chunk_cursor = 0
    start_in_chunk = false
    for hit, index in hits.flatten.each_with_index do
      tag = tags[index % 2]

      placed = false
      until chunk.nil? || hit < prev_chunks_len + chunk.length do
        result << chunk_chars[chunk_cursor..-1]
        if start_in_chunk && hit == prev_chunks_len + chunk_chars.length
          result << tag
          placed = true
        end

        # correctly handle highlights that end on the final character.
        if tag_text = chunks[chunk_index+1]
          result << "<#{tag_text}>"
        end

        prev_chunks_len += chunk_chars.length
        chunk_cursor = 0
        chunk_index += 2
        chunk = chunks[chunk_index]
        chunk_chars = chunk.to_s.to_char_a
        start_in_chunk = false
      end

      if !placed && !chunk.nil?
        hit_spot = hit - prev_chunks_len
        result << chunk_chars[chunk_cursor...hit_spot] << tag
        chunk_cursor = hit_spot
        if index % 2 == 0
          start_in_chunk = true
        else
          start_in_chunk = false
        end
        placed = true
      end

      # ultimate fallback, hits that run off the end get a closing tag
      if !placed
        result << tag
      end
    end

    if chunk
      if chunk_cursor < chunk_chars.length
        result << chunk_chars[chunk_cursor..-1]
      end
      (chunk_index+1).upto(chunks.length-1).each do |index|
        result << (index.even? ? chunks[index] : "<#{chunks[index]}>")
      end
    end

    result.flatten.join
  end
  
  def self.get(text) # :yields: username, list_slug, start, end
    return [] unless text =~ /[@]/

    possible_entries = []
    text.to_s.scan(REGEXEN[:valid_mention_or_list]) do |before, at, fingerprint, list_slug|
      match_data = $~
      after = $'
      unless after =~ REGEXEN[:end_mention_match]
        start_position = match_data.char_begin(3) - 1
        end_position = match_data.char_end(list_slug.nil? ? 3 : 4)
        possible_entries << {
          :fingerprint => fingerprint,
          :list_slug => list_slug || "",
          :indices => [start_position, end_position]
        }
      end
    end

    if block_given?
      possible_entries.each do |mention|
        yield mention[:fingerprint], mention[:list_slug], mention[:indices].first, mention[:indices].last
      end
    end
    
    possible_entries
  end
end

class String
  def to_char_a
    @to_char_a ||= if chars.kind_of?(Enumerable)
      chars.to_a
    else
      char_array = []
      0.upto(char_length - 1) { |i| char_array << [chars.slice(i)].pack('U') }
      char_array
    end
  end
end

class MatchData
  def char_begin(n)
    if string.respond_to? :codepoints
      self.begin(n)
    else
      string[0, self.begin(n)].char_length
    end
  end

  def char_end(n)
    if string.respond_to? :codepoints
      self.end(n)
    else
      string[0, self.end(n)].char_length
    end
  end
end