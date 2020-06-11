module ES
  class EditorMap < Moon::DataModel::Base
    array :chunks, type: EditorChunk

    def bounds
      l, r, t, b = nil, nil, nil, nil
      chunks.each do |chunk|
        l ||= chunk.position
        r ||= chunk.position
        t ||= chunk.position
        b ||= chunk.position
        l = chunk.position if l.x > chunk.position.x
        r = Moon::Vector3.new(chunk.bounds.x2, 0) if r.x < chunk.bounds.x2
        t = chunk.position if t.y > chunk.position.y
        b = Moon::Vector3.new(0, chunk.bounds.y2) if b.y < chunk.bounds.y2
      end
      Moon::Rect.new(l.x, t.y, r.x - l.x, b.y - t.y)
    end

    def w
      bounds.w
    end

    def h
      bounds.h
    end

    def to_map
      map = Map.new
      map.update_fields(to_h.exclude(:chunks))
      map.chunks = chunks.map(&:to_chunk_head)
      map
    end
  end
end
