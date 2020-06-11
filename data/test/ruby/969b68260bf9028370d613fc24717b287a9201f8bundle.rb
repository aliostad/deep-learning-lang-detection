class Bundle < Struct.new :date, :chunks
  class << self
    def all
      create(chunk_group)
    end

    def last(number)
      create(chunk_group.last(number))
    end

    def get(date)
      Bundle.new(date, Chunk.where(['created_at >= ? AND created_at < ?', date, date + 1.day]))
    end

    private

      def create(chunk_group)
        chunk_group.inject([]) do |bundles, group|
          bundles << Bundle.new(group.first, group.last)
        end
      end

      def chunk_group
        Array(Chunk.all.group_by { |chunk| chunk.created_at.to_date })
      end
  end

  def content
    self.chunks.map(&:content).join("\n")
  end
end
