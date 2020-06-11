class Buffer
	attr_accessor :filename
	
	def initialize(filename)
		@chunkArray = []
		@fileTop = 0
		@filename = filename
		@file = File.open(@filename, 'w')
		@insertion_semaphore = Mutex.new
	end
	
	def checkNext(newChunk, i)
		if newChunk[:id] > @chunkArray[i][:id] && newChunk[:id] < @chunkArray[i+1][:id]
			@chunkArray.insert(i+1, newChunk)
			return
		end
		checkNext(newChunk, i+1)
	end
	
	def insert(newChunk)
		@insertion_semaphore.synchronize {
			if @chunkArray.size == 0 || newChunk[:id] > @chunkArray[-1][:id]
				@chunkArray << newChunk
			elsif newChunk[:id] < @chunkArray[0][:id]
				@chunkArray.insert(0, newChunk)
			elsif newChunk[:id] > @chunkArray[0][:id]
				checkNext(newChunk, 0)
			end
			self.dump
		}
	end
	
	def countChunks(i)		
		return i+1 if @chunkArray.size == i+1 || @chunkArray[i][:id] != @chunkArray[i+1][:id]-1
		countChunks(i+1)
	end
	
	def dump
		safeCount = countChunks(0)
		if @chunkArray[0][:id] == @fileTop+1
			toDump = @chunkArray.shift(safeCount)
			@fileTop = toDump[-1][:id]
			toDump.each do |out_chunk|
				@file.write(out_chunk[:data])
			end
		end
	end
	
	def size
		size = 0
		@chunkArray.each do |chunk|
			size += chunk[:data].size
		end
		size
	end
	
	def count
		@chunkArray.size
	end
end
