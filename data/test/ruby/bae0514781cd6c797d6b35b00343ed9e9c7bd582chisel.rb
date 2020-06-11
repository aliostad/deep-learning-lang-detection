class Chisel

  attr_reader :result

  def initialize
    @result = []
    @counter = 0
  end

  def id_chunks(input)
     @result = input.split("\n\n")
  end

  def header_tags(input)
   chunks = input.split
   count = chunks[0].count("#")
   chunks[0] = ("<h#{count}>")
   chunks.push("</h#{count}>\n\n")
   chunks
  end

  def paragraph_tags(input)
   chunks = input.split
   chunks.unshift("<p>\n ")
   chunks.push("\n</p>")
   chunks
  end

  def proper_spacing(words)
    words.map.each_with_index do |word, index|
     if index == ((words.count) - 1) ||
        index == ((words.count) - 2) ||
        index == 0
      word
     else
      word + " "
     end
    end
  end

  def html_tags(input)
    chunks = input.split("\n")
    chunks.map do |chunk|
      if chunk[0].include?("#")
        proper_spacing(header_tags(chunk))
      else
        proper_spacing(paragraph_tags(chunk))
      end
    end.join
  end

  def emphasis_wraps(input)
    chunk = input.split
    chunk = chunk.map do |word|
      if word[0] == "*"
        word.sub("*", "<em>")
      else
        word
      end
    end

    chunk = chunk.map do |word|
      if word[-1] == "*"
        word.sub("*", "</em>")
      else
        word
      end
    end.join(" ")
  end

  def wraps(input)
    chunks = input.split
    chunks.map  do |chunk|
      if chunk.include?("**")
        strong_wraps(chunk)
      elsif chunk.include?("*")
        emphasis_wraps(chunk)
      else
        chunk
      end
    end.join(" ")
  end

  def strong_wraps(input)
    chunk = input.split
    chunk = chunk.map do |word|
      if word[0..1] == "**"
        word.sub("**", "<strong>")
      else
        word
      end
    end

    chunk = chunk.map do |word|
      if word[-2..-1] == "**"
        word.sub("**", "</strong>")
      else
        word
      end
    end.join(" ")
  end

  def parse(input)
    chunks = input.split("\n\n")
    chunks.map do |chunk|
      html_tags(wraps(chunk))
    end
  end

end

document = '# My Life in Desserts

## Chapter 1: The Beginning

"You just *have* to try the cheesecake," he said. "Ever since it appeared in
**Food & Wine** this place has been packed every night."'

parser = Chisel.new
output = parser.parse(document)
puts output
