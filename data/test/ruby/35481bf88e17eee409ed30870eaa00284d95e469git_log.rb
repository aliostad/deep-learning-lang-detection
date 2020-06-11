class GitLog < ActiveRecord::Base
  belongs_to :author
  belongs_to :repository
  validates_presence_of :sha, :repository
#  after_create :create_author_repository

  #scope for generating timesheet, called from author and repository controller
  scope :by_repository, lambda { |repository| { :conditions => ['repository_id = ?', repository] } }
  scope :by_author, lambda { |author| { :conditions => ['author_id = ?', author] } }
  scope :fromdate, lambda { |date| { :conditions => ['committed_at > ?', date] } }
  scope :to, lambda { |date| { :conditions => ['committed_at <= ?', date] } }

  def create_author_repository
    AuthorRepository.create(:author_id => author, :repository_id => repository)
  end
end
