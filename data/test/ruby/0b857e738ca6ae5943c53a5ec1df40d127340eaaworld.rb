class World
attr_accessor :config, :name, :players, :seed, :height, :type, :dimension, :difficulty
@server
@loaded_chunks
	def initialize server, world_config
		@server = server
		@name = world_config.name
		@seed = world_config.seed
		@config = world_config
		@players = {}
		@height = 128
		@dimension = 0 #0 = Normal, -1 = Nether
		@type = 1 #1 = creative, 0 = survival
		@difficulty = 0
		@loaded_chunks = [] #Or Array.new
		if !File.exists?(File.join(File.dirname(__FILE__),"../world/#{@name}"))
			@server.log.info "Creating filespace for world: #{@name}"
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/player/"))
		end
		for x in -3..3 #Load a 7x7 chunk area.
			for z in -3..3
				load_chunk x,z
			end
		end
		@server.log.info("Loaded world: #{@name}")
	end
	def save_all
		@loaded_chunks.each do |chunk|
			save_chunk chunk
		end
		@players.each do |player|
			save_player player.name
		end
	end
	def save_chunk x, z
		save_chunk get_chunk_at(x,z)
	end
	def save_chunk chunk
		@server.log.info "Saving chunk #{chunk.x}, ?, #{chunk.z}. World: #{@name}"
		chunk_file = File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/#{chunk.x},#{chunk.z}.dat")
		File.open(chunk_file, "w") do |file|
			d = Zlib::Deflate.deflate(Marshal::dump(chunk),9)
			file.print d
		end
	end
	def load_chunk x, z
		chunk_file = File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/#{x},#{z}.dat")
		if File.exists?(chunk_file)
			@server.log.info "Loading chunk #{x}, ?, #{z}. World: #{name}"
			object = File.read(chunk_file)
			@loaded_chunks.push Marshal::load(Zlib::Inflate.inflate(object))
		else
			@server.log.info "Generating chunk #{x}, ?, #{z}. World: #{name}"
			chunk = @server.terrain_generator.generate_chunk(self,x,z)
			@loaded_chunks.push chunk
			save_chunk chunk
		end
	end
	def get_chunk_at x, z
		@loaded_chunks.each do |block|
			if block.x == x and block.z == z
				return block
			end
		end
		return nil
	end
	def save_player name
		save_playerp @players[name]
	end
	def save_playerp player
		@server.log.info "Saving player #{player.name}. World: #{@name}"
		player_file = File.join(File.dirname(__FILE__),"../world/#{@name}/player/#{player.name}.yml")
		File.open(player_file, "w") do |file|
			file.print YAML::dump(player)
		end
	end
	def remove_player name
		@server.log.info "Removing player #{name}. World: #{@name}"
		@players[name].delete
	end
	def load_player name, connection
		player_file = File.join(File.dirname(__FILE__),"../world/#{@name}/player/#{name}.yml")
		if File.exists?(player_file)
			File.open(player_file, "r").each do |object|
				player = YAML::load(object)
			end
		else
			player = Player.new(name)
		end
		player.connection = connection
		player.world = self
		connection.player = player
		@players[name]=player
		return player
	end
end
