class AddIndicesToPageAndRepository < ActiveRecord::Migration
  def self.up
    add_index :pages, [:title, :repository_id]
    add_index :pages, [:local_id, :repository_id]
    add_index :pages, [:total_backlink_count, :repository_id] #To enable sorting to find entries with the most total backlinks
    add_index :pages, [:direct_link_id, :repository_id]
    add_index :pages, :repository_id
  end

  def self.down
    remove_index :pages, [:title, :repository_id]
    remove_index :pages, [:local_id, :repository_id]
    remove_index :pages, [:total_backlink_count, :repository_id]
    remove_index :pages, [:direct_link_id, :repository_id]
    remove_index :pages, :repository_id
  end
end

