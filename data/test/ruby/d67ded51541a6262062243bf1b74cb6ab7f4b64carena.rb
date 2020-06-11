require 'gl'
require 'glu'

class Arena
  include Gl
  include Glu
  
  Transparence = Gosu::Color.new(0,0,0,0)
  CHUNK_SIZE = 256
  CHUNK_SIZE_BITS = CHUNK_SIZE.bits
  Chunk = Struct.new(:tex, :data, :changed, :clean)

  def initialize(game)
    @game = game
    @game_width, @game_height = @game.width, @game.height

    color, color_string = Transparence, 'rgba'
    color_string[0],color_string[1],color_string[2],color_string[3]=color.red,color.green,color.blue,color.alpha
    @emptiness = Array.new(CHUNK_SIZE*CHUNK_SIZE, color_string)*""
    @chunks = (1..(@game.width.to_f/CHUNK_SIZE).ceil).map do
      (1..(@game.height.to_f/CHUNK_SIZE).ceil).map do
        tex = glGenTextures(1).first
        data = @emptiness.clone
        glBindTexture(GL_TEXTURE_2D, tex)
  	    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, CHUNK_SIZE, CHUNK_SIZE, 0, GL_RGBA, GL_UNSIGNED_BYTE, data)
  	    glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
  	    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR)
    		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR)
        Chunk.new(tex, data, false, true)
      end
    end
  end

  def putpixel(x, y, color=Transparence)
    x = x.to_i % @game.width
    y = y.to_i % @game.height
    chunk = @chunks[x >> CHUNK_SIZE_BITS][y >> CHUNK_SIZE_BITS]
    index = (((y % CHUNK_SIZE) << CHUNK_SIZE_BITS) + (x % CHUNK_SIZE)) << 2
    chunk.data[index] = color.red
    chunk.data[index + 1] = color.green
    chunk.data[index + 2] = color.blue
    chunk.data[index + 3] = color.alpha
    chunk.changed = true
    chunk.clean = false
  end

  def getpixel(x, y)
    x = x.to_i % @game.width
    y = y.to_i % @game.height
    chunk = @chunks[x >> CHUNK_SIZE_BITS][y >> CHUNK_SIZE_BITS]
    return Transparence if chunk.clean
    index = (((y % CHUNK_SIZE) << CHUNK_SIZE_BITS) + (x % CHUNK_SIZE)) << 2
    Gosu::Color.new(chunk.data[index+3], chunk.data[index], chunk.data[index+1], chunk.data[index+2])
  end
  
  def clear(x, y, size)
    x, y, size = x.to_i, y.to_i, size.to_i
    width, height = @game.width, @game.height

    (y-size).upto(y+size) do |py|
      (x-size).upto(x+size) do |px|
        px %= width
        py %= height
        chunk = @chunks[px >> CHUNK_SIZE_BITS][py >> CHUNK_SIZE_BITS]
        index = (((py % CHUNK_SIZE) << CHUNK_SIZE_BITS) + (px % CHUNK_SIZE)) << 2
        chunk.data[index..index+3] = "\0\0\0\0"
        chunk.changed=true
      end
    end
  end
  
  def clear_all
    @chunks.each { |row| row.each { |c| c.data = @emptiness.clone; c.changed = true; c.clean=true } }
  end
  
  def paint_all(color)
    color_string = 'rgba'
    color_string[0],color_string[1],color_string[2],color_string[3]=color.red,color.green,color.blue,color.alpha
    players_cs = []
    @game.players.each do |p|
      cs = 'rgba'
      cs[0],cs[1],cs[2],cs[3]=p.color.red,p.color.green,p.color.blue,p.color.alpha
      players_cs << cs
    end
    @chunks.each do |row|
      row.each do |c|
        players_cs.each { |cs| c.data.gsub!(cs,color_string) }
        c.changed = true
      end
    end
  end

  def draw
    # Update changed chunks
    @chunks.each do |cy|
      cy.each do |c|
        next unless c.changed
        glBindTexture(GL_TEXTURE_2D, c.tex)
  	    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, CHUNK_SIZE, CHUNK_SIZE, 0, GL_RGBA, GL_UNSIGNED_BYTE, c.data)
    	  c.changed = false
	    end
    end

    # Draw all chunks
    @game.gl do
      glEnable(GL_BLEND)
      glBlendFunc(GL_SRC_ALPHA, GL_ONE);
      glEnable(GL_TEXTURE_2D)
      x= 0; @chunks.each do |cy|
        y = 0
        cy.each do |c|
          glBindTexture(GL_TEXTURE_2D, c.tex)

          glBegin(GL_QUADS);
          glColor4f(1.0,1.0,1.0,0.25)
          [[x-1, y-1],           [x+1, y-1],
                       [x, y],
           [x-1, y+1],           [x+1, y+1]].each do |px, py| 
            glTexCoord2d(0.0,0.0); glVertex2d(px,py)
            glTexCoord2d(1.0,0.0); glVertex2d(px+CHUNK_SIZE,py)
            glTexCoord2d(1.0,1.0); glVertex2d(px+CHUNK_SIZE,py+CHUNK_SIZE)
            glTexCoord2d(0.0,1.0); glVertex2d(px,py+CHUNK_SIZE)
          end
          glEnd()

          y += CHUNK_SIZE
        end
        x += CHUNK_SIZE
      end
    end
  end
end
