@work = Work.find_by_title("Selected Aphorisms")

def save_chunk(section, text)
  p "save #{section}"
   chunk = Chunk.new(:title => section, :body => text, :work => @work)
   chunk.save!
end

p "create The Antichrist"
text = section = ""
File.open('script/files/aphorisms.txt', 'r').each do |line|
  if match = line.strip!.match(/(\d+)\.\z/)
    if !text.strip.empty?
      save_chunk(section, text)
    end
    text = ""
    section = "Section #{match[1]}"
    next
  end
  if !section.empty?
    if !line.empty?
      text += " #{line}"
    else
      text += "\n\n"
    end
  end
end
save_chunk(section, text)
