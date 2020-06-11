class Header


  def header_render(chunk)
    if chunk.start_with?("#####")
      chunk.reverse.chop.chop.chop.chop.chop.prepend(">5h/<").reverse.prepend("<h5>")
    elsif chunk.start_with?("####")
      chunk.reverse.chop.chop.chop.chop.prepend(">4h/<").reverse.prepend("<h4>")
    elsif chunk.start_with?("###")
      chunk.reverse.chop.chop.chop.prepend(">3h/<").reverse.prepend("<h3>")
    elsif chunk.start_with?("##")
      chunk.reverse.chop.chop.prepend(">2h/<").reverse.prepend("<h2>")
    elsif chunk.start_with?("#")
      chunk.reverse.chop.prepend(">1h/<").reverse.prepend("<h1>")
    end
  end

end
