module Aurora
  class Controller
    plugin :single_table_inheritance, :type
    many_to_one :controller_set, :key => :controller_set_id

    def copy
      controller = Controller.new
      controller.columns.each do |c|
        controller.set(c => self[c]) if c != :id
      end
    end
  end

  class NetworkController < Controller
    many_to_one :network, :key => :network_id
  end

  class NodeController < Controller
    many_to_one :node_family, :key => :node_id
  end

  class LinkController < Controller
    many_to_one :link_family, :key => :link_id
  end
end
