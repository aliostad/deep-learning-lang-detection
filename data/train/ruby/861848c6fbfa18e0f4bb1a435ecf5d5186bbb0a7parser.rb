def to_html(markdown)
  markdown.split("\n\n").map { |chunk| chunk_to_html(chunk) }.join("\n\n")
end

def chunk_to_html(chunk)
  if chunk.start_with? "#"
    hashes, text = chunk.split(" ", 2)
    "<h#{hashes.length}>#{inner_text(text)}</h#{hashes.length}>"
  else
    "<p>\n#{inner_text(chunk).lines.map { |line| " #{line.chomp}\n" }.join}</p>"
  end
end

def inner_text(text)
  text.gsub("**").each_with_index { |_, i| "<#{"/" if i.odd?}strong>" }
      .gsub("*").each_with_index { |_, i| "<#{"/" if i.odd?}em>" }
      .gsub("&", "&amp;")
      .gsub(/\[([^\]]+)\]\(([^)]+)\)/, '<a href="\2">\1</a>')
end

input_filename = ARGV[0]
output_filename = ARGV[1]
markdown = File.read(input_filename)
html = to_html(markdown)
File.write(output_filename, html)
puts "Converted #{input_filename} (#{markdown.lines.count} lines) to #{output_filename} (#{html.lines.count} lines)"

