class CreateProcessEngineProcessTasks < ActiveRecord::Migration
  def change
    create_table :process_engine_process_tasks do |t|
      t.string :assignee
      t.string :candidate_users, array: true, default: []
      t.string :candidate_groups, array: true, default: []
      t.integer :status, default: 0
      t.jsonb :data, default: {}
      t.string :finisher
      t.string :state
      t.references :process_instance


      t.timestamps null: false
    end

    add_index :process_engine_process_tasks, :assignee
    add_index :process_engine_process_tasks, :candidate_users, using: :gin
    add_index :process_engine_process_tasks, :candidate_groups, using: :gin
    add_index :process_engine_process_tasks, :data, using: :gin
    add_index :process_engine_process_tasks, :finisher
    add_index :process_engine_process_tasks, :state

    add_index :process_engine_process_tasks, :process_instance_id, name: :index_pept_piid

    add_foreign_key :process_engine_process_tasks,
                    :process_engine_process_instances,
                    column: :process_instance_id
  end
end
