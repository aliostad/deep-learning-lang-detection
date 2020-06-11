class Venue < ActiveRecord::Base
  has_many :events
  has_many :genre_points, as: :target
  belongs_to :city

  delegate :calculate_genre,
           :calculate_name_embedded_points,
           :calculate_and_apply_genres,
           :self_tagged_genre_points,
           :user_tagged_genre_points,
           :add_genres!,
           :add_user_tagged_genres!,
           to: :genre_util

  validates :name,
            :city,
            presence: true

  def genre_util
    @genre_util ||= GenreUtil.new(self)
  end
end
