class OrderedParser

  def convert(input)
    chunks = input.split("\n")
    stripped = remove_numbers(chunks)
    list = format(stripped)
    return wrap!(list).join
  end

  def remove_numbers(chunks)
    return chunks.map do |chunk|
      remove_junk(chunk)
    end
  end

  def remove_junk(chunk)
    if chunk[0] == "." || array_of_numbers.include?(chunk[0])
      chunk = chunk[(1)..-1]
      remove_junk(chunk)
    else
      return chunk
    end

  end


  def array_of_numbers
    return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  def format(chunks)
    return chunks.map do |chunk|
      chunk = "\t<li>#{chunk}</li>\n"
    end
  end

  def wrap!(list)
    list.unshift("<ol>\n")
    list.push("</ol>")
  end



end
