 
User.transaction do
	user = User.find_or_create_by(email: 'super_admin@163.com') do |u|
		u.name = 'administrator'
		u.password = 'admin'
		u.password_confirmation = 'admin'
	end

	if (role = Manage::Role.find_by(name: '所有权限')).blank?
		role = Manage::Role.new name: '所有权限'
		role.attributes = Manage::Role::RESOURCES.zip(Array.new(Manage::Role::RESOURCES.size, 127)).to_h
		role.save!
	end

	if Manage::Account.find_by(id: user.id).blank?
		account = Manage::Account.new(name: '管理员', id: user.id)
		account.save!

		editor = Manage::Editor.new(name: '管理员', id: user.id)
		editor.save!

		Manage::Grant.create!(editor_id: editor.id, role_id: role.id)
	end

end
