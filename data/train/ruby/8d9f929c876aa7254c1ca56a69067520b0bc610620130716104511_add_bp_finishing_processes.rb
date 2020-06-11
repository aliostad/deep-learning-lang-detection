class AddBpFinishingProcesses < ActiveRecord::Migration
  def self.up
   bp_manufacturing_process_laminating = BpManufacturingProcess.create(:name => 'Laminating')
   BpManufacturingProcessTranslation.create(:bp_manufacturing_process_id => bp_manufacturing_process_laminating.id, :name => 'Laminating', :locale => 'en')   

   bp_manufacturing_process_printing = BpManufacturingProcess.create(:name => 'Printing')
   BpManufacturingProcessTranslation.create(:bp_manufacturing_process_id => bp_manufacturing_process_printing.id, :name => 'Printing', :locale => 'en')   

   bp_manufacturing_process_forming = BpManufacturingProcess.create(:name => 'Forming')
   BpManufacturingProcessTranslation.create(:bp_manufacturing_process_id => bp_manufacturing_process_forming.id, :name => 'Forming', :locale => 'en')   

   bp_manufacturing_process_variable_glue = BpManufacturingProcessVariable.create(:name => 'Amount of glue/binder/adhesive', :unit => 'kg/m<sup>2</sup>')
   BpManufacturingProcessVariableTranslation.create(:bp_manufacturing_process_variable_id => bp_manufacturing_process_variable_glue.id, :name => 'Amount of glue/binder/adhesive', :locale => 'en')   

   bp_manufacturing_process_variable_ink = BpManufacturingProcessVariable.create(:name => 'Amount of ink', :unit => 'kg/m<sup>2</sup>')
   BpManufacturingProcessVariableTranslation.create(:bp_manufacturing_process_variable_id => bp_manufacturing_process_variable_ink.id, :name => 'Amount of ink', :locale => 'en')   

   bp_manufacturing_process_variable_electricity_use = BpManufacturingProcessVariable.find(:first, :conditions => ["name = 'Electricity use'"])

   bp_manufacturing_process_laminating.bp_manufacturing_process_variables << bp_manufacturing_process_variable_glue
   bp_manufacturing_process_laminating.bp_manufacturing_process_variables << bp_manufacturing_process_variable_ink
   bp_manufacturing_process_laminating.bp_manufacturing_process_variables << bp_manufacturing_process_variable_electricity_use

   bp_manufacturing_process_printing.bp_manufacturing_process_variables << bp_manufacturing_process_variable_glue
   bp_manufacturing_process_printing.bp_manufacturing_process_variables << bp_manufacturing_process_variable_ink
   bp_manufacturing_process_printing.bp_manufacturing_process_variables << bp_manufacturing_process_variable_electricity_use

   bp_manufacturing_process_forming.bp_manufacturing_process_variables << bp_manufacturing_process_variable_glue
   bp_manufacturing_process_forming.bp_manufacturing_process_variables << bp_manufacturing_process_variable_ink
   bp_manufacturing_process_forming.bp_manufacturing_process_variables << bp_manufacturing_process_variable_electricity_use

    
  end

  def self.down
  end
end
