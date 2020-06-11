class AddLoginAndPasswordToRepositories < ActiveRecord::Migration

  def up
    add_column :repositories, :login, :string
    add_column :repositories, :password, :string

    Repository.all.each do |repository|
      repository.login = repository.autoupdate_login
      repository.password = repository.autoupdate_password
      repository.save!
    end
    
    remove_column :repositories, :autoupdate_login
    remove_column :repositories, :autoupdate_password
  end

  def down
    add_column :repositories, :autoupdate_login, :string
    add_column :repositories, :autoupdate_password, :string

    Repository.all.each do |repository|
      repository.autoupdate_login = repository.login
      repository.autoupdate_password = repository.password
      repository.save!
    end
    
    remove_column :repositories, :login
    remove_column :repositories, :password
  end
end
