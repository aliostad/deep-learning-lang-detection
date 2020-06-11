class ModifyApiDetails < ActiveRecord::Migration
  def up
    add_column :api_methods, :protocol, :string
    add_column :api_methods, :path, :string
    add_column :api_methods, :version, :string
    add_column :api_methods, :scope, :string, :null=>true
    add_column :api_methods, :consent_message, :string
    add_column :api_methods, :jsonp, :boolean
    add_column :api_methods, :server_accessible, :boolean
    add_column :api_methods, :user_accessible, :boolean
    add_column :api_methods, :max_latency, :integer
    add_column :api_methods, :status, :string
  end

  def down
    remove_column :api_methods, :protocol
    remove_column :api_methods, :path
    remove_column :api_methods, :version
    remove_column :api_methods, :scope
    remove_column :api_methods, :consent_message
    remove_column :api_methods, :jsonp
    remove_column :api_methods, :server_accessible
    remove_column :api_methods, :user_accessible
    remove_column :api_methods, :max_latency
    remove_column :api_methods, :status
  end
end
