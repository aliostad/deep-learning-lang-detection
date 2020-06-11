class ChunkVersion < ActiveRecord::Base
  belongs_to :chunk

  before_save :set_version

  def set_version
    self.version = self.next_version
  end

  def last_version
    ChunkVersion.last_version(self.chunk_id)
  end

  def self.last_version(chunk_id)
    ChunkVersion.next_version(chunk_id).to_i - 1
  end

  def next_version
    ChunkVersion.next_version(self.chunk_id)
  end

  def self.next_version(chunk_id)
    connection.select_value("SELECT MAX(version)+1 FROM chunk_versions WHERE chunk_id = #{chunk_id}") || 1
  end

end
