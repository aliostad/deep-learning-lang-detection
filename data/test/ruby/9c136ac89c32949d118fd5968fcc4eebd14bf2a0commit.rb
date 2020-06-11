class Commit
  include Mongoid::Document

  field :repository_id, type: String
  field :ref, type: String
  field :date, type: DateTime

  embeds_one :author, class_name: 'Commit::Author'
  embeds_many :files, class_name: 'Commit::File'

  validates_presence_of :ref
  validates_presence_of :repository_id

  validate :repository_exists

private
  def repository_exists
    unless valid_repository?
      errors[:repository_id] << 'Repository does not exist.'
    end
  end

  def valid_repository?
    repository_id.present? && Repository.where(id: repository_id).exists?
  end
end
