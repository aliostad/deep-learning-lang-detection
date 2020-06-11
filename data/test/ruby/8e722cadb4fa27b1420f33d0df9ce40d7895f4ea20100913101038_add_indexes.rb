class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :campaign_recipients, [:recipient_id, :campaign_id]
    # change_table :users do |t|
    #   t.boolean :can_manage_users, :can_manage_contacts, :can_manage_subscriber_lists, :can_manage_mailing, :default => false
    # end
  end

  def self.down
    remove_index :campaign_recipients, [:recipient_id, :campaign_id]
    # remove_column :users, :can_manage_users, :can_manage_contacts, :can_manage_subscriber_lists, :can_manage_mailing
  end
end
