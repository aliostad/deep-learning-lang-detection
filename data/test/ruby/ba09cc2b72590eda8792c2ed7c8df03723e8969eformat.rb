require './lib/chunk_parser'
require './lib/emphasis'
require './lib/links'


class Formatter

  def format(chunks, file_machine, output)
    emphasiser = Emphasiser.new
    parser = ChunkParser.new
    linker = Linker.new
    chunks.each do |chunk|
      finished = change_type(chunk, output, emphasiser, parser, linker)
      file_machine.write(output, finished)
    end
  end

  def change_type(chunk, output, emphasiser, parser, linker)
    formatted = parser.sort(chunk)
    emphasized = emphasiser.convert(formatted)
    return linker.linkify(emphasized)
  end

end
