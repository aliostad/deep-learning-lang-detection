module Workflow
  class ProcessGraphEdge < ActiveRecord::Base
    belongs_to :process_graph_node
    belongs_to :end_node,
      class_name: Workflow::ProcessGraphNode
    has_many :process_graph_nodes

    has_many :process_instance_edges, inverse_of: :process_graph_edge

    def create_instance_edge_for(instance)
      process_instance_edges.create(
        process_instance_node_id:
          process_graph_node.node_for(instance).id,
        process_graph_edge_id: id,
        end_instance_node_id:
          end_node.node_for(instance).id
      )
    end
  end
end
