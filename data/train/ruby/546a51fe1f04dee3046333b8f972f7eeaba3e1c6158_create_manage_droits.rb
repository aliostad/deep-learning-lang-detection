
class CreateManageDroits < ActiveRecord::Migration

    def self.up
        create_table(:manage_droits, :primary_key => [:id_perm, :id_role, :id_collection, :id_lieu]) do |t|
            t.column :id_perm, :string, :null => false
            t.column :id_role, :string, :null => false
            t.column :id_lieu, :string, :null => false
            t.column :id_collection, :int, :null => false
        end
#       execute "ALTER TABLE manage_droits ADD FOREIGN KEY (id_perm) REFERENCES manage_permissions(id_perm)";
#       execute "ALTER TABLE manage_droits ADD FOREIGN KEY (id_role) REFERENCES manage_roles(id_role)";
#       execute "ALTER TABLE manage_droits ADD FOREIGN KEY (id_collection) REFERENCES collections(id)";
#       execute "ALTER TABLE manage_droits ADD PRIMARY KEY (id_perm, id_role, id_lieu, id_collection)";
    end

    def self.down
        drop_table :manage_droits
    end

end
