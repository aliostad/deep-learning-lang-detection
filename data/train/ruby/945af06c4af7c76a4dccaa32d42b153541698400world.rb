class World
attr_accessor :config, :name, :players, :seed, :height, :type, :dimension, :difficulty, :spawnx, :spawny, :loaded_chunks
@server
@loaded_chunks
	def initialize server, world_config
		@server = server
		@name = world_config.name
		@seed = world_config.seed
		@config = world_config
		@players = {}
		@height = 1000
		@loaded_chunks = [] #Or Array.new
		@spawnx = 70
		@spawny = 70
		if !File.exists?(File.join(File.dirname(__FILE__),"../world/#{@name}"))
			@server.log.info "Creating filespace for world: #{@name}"
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/player/"))
		end
		for x in 0..3 #Load a 7 chunk area.
			load_chunk x
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
	def save_chunk x
		save_chunk get_chunk_at(x)
	end
	def save_chunk chunk
		@server.log.info "Saving chunk #{chunk.x}. World: #{@name}"
		chunk_file = File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/#{chunk.x}.dat")
		File.open(chunk_file, "w") do |file|
			d = Zlib::Deflate.deflate(Marshal::dump(chunk),9)
			file.print d
		end
	end
	def load_chunk x
		chunk_file = File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/#{x}.dat")
		if File.exists?(chunk_file)
			@server.log.info "Loading chunk #{x}. World: #{name}"
			object = File.read(chunk_file)
			@loaded_chunks.push Marshal::load(Zlib::Inflate.inflate(object))
		else
			@server.log.info "Generating chunk #{x}. World: #{name}"
			chunk = @server.terrain_generator.generate_chunk(self,x)
			@loaded_chunks.push chunk
			save_chunk chunk
		end
	end
	def get_chunk_at x
		@loaded_chunks.each do |block|
			if block.x == x
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
		  n_player = player.clone
		  n_player.connection = nil
		  n_player.world = nil
			file.print YAML::dump(n_player)
		end
	end
	def remove_player name
		@server.log.info "Removing player #{name}. World: #{@name}"
		@players.delete(name)
		#@players[name].delete
	end
	def load_player name, connection
		player_file = File.join(File.dirname(__FILE__),"../world/#{@name}/player/#{name}.yml")
		player = 0
		if File.exists?(player_file)
			File.open(player_file, "r") do |object|
				player = YAML::load(object)
			end
			if player==0
			  player = Player.new(name)
			end
		else
			player = Player.new(name)
		end
		player.id = @players.length
		player.connection = connection
		player.world = self
		player.inventory = []
		connection.player = player
		@players[name]=player
		return player
	end
end
