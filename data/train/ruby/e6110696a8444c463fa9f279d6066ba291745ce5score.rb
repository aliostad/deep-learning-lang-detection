class Score < ActiveRecord::Base
  # example:
  # User likes list item
  # user gets 1 point
  # scorable_type: "User", scorable_id: 1, actionable_type: "Like", actionable_id: 2, weight: 1
  belongs_to :scorable, polymorphic: true
  belongs_to :actionable, polymorphic: true
  belongs_to :list

  validates :scorable, :list, :weight, presence: true

  after_create :calculate_scores
  after_destroy :calculate_scores

  private

  def calculate_scores
    scorable.calculate_scores
    list.calculate_scores
  end
end
