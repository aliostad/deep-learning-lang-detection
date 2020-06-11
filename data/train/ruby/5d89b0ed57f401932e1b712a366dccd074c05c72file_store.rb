require './chunk.rb'

class Array
	def wrap(n)
		tmp = self.shift(n)
		self.replace(self+tmp)
		return tmp
	end
end

class FileStore

	attr_writer :all_nodes
	
	def initialize(filename, all_nodes, redundancy=3, chunk_size=5242880)
		@file = File.open(filename, 'rb')
		@chunk_size = chunk_size
		@all_nodes = all_nodes
		@chunks = []
		@redundancy = redundancy
		loop {
			my_nodes = get_next_live_nodes
			data = @file.read(@chunk_size)
			break if data == nil
			chunk = Chunk.new(data, my_nodes)
			@chunks << chunk
		}
		Thread.new{ enforce_redundancy }
		@file.close
	end
	
	def get_next_live_nodes
		all_alive = false
		my_nodes = nil
		until all_alive
			my_nodes = @all_nodes.wrap @redundancy
			all_alive = true
			my_nodes.each do |node|
				if !node.is_alive?
					all_alive = false
					@all_nodes.delete node
				end
			end
		end
		return my_nodes
	end
	
	def rebuild_file(filename)
		write_file = File.new(filename, 'wb')
		@chunks.each do |chunk|
			write_file.write(chunk.retrieve_data)
		end
		write_file.close
	end
	
	def delete_file
		@chunks.each do |chunk|
			chunk.delete
		end
	end
	
	def enforce_redundancy
		loop {
			@chunks.each do |chunk|
				@all_nodes.each do |node|
					if !node.is_alive?
						@all_nodes.delete node
						next
					end
					next if chunk.nodes.size == @redundancy
					next if chunk.nodes.include? node
					chunk.insert_new_node(node)
				end
			end
			@all_nodes.sort_by(&:usage)
			sleep 5
		}
	end
	
end
