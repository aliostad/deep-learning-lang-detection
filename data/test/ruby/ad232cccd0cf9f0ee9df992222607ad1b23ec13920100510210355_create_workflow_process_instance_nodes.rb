class CreateWorkflowProcessInstanceNodes < ActiveRecord::Migration
  def self.up
    create_table :workflow_process_instance_nodes do |t|
      t.references :node
      t.references :process_instance
      t.timestamps
    end
    add_index :workflow_process_instance_nodes, :node_id
    add_index :workflow_process_instance_nodes, :process_instance_id
  end

  def self.down
    remove_index :workflow_process_instance_nodes, :process_instance_id
    remove_index :workflow_process_instance_nodes, :node_id
    drop_table :workflow_process_instance_nodes
  end
end
