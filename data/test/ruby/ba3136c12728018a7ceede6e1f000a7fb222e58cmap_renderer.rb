# Specialized renderer for rendering EditorMaps
class MapRenderer < Moon::RenderArray
  # @return [Camera3]
  attr_accessor :camera
  # @return [ES::EditorMap]
  attr_accessor :dm_map
  # @return [Array<Float>]
  attr_reader :layer_opacity

  def initialize_members
    super
    @layer_opacity = [1.0, 1.0]
  end

  def layer_opacity=(layer_opacity)
    @layer_opacity = layer_opacity
    @elements.each do |e|
      e.layer_opacity = @layer_opacity
    end
  end

  # @param [ES::EditorChunk] chunk
  private def add_chunk(chunk)
    renderer = chunk_renderer_class.new
    renderer.chunk = chunk
    renderer.layer_opacity = @layer_opacity
    add(renderer)
  end

  def chunk_renderer_class
    ChunkRenderer
  end

  def dm_map=(dm_map)
    clear
    @dm_map = dm_map
    @dm_map.chunks.each { |chunk| add_chunk(chunk) }
    # clear size, so it can refresh
    resize nil, nil
  end

  def apply_position_modifier(*vec3)
    pos = super(*vec3)
    pos -= Moon::Vector3[@camera.view_offset, 0] if @camera
    pos
  end
end
