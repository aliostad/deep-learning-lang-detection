class CreateManageAccounts < ActiveRecord::Migration
  def change
		create_table :manage_accounts, force: true do |t|
			t.string   :pic
			t.string   :name
			t.string   :gender
			t.date     :birthday
			t.datetime :login_at
			t.boolean :active, null: false, default: true
			t.integer :lock_version, null: false, default: 0
			t.timestamps
		end
		add_index "manage_accounts", ["birthday"], :name => "index_manage_accounts_on_birthday"
		add_index "manage_accounts", ["created_at"], :name => "index_manage_accounts_on_created_at"
		add_index "manage_accounts", ["id"], :name => "index_manage_accounts_on_id"
		add_index "manage_accounts", ["login_at"], :name => "index_manage_accounts_on_login_at"
		add_index "manage_accounts", ["updated_at"], :name => "index_manage_accounts_on_updated_at"
  end
end
