class CreateManageUsers < ActiveRecord::Migration
	def change
		create_table :manage_users, force: true do |t|
			t.string   :pic
			t.string   :name
			t.string   :gender
			t.date     :birthday
			t.datetime :login_at
			t.boolean :active, null: false, default: true
			t.integer :lock_version, null: false, default: 0
			t.timestamps
		end
		add_index "manage_users", ["birthday"], :name => "index_manage_users_on_birthday"
		add_index "manage_users", ["created_at"], :name => "index_manage_users_on_created_at"
		add_index "manage_users", ["id"], :name => "index_manage_users_on_id"
		add_index "manage_users", ["login_at"], :name => "index_manage_users_on_login_at"
		add_index "manage_users", ["updated_at"], :name => "index_manage_users_on_updated_at"
	end
end
