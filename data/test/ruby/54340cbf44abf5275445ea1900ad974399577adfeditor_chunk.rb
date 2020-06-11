module ES
  class EditorChunk < Moon::DataModel::Base
    field :position, type: Moon::Vector3,    allow_nil: true, default: nil
    field :data,     type: Moon::DataMatrix, allow_nil: true, default: nil
    field :passages, type: Moon::Table,      allow_nil: true, default: nil
    field :tileset,  type: Tileset,    allow_nil: true, default: nil

    def resize(x, y)
      data.resize(x, y, data.zsize) if data
      passages.resize(x, y) if passages
    end

    def w
      data.xsize
    end

    def h
      data.ysize
    end

    def bounds
      Moon::Rect.new(position.x, position.y, w, h)
    end

    def to_chunk
      chunk = Chunk.new
      chunk.update_fields(to_h.exclude(:position, :tileset))
      chunk.tileset = tileset.to_tileset_head
      chunk
    end

    def to_chunk_head
      chunk_head = ChunkHead.new
      chunk_head.position = position
      chunk_head.uri = uri
      chunk_head
    end
  end
end
