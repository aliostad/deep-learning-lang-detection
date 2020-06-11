# FIXME
module ArtistsHelper

    def split_on_and( chunks )
    new_chunks = []
    chunks.each do | chunk |

      # don't want to split too small a chunk
      if chunk.length <= 10
        new_chunks << chunk
      elsif chunk.match " And "
        chunk.split(" And ").each_with_index do |chunk,i|
          new_chunks[i] = "#{chunk}".strip if i == 0
          new_chunks[i] = "And #{chunk}".strip unless i == 0
        end
      else
        new_chunks << chunk
      end
    end
    new_chunks.flatten
  end


  def split_on_ampersand( chunks )
    new_chunks = []
    chunks.each do | chunk |
      if chunk.length > 10
        new_chunks << chunk
        next
      end
      if chunk.match " & "
        chunk.split(" & ").each_with_index do |chunk,i|
          new_chunks[i] = "#{chunk}".strip if i == 0
          new_chunks[i] = "& #{chunk}".strip unless i == 0
        end
      else
        new_chunks << chunk
      end
    end
    new_chunks.flatten
  end



  def split_on_important_stuff(stuff)
    # stuff
    split_of_the_life_of split_on_and split_on_ampersand split_on_semicolon  split_on_featuring split_on_with stuff
    # split_on_and split_on_ampersand

  end

  def split_of_the_life_of( names )
    new_chunks = []

    names.each do |name|
      if name.match("Of The Life Of")
        crap = []
        crap << name.split("Of The Life Of").each_with_index do |chunk,i|
          new_chunks[i] = "#{chunk} Of The Life Of".strip if i == 0
          new_chunks[i] = "#{chunk}".strip unless i == 0
        end
      else
        new_chunks << name
      end
    end
    new_chunks.flatten
  end


  def split_on_semicolon( names )
    new_chunks = []

    names.each do |name|
      if name.match(": ")
        crap = []
        crap << name.split(": ").each_with_index do |chunk,i|
          new_chunks[i] = "#{chunk}:".strip if i == 0
          new_chunks[i] = "#{chunk}".strip unless i == 0
        end
      else
        new_chunks << name
      end
    end
    new_chunks.flatten
  end

  def split_on_featuring( names )
    new_chunks = []

    names.each do |name|
      if name.match(" Featuring ")
        crap = []
        crap << name.split(" Featuring ").each_with_index do |chunk,i|
          new_chunks[i] = "#{chunk}:".strip if i == 0
          new_chunks[i] = "Featuring #{chunk}".strip unless i == 0
        end
      else
        new_chunks << name
      end
    end
    new_chunks.flatten
  end

  def split_on_with( names )
    new_chunks = []

    names.each do |name|
      if name.match(" With ")
        crap = []
        crap << name.split(" With ").each_with_index do |chunk,i|
          new_chunks[i] = "#{chunk}:".strip if i == 0
          new_chunks[i] = "With #{chunk}".strip unless i == 0
        end
      else
        new_chunks << name
      end
    end
    new_chunks.flatten
  end


  def break_on_but_include_word(phrase)

  end

end
