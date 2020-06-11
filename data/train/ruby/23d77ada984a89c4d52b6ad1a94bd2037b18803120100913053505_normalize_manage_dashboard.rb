class NormalizeManageDashboard < ActiveRecord::Migration
  def self.up
    # rename table to company_dashboards, becouse it keeps dashboard records as per the company
    rename_column(:manage_dashboards, :is_fav, :is_favorite)
    rename_column(:manage_dashboards, :fav_title, :favorite_title)
    rename_table(:manage_dashboards, :company_dashboards)
  end

  def self.down
    rename_table(:company_dashboards, :manage_dashboards)
    rename_column(:manage_dashboards, :is_favorite, :is_fav)
    rename_column(:manage_dashboards, :favorite_title, :fav_title)
  end
end
