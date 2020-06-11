class Upload < ApplicationRecord
  STATUSES = %i(initiated partially_completed completed failed)
  include Statusable
  extend Statusable::ClassMethods

  has_many :chunks, -> { order(sequence_number: :asc) }, as: :chunkable, dependent: :destroy
  belongs_to :vault
  has_one :user, through: :vault

  after_create :create_first_chunk
  
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }

  delegate :default_chunk_size, to: :user

  def final_expected_chunk_count
    # not number of current chunks, but the number needed to complete
    # the upload based on file_size and chunk_size
    (file_size / chunk_size.to_f).ceil
  end

  def all_chunks_completed?
    chunks.completed.size == final_expected_chunk_count
  end

  def active_chunk
    return chunks.failed.first if chunks.failed.any?
    chunks.initiated.first if chunks.initiated.any?
  end

  def active_chunk_sequence_number
    return last_chunk.sequence_number unless active_chunk
    active_chunk.sequence_number
  end

  def last_chunk
    chunks.completed.last
  end

  def percent_completed
    (chunks.completed.size / final_expected_chunk_count.to_f) * 100
  end

  private

  def create_first_chunk
    chunks.create(status: :initiated, byte_range: "0-#{chunk_size.to_i - 1}", sequence_number: 1)
  end
end