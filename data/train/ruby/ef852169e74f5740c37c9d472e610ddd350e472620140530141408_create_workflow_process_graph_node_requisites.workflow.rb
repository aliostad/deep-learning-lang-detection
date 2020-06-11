# This migration comes from workflow (originally 20140529131728)
class CreateWorkflowProcessGraphNodeRequisites < ActiveRecord::Migration
  def change
    create_table :workflow_process_graph_node_requisites do |t|
      t.references :process_graph_node
      t.integer :validator_type
      t.text :validator_content

      t.timestamps
    end

    add_index :workflow_process_graph_node_requisites,
      :process_graph_node_id,
      name: 'process_graph_node_on_process_graph_node_requisites_index'
  end
end
