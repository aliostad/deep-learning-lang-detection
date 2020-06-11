require 'gosu'

module Tentative

  MILLISECOND = 0.001

  class Engine

    def initialize
      @last_time = Gosu::milliseconds
      @time = 0

      @systems = {:update => {}, :draw => {}, :once => {},
        :btn_up => {}, :btn_down => {}}

      @chunks = {
        :default => gen_chunk
      }
      @inactive_chunks = {}

      @chunks_to_remove = []
      @chunks_to_change = []

      @entities_to_add = []
      @entities_to_remove = []
      @entities_to_move = []

      @next_id = 0

      @input_state = {}
    end

    def add_system type, name, node, &block
      @systems[type][name] = [node, block]
      self
    end

    def remove_system type, name
      @systems[type].delete name
      self
    end

    def add_entity_to_chunk entity, chunk_name, *nodes
      if @updating
        @entities_to_add << [entity, chunk_name, nodes]
      else
        chunk = get_chunk chunk_name

        id = gen_id

        entity[:id] = id
        entity[:chunk] = chunk_name

        nodes.each do |node|
          chunk[:nodes][node] ||= {}
          chunk[:nodes][node][id] = entity
        end
      end
      self
    end

    def add_entity entity, *nodes
      add_entity_to_chunk entity, :default, *nodes
    end

    def remove_entity entity, *nodes
      if @updaing
        @entities_to_remove << [entity, nodes]
      else
        chunk = get_chunk entity[:chunk]

        if nodes.include? :all
          chunk[:nodes].each do |node,list|
            list.delete entity[:id]
          end
          entity[:chunk] = nil
          entity[:id] = nil
        else
          nodes.each do |node|
            chunk[:nodes][node].delete entity[:id]
          end
        end
      end
      self
    end

    def move_entity entity, chunk_name
      if @updating
        @entities_to_move << [entity, chunk_name]
      else
        from_chunk = get_chunk entity[:chunk]
        to_chunk = get_chunk chunk_name

        entity[:chunk] = chunk_name
        id = entity[:id]

        from_chunk[:nodes].select do |node, list|
          list.delete id
        end.each do |node,list|
          (to_chunk[:nodes][node] ||= {})[id] = entity
        end
      end
      self
    end

    def each_entity node
      @chunks.each do |chunk_name, chunk|
        if chunk[:nodes][node]
          chunk[:nodes][node].each do |id, e|
            yield e
          end
        end
      end
    end

    def total_entities
      all_chunks.values.reduce(0) do |x,chunk|
        x + chunk[:nodes].values.reduce(0) do |y,node|
          y + node.length
        end
      end
    end

    def active_entities
      @chunks.values.reduce(0) do |x,chunk|
        x + chunk[:nodes].values.reduce(0) do |y,node|
          y + node.length
        end
      end
    end

    def all_chunks
      @chunks.merge @inactive_chunks
    end

    def total_chunks
      @chunks.size + @inactive_chunks.size
    end

    def active_chunks
      @chunks.size
    end

    def add_chunk chunk_name
      @inactive_chunks[chunk_name] ||= gen_chunk
      self
    end

    def remove_chunk chunk_name
      if @chunks.include? chunk_name
        if @updating
          @chunks_to_remove << chunk_name
        else
          @chunks.delete chunk_name
        end
      else
        @inactive_chunks.delete chunk_name
      end
      self
    end

    def activate_chunk chunk_name, value=true
      if (value ? @inactive_chunks : @chunks).include? chunk_name
        if @updating
          @chunks_to_change << [chunk_name, value]
        else
          if value
            @chunks[chunk_name] = @inactive_chunks.delete(chunk_name)
          else
            @inactive_chunks[chunk_name] = @chunks.delete(chunk_name)
          end
        end
      end
    end

    def deactivate_chunk chunk
      activate_chunk chunk, false
    end

    def button_down id
      exec_systems :btn_down do |sys,e|
        sys.call(e, id)
      end
      @input_state[id] = true
    end

    def button_up id
      exec_systems :btn_up do |sys,e|
        sys.call(e, id)
      end
      @input_state[id] = false
    end

    def down? id
      @input_state[id]
    end

    def update
      new_time = Gosu::milliseconds
      dt = (new_time-@last_time).to_f*MILLISECOND
      @time += dt
      @last_time = new_time

      @updating = true

      exec_systems :update do |sys,e|
        sys.call(e, dt, @time)
      end

      @updating = false

      @entities_to_add.each do |entity,chunk,nodes|
        add_entity_to_chunk entity, chunk, *nodes
      end
      @entities_to_add.clear

      @entities_to_remove.each do |entity,nodes|
        remove_entity entity, *nodes
      end
      @entities_to_remove.clear

      @entities_to_move.each do |entity,chunk|
        move_entity entity, chunk
      end
      @entities_to_move.clear

      @chunks_to_remove.each do |chunk_name|
        @chunks.delete(chunk_name) || @inactive_chunks.delete(chunk_name)
      end
      @chunks_to_remove.clear

      @chunks_to_change.each do |chunk_name,value|
        activate_chunk chunk_name, value
      end
      @chunks_to_change.clear

    end

    def draw
      exec_systems :draw do |sys,e|
        sys.call(e)
      end
    end

    def pause
      @input_state.clear
    end

    def unpause
      @input_state.clear
      @last_time = Gosu::milliseconds
    end

    private

      def gen_id
        id = @next_id
        @next_id += 1
        id
      end

      def gen_chunk
        {
          :nodes => {}
        }
      end

      def get_chunk chunk_name
        chunk = @chunks[chunk_name] || (@inactive_chunks[chunk_name] ||= gen_chunk)
        chunk
      end

      def exec_systems sys_name
        @chunks.each do |chunk_name, chunk|
          @systems[sys_name].each do |name, sys|
            node = chunk[:nodes][sys.first]
            unless node.nil?
              node.each do |i, e|
                yield sys.last, e
              end
            end
          end
        end
      end

  end

end