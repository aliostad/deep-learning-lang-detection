class Item < ActiveRecord::Base
  attr_accessible :week_average, :month_average, :year_average,
                  :lifetime_average, :name
  belongs_to :user

  has_many :traces, dependent: :destroy

  default_scope { order('created_at DESC') }

  validates :name, :user, presence: true

  def self.update_averages!
    all.collect(&:update_averages!)
  end

  def update_averages!
    update_attributes(
      week_average: calculate_week_average,
      month_average: calculate_month_average,
      year_average: calculate_year_average,
      lifetime_average: calculate_lifetime_average,
    )
  end

  private

  def day_count
    @day_count ||= traces.day_count
  end

  def calculate_week_average
    traces.week.sum(:count).to_f / [7, day_count].min
  end

  def calculate_month_average
    traces.month.sum(:count).to_f / [30, day_count].min
  end

  def calculate_year_average
    traces.year.sum(:count).to_f / [365, day_count].min
  end

  def calculate_lifetime_average
    traces.sum(:count).to_f / day_count
  end
end
