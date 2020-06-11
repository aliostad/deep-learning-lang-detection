class DishComposition < ActiveRecord::Base
  include Calorie
  attr_accessible :dish_id, :ingredient_id, :weight, :portions

  belongs_to :dish
  belongs_to :ingredient

  validates :ingredient_id, :presence => true

  before_save :calculate_portions_weight, :if => proc{ |i| i.ingredient.portion_unit == "item" }

  def portion_unit
    self.ingredient.portion_unit rescue nil
  end

  def calculate_portions_weight
    self.weight = self.ingredient.portion * self.portions
  end

  def proteins
    self.ingredient.calculate_nutrient_weight(:proteins, self.weight)
  end

  def fats
    self.ingredient.calculate_nutrient_weight(:fats, self.weight)
  end

  def carbs
    self.ingredient.calculate_nutrient_weight(:carbs, self.weight)
  end
end
