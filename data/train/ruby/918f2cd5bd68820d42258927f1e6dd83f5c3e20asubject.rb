class Subject < ActiveRecord::Base
  belongs_to :user

  has_many :challenges

  before_validation do
    self.accept_token ||= SecureRandom.hex
  end

  validates :title, :objective, :accept_token, presence: true
  validates :accept_token, uniqueness: true

  after_create do
    repository_id = "challenge_#{SecureRandom.hex(3)}"
    if self.user.github_authorization.create_repository repository_id, self.objective
      challenges.create repository_id: repository_id, user: self.user
    end
  end


  def creator_repository
    challenges.find_by user_id: self.user_id
  end

  def challenge(user)
    login = self.user.github_authorization.login
    repository_id = creator_repository.repository_id

    if user.github_authorization.fork_repository login, repository_id
      challenges.create repository_id: repository_id, user: user
    end
  end
end
