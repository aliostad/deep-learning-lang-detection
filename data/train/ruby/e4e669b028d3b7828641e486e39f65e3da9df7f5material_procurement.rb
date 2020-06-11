class MaterialProcurement < ActiveRecord::Base
  belongs_to :material
  belongs_to :project
  attr_accessible :material_id, :date, :price_per_unit, :quantity, :total

  validates :date, :price_per_unit, :quantity, presence: true
  validates  :total,:price_per_unit, :quantity, numericality: true, allow_nil: true
  validates_presence_of :material_id
  before_save :calculate_total
  after_save :calculate_totals_for_material,  :update_phase_avg, :update_project
  after_destroy :calculate_totals_for_material, :update_phase_avg, :update_project

  def calculate_total
    self.total = self.quantity * self.price_per_unit
  end

  def calculate_totals_for_material
    self.material.calculate_total_units_and_cost
  end
   #FIXME update the avgs when new material is bought
   def update_phase_avg

  end

   def update_project
    self.project.calculate_totals_and_balance_and_progress
  end
end
