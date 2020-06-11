class Question < ActiveRecord::Base
  has_many :answers, -> { includes :attachments }
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments

  after_create :update_reputation

  private

  def update_reputation
    self.delay.calculate_reputation
  end

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update(reputation: reputation)
  end
end
