Hasu.load 'chunk.rb'

module Blocks
  def self._chunks
    @chunks
  end

  def self._chunk_for_point(x, y, z)
    cx = x.to_i / Chunk::SIZE * Chunk::SIZE
    cz = z.to_i / Chunk::SIZE * Chunk::SIZE

    _chunks[cx][cz]
  end

  def self.exists?(x, y, z)
    _chunk_for_point(x, y, z).exists?(x, y, z)
  end

  def self._dirty_neighbors!(x, y, z)
    _chunk_for_point(x+1, y, z).dirty!
    _chunk_for_point(x-1, y, z).dirty!
    _chunk_for_point(x, y+1, z).dirty!
    _chunk_for_point(x, y-1, z).dirty!
    _chunk_for_point(x, y, z+1).dirty!
    _chunk_for_point(x, y, z-1).dirty!
  end

  def self.add!(block)
    _chunk_for_point(block.x, block.y, block.z).add!(block)
    _dirty_neighbors!(block.x, block.y, block.z)
  end

  def self.remove!(block)
    _chunk_for_point(block.x, block.y, block.z).remove!(block)
    _dirty_neighbors!(block.x, block.y, block.z)
  end

  def self.[](x, y, z)
    _chunk_for_point(x, y, z)[x, y, z]
  end

  def self.reset!
    self.damage_block = nil
    _chunks.values.flat_map(&:values).each(&:dirty!)  if @chunks
    @chunks = Hash.new do |hx, x|
      hx[x] = Hash.new do |hz, z|
        hz[z] = Chunk.new(x, z)
      end
    end
  end

  def self._nearby_chunks(player)
    (-Player::SIGHT..Player::SIGHT).step(Chunk::SIZE).flat_map do |x|
      depth = Math.sqrt(Player::SIGHT**2 - x ** 2)
      (-depth..depth).step(Chunk::SIZE).map do |z|
        _chunk_for_point(player.x + x, player.y, player.z + z)
      end
    end
  end

  def self.draw(player)
    _nearby_chunks(player).each(&:draw)

    if damage_block
      damage_block.draw_damage
    end
  end

  def self.damage_block=(damage_block)
    if @damage_block && @damage_block != damage_block
      @damage_block.reset_strength!
    end
    @damage_block = damage_block
  end

  def self.damage_block
    @damage_block
  end
end
