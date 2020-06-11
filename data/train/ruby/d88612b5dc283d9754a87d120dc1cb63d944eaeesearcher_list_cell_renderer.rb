class Rtgrep::SearcherListCellRenderer < RubyCurses::ListCellRenderer
  def repaint graphic, r=@row,c=@col, row_index=-1,value=@text, focussed=false, selected=false
    if focussed
      offset = 236
      attr_offset = Ncurses::A_NORMAL
    else
      offset = 0
      attr_offset = Ncurses::A_NORMAL
    end

    chunk_line = nil

    if value[1] == Rtgrep::FILE_MARKER
      marker = "## #{value[0].upcase} "
      marker += "#" * [@display_length - marker.length, 0].max
      marker = marker[0..(@display_length)]
      chunk_line = Chunks::ChunkLine.new([Chunks::Chunk.new(ColorMap.get_color(252, offset), marker, Ncurses::A_BOLD)])
    else
      chunks = [Chunks::Chunk.new(ColorMap.get_color(11, offset), " #{value[1]}", attr_offset), Chunks::Chunk.new(ColorMap.get_color(252, offset), value[0], Ncurses::A_BOLD)]

      if value[0] != value[3]
        chunks << Chunks::Chunk.new(ColorMap.get_color(245, offset), value[3], attr_offset)
        if value[2] != "1"
          chunks << Chunks::Chunk.new(ColorMap.get_color(245, offset), value[2], attr_offset)
        end
      end

      blank = Chunks::Chunk.new(ColorMap.get_color(252, offset), ' ', attr_offset)
      chunk_line = Chunks::ChunkLine.new(chunks.flat_map { |c| [c, blank] }[0...-1])
      fill_length = (@display_length - chunk_line.length)
      chunk_line << Chunks::Chunk.new(ColorMap.get_color(252, offset), " " * fill_length, attr_offset) if fill_length > 0
    end

    graphic.wmove r, c
    graphic.show_colored_chunks chunk_line, ColorMap.get_color(238), nil
  end
end

