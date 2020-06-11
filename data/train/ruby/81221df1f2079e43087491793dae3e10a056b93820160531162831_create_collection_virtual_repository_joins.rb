class CreateCollectionVirtualRepositoryJoins < ActiveRecord::Migration
  def change
    create_table :collection_virtual_repository_joins do |t|
      t.references :collection, index: false, foreign_key: true
      t.references :virtual_repository, index: false, foreign_key: true
      t.timestamps null: false
    end
    add_index :collection_virtual_repository_joins, [:virtual_repository_id, :collection_id], unique: true,
              name: 'collection_virtual_repository_join_unique_index'
    add_index :collection_virtual_repository_joins, :collection_id, name: 'collection_virtual_repository_join_collection_index'
  end
end
