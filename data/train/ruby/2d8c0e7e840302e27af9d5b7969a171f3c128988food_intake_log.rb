class FoodIntakeLog < ActiveRecord::Base
  attr_accessible :amount, :intake_date, :intake_time, :user_id, :food_id, :calories, \
  :carbohydrates, :cholesterol, :fibre, :protein, :saturated_fats, :sugars, :unsaturated_fats

  belongs_to :food
  belongs_to :user
  validates :amount, :intake_date, :intake_time, :user_id, :food_id,  :presence => true

  #calculations of each nutrient intake in grams

  def calculate_calories_intake
    return self.food.calories / 100.0 * self.amount
  end

  def calculate_carbohydrates_intake
    return self.food.carbohydrates / 100.0 * self.amount
  end

  def calculate_cholesterol_intake
    return self.food.cholesterol / 100.0 * self.amount
  end

  def calculate_fibre_intake
    return self.food.fibre / 100.0 * self.amount
  end

  def calculate_protein_intake
    return self.food.protein / 100.0 * self.amount
  end

  def calculate_saturated_fats_intake
    return self.food.saturated_fats / 100.0 * self.amount
  end

  def calculate_unsaturated_fats_intake
    return self.food.unsaturated_fats / 100.0 * self.amount
  end

  def calculate_sugars_intake
    return self.food.sugars / 100.0 * self.amount
  end
end