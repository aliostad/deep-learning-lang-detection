class Linker

  def has_both_signs?(chunk)
    characters = chunk.chars
    if characters.include?("(") && characters.include?(")") && characters.include?("[") && characters.include?("]")
      return true
    else
      return false
    end
  end

  def linkify(chunk)
    if has_both_signs?(chunk)
      open = chunk.index("[")
      close = chunk.index(")")
      formatted = format(chunk[open..close])
      chunk = chunk[0..open-1] + formatted +  chunk[close+1..-1]
      linkify(chunk)
    else
      return chunk
    end
  end


  def format(link)
    if get_third(link) != nil
      return "<a href=\"#{get_second(link)}\" title=#{get_third(link)}>#{get_first(link)}</a>"
    else
      return "<a href=\"#{get_second(link)}\">#{get_first(link)}</a>"
    end

  end

  def get_second(link)
    open = link.index("(")
    close = link.rindex("/")
    return link[open + 1..close]

  end

  def get_first(link)
    open = link.index("[")
    close = link.index("]")
    return link[open + 1..close - 1]
  end

  def get_third(link)
    open = link.index("\"")
    close = link.rindex("\"")
    if open == nil || close == nil
      return nil
    else
      return link[open..close]
    end
  end

end
