class DiffInterpreter
  def initialize(comments)
    @comments=comments
  end

  def to_model(diff)
    diff.elements.map { |file| make_file file}
  end

  private
  def make_file(file)
    TextFile.new(file.name, make_chunks(file.elements.drop 3))
  end

  def make_chunks(chunks)
    chunks.map { |chunk|
      Chunk.new(make_lines(chunk),
                chunk.old_begin,
                chunk.old_end,
                chunk.new_begin,
                chunk.new_end)
    }
  end

  def make_lines(chunk)
    line_old=chunk.old_begin
    line_new=chunk.new_begin
    chunk.elements.map { |parsed_line|
      type = LineType.new(parsed_line.type)
      new_no = type.new_no(line_new)
      old_no = type.old_no(line_old)
      line_new+=1 if type.inNew
      line_old+=1 if type.inOld

      Line.new(
          parsed_line.content,
          type,
          new_no,
          old_no,
          @comments.find { |c| c.new_no==new_no && c.old_no==old_no } )
    }
  end
end