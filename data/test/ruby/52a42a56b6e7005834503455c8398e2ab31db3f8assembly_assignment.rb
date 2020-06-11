class AssemblyAssignment < ActiveRecord::Base
  belongs_to :assembly
  belongs_to :title, :foreign_key => :product_id
  
  after_destroy :calculate_assembly_price
  after_create :calculate_assembly_price

  validates :assembly_id, :presence => true
  validates :product_id, :presence => true
  
  # By creating or destroying an assignment, we are in effect changing 
  # the parts within an assembly. Thus, we need to recalculate
  # the price of the assembly -- every price (eg, list, member) and
  # every format (eg, hardcover, pdf)
  
  # *** calculate_assembly_price takes precedence over calculate_list_price
  # if calculate_list_price == true && calculate_assembly_price == true -> assembly list is sum of parts list
  # if calculate_list_price == true && calculate_assembly_price == false -> assembly list is calculated from member ***
  # if calculate_list_price == false && calculate_assembly_price == true -> assembly list is sum of parts list
  # if calculate_list_price == false && calculate_assembly_price == false -> assembly list is user-defined
  def calculate_assembly_price
    logger.debug("Running assembly_assignment.calculate_assembly_price after_destroy/after_create callback method")
    logger.debug("  Assembly = #{self.assembly.name} (#{self.assembly_id})")
    logger.debug("  Title = #{self.title.name} (#{self.product_id})")
    if CONFIG[:calculate_assembly_price] != true
      logger.debug("Skip: Config calculate_assembly_price set to FALSE")
    else
      self.assembly.calculate_price
    end
  end
end
