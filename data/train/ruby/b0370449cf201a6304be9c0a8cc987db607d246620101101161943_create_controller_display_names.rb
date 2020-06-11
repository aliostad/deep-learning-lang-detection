class CreateControllerDisplayNames < ActiveRecord::Migration
  def self.up
    create_table :controller_display_names do |t|
    t.string :controller_name
    t.string :display_name
    t.timestamps
    end
    
    ControllerDisplayName.create(:controller_name => GasSummaryController.controller_name, :display_name => "Gas Totals")
    ControllerDisplayName.create(:controller_name => AnnualReportsController.controller_name, :display_name => "Annual Report")
    ControllerDisplayName.create(:controller_name => CalculationCheckTasksController.controller_name, :display_name => "Calculation Check")
    ControllerDisplayName.create(:controller_name => CcaExemptionsController.controller_name, :display_name => "CCA Exemptions")
    ControllerDisplayName.create(:controller_name => ElectricityDetailController.controller_name, :display_name => "Electricity Comparison")
    ControllerDisplayName.create(:controller_name => ElectricitySummaryController.controller_name, :display_name => "Electricity Totals")
    ControllerDisplayName.create(:controller_name => EmissionMetricsTasksController.controller_name, :display_name => "Emission Metrics")
    ControllerDisplayName.create(:controller_name => EnergyMetricsTasksController.controller_name, :display_name => "Energy Metrics")
    ControllerDisplayName.create(:controller_name => ReconfirmationExemptionTasksController.controller_name, :display_name => "Reconfirm Exemptions")
    ControllerDisplayName.create(:controller_name => StatusHomeController.controller_name, :display_name => "Status")
  end

  def self.down
    drop_table :controller_display_names
  end
end
