

class Chiseler

  def initialize(chunk)
    @chunk = chunk
    @new_chunk = []
  end

  def header_paragraph
    @chunk.map do |str|
      if str[0] == "#"
        @new_chunk << header_formatter(str)
      elsif str[0..1] == "* "
        @new_chunk << unordered_list_formatter(str)
      elsif str[0].to_i > 0
        @new_chunk << ordered_list_formatter(str)
      else
        @new_chunk << paragraph_formatter(str)
      end
    end
    strings = @new_chunk.join("\n\n")
    strong_formatter(strings)
    em_formatter(strings)
    link_formatter(strings)
    return strings
  end

  def header_formatter(str)
    num = str.scan(/#/).count
    header = "<h#{num}>#{str.delete! "#"}</h#{num}>"
    return header
  end

  def paragraph_formatter(str)
     return "<p>#{str}</p>"
  end

  def ordered_list_formatter(str)
    list_chunk = str.split("\n")
    list_chunk.map do |str|
      str.sub!(str[0..2], "<li>")<<"</li>"
    end
    return "<ol>\n#{list_chunk.join("\n")}\n</ol>"
  end

  def unordered_list_formatter(str)
    list_chunk = str.split("\n")
    list_chunk.map do |str|
      str.sub!("* ", "<li>")<<"</li>"
    end
    return "<ul>\n#{list_chunk.join("\n")}\n</ul>"
  end

  def strong_formatter(str)
    while str.include?("**")
      str.sub!("**", "<strong>")
      str.sub!("**", "</strong>")
    end
    return str
  end

  def em_formatter(str)
    while str.include?("*")
      str.sub!("*", "<em>")
      str.sub!("*", "</em>")
    end
    return str
  end

  def link_formatter(strings)
    if strings.include?("[")
      text = strings[(strings.index("[")+1)..(strings.index("]")-1)]
      link = strings[(strings.index("(")+1)..(strings.index(")")-1)]
      strings.sub!("(", "")
      strings.sub!(")", "")
      strings.sub("[", "")
      strings.sub!("]", "</a>")
      strings.sub!(text, "")
      strings.sub!(link, "")
      strings.sub!("[", "<a href=\"#{link}\">#{text}")
      return strings
    else
      return strings
    end
  end

end

