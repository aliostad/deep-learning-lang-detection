class CreateBirstProcessGroupCollectionAssociations < ActiveRecord::Migration
  def change
    create_table :birst_process_group_collection_associations do |t|
      t.belongs_to :birst_process_group
      t.belongs_to :birst_process_group_collection

      t.timestamps
    end

    add_index :birst_process_group_collection_associations, [:birst_process_group_id, :birst_process_group_collection_id], unique: true, name: 'idx_birst_process_group_collection_associations'
    add_index :birst_process_group_collection_associations, :birst_process_group_collection_id, name: 'idx_birst_process_group_collection_associations_collection_id'
  end
end
