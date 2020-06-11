class HeaderRenderer
  def handles?(chunk)
    chunk.start_with?("#") &&
      first_character_after_hashes(chunk) == " "
  end

  def transform(chunk)
    "<#{header_tag(chunk)}>" + header_content(chunk) + "</#{header_tag(chunk)}>\n\n"
  end

  private

  def number_of_hashes(chunk)
    chunk.chars.take_while { |char| char == '#' }.length
  end

  def characters_to_drop(chunk)
    number_of_hashes(chunk) + 1
  end

  def header_tag(chunk)
    "h#{number_of_hashes(chunk)}"
  end

  def header_content(chunk)
    chunk[characters_to_drop(chunk)..-1]
  end

  def first_character_after_hashes(chunk)
    chunk.chars.drop_while { |char| char == '#' }.first
  end
end