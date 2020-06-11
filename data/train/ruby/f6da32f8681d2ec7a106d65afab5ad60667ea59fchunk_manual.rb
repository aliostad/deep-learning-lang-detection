require 'rubygems'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'prawn'
require 'prawn/chunk'

module Prawn
  class Document
    def example(src)
      example_box(src)
      move_down 10
      source_box(src)
    end

    def example_box(src)
      ypos = cursor
      bounding_box [0, ypos], :width => 400 do
        chunk_flow :background_color => 'dddddd' do
          eval(src)
        end
      end
      text "EXAMPLE", :size => 8, :at => [410, ypos - 8]
    end

    def source_box(src)
      ypos = cursor
      bounding_box [0, ypos], :width => 400 do
        chunk_flow  :font_family => 'Courier', :size => 8, :background_color => 'ddffdd' do
          chunk "chunk_flow do"
          chunk_new_line
          src.each_line do |line|
            chunk line
            chunk_new_line
          end
          chunk "end"
          chunk_new_line
        end
      end
      text "SOURCE", :size => 8, :at => [410, ypos - 8]
    end
  end
end

Prawn::Document.generate "chunk_manual.pdf" do
  text "Chunk Examples", :align => :center, :size => 16
  move_down 20
  chunk_flow do
    chunk "All chunk statements must be enclosed in a "
    chunk "chunk_flow", :style => :bold
    chunk "block. Each chunk can have its own font, style, size, and color as"
    chunk "illustrated in the following example."
  end
  move_down 10

  font 'Helvetica', :size => 11

  src = <<EXAMPLE1
  chunk "Rule #1: ", :style => :bold
  chunk "Here at Bob's Nuclear Test Facility, do not press any "
  chunk "RED", :style => :bold, :color => 'ff0000'
  chunk " buttons unless you have "
  chunk "direct authorization from Bob himself.", :style => :italic
EXAMPLE1
  example(src)
  move_down 10
  chunk_flow do
    chunk "There are five statements that move the cursor: "
    chunk_new_line
    chunk " - chunk_new_line", :style => :bold
    chunk " - move down to the begining of the next line"
    chunk_new_line
    chunk " - chunk_move_left", :style => :bold
    chunk " - move left on the same line"
    chunk_new_line
    chunk " - chunk_move_right", :style => :bold
    chunk " - move right on the same line"
    chunk_new_line
    chunk " - chunk_move_down", :style => :bold
    chunk " - move down, but keep the same x position"
    chunk_new_line
    chunk " - chunk_move_up", :style => :bold
    chunk " - move up, but keep the same x position"
    chunk_new_line
    chunk_new_line
    chunk "These commands are illustrated in the next two examples."
  end
  move_down 10

  src = <<EXAMPLE2
  chunk "\\\\"
  chunk_move_down 8
  chunk_move_left 3
  chunk "\\\\"
  chunk_move_down 8
  chunk_move_left 6
  chunk "/"
  chunk_move_down 8
  chunk_move_left 9
  chunk "/"
EXAMPLE2
  example(src)
  move_down 10
  src = <<EXAMPLE3
  chunk "Dear Boss,"
  chunk_new_line
  chunk "When I first heard about the new "
  chunk "FOUR DAY WORK WEEK", :font_family => 'Courier', :size => 9
  chunk_move_up 4
  chunk_move_left 4
  chunk "TM", :size => 6
  chunk_move_down 4
  chunk " I was really excited. but after reading "
  chunk "that I only get 80% of my original pay, "
  chunk "I think the idea is really stupid"
  chunk_move_left 32
  chunk "--------", :style => :bold
  chunk " short sighted."
EXAMPLE3
  example(src)
  start_new_page

  chunk_flow do
    chunk "Small images can be inserted inline into text using the "
    chunk "chunk_image", :style => :bold
    chunk " statement as shown below:"
  end
  move_down 10

  src = <<EXAMPLE4
  chunk "Prawn is:"
  chunk_left_margin 24
  chunk_new_line
  chunk_image "checkbox_checked.png", :width => 8, :height => 8
  chunk " really, really cool"
  chunk_new_line
  chunk_image "checkbox_unchecked.png", :width => 8, :height => 8
  chunk " average, everyday cool"
  chunk_new_line
  chunk_image "checkbox_unchecked.png", :width => 8, :height => 8
  chunk " kinda luke warm"
EXAMPLE4
  example(src)

  move_down 10
  chunk_flow do
    chunk "Chunks can be as small as a single word, or even a single "
    chunk "character in a word as shown in the following two examples."
  end
  move_down 10

  src = <<EXAMPLE5
  text = "shades of springtime"
  i = 0
  (70..250).step(8) do |g|
    hex = "00" + '%02x' % g + "00"
    break if (i > text.size)
      chunk text[i,1], :color => hex, :no_space => (text[i + 1, 1] != ' ')
    i += 1
  end
EXAMPLE5
  example(src)
  move_down 10
  src = <<EXAMPLE6
  text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit semper elit et scelerisque. Ut pretium, ligula vitae ullamcorper malesuada, dui arcu faucibus enim, vel blandit nulla ante et dolor."
  size = 0
  text.split(' ').each do |word|
    chunk word, :size => 6 + size
    size += 1
    size = size % 20
  end
EXAMPLE6
  example(src)
  move_down 10
  text "Note how line spacing is automatically adjusted to fit the largest font size in the line."
  
end




