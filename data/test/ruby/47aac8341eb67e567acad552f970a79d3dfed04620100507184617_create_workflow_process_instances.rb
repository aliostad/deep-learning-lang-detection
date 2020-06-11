class CreateWorkflowProcessInstances < ActiveRecord::Migration
  def self.up
    create_table :workflow_process_instances do |t|
      t.references :instance, :polymorphic => true
      t.references :process
      t.timestamps
    end
    add_index :workflow_process_instances, :instance_id
    add_index :workflow_process_instances, :instance_type
    add_index :workflow_process_instances, :process_id
  end

  def self.down
    remove_index :workflow_process_instances, :process_id
    remove_index :workflow_process_instances, :instance_type
    remove_index :workflow_process_instances, :instance_id
    drop_table :workflow_process_instances
  end
end
