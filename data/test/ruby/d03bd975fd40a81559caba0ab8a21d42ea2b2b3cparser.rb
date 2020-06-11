require './header'
require './ordered_list'
require './unordered_list'
require './paragraph'
require './emphasized_and_stronged'

class Parser
  def parsed(text)
    text_in = text
    chunks = break_into_chunks(text_in)
    tagged = parser(chunks)
    back_together_chunks = back_together(tagged)
    EmphasizedAndStronged.new.em_and_strong_tags(back_together_chunks)
  end

  def break_into_chunks(text_in)
    text_in.split("\n\n")
  end

  def parser(chunks)
    chunks.map do |chunk|
      if chunk.start_with?("#")
        Header.new.header_tags(chunk)
      elsif chunk.start_with?("* ")
        UnorderedList.new.unordered_tags(chunk)
      elsif chunk.start_with?("1")
        OrderedList.new.ordered_tags(chunk)
      else
        Paragraph.new.paragraph_tags(chunk)
      end
    end
  end

  def back_together(tagged)
    tagged.join("\n\n")
  end
end
