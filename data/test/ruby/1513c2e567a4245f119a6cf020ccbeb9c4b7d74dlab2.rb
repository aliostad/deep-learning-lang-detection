require "thread"

class ParallelArray < Array
	attr_accessor :threads

	def initialize(*args)
		super *args
		@threads = 3
	end

	def map &func
		self._parallel { |chunk| chunk.map &func }
			.reduce([])  {|collector, i| collector + i}
	end

	def select &func
		self._parallel { |chunk| chunk.select &func }
			.reduce([])  {|collector, i| collector + i}
	end

	def any? &func
		self._parallel { |chunk| chunk.any? &func }
			.any?
	end

	def all? &func
		self._parallel { |chunk| chunk.all? &func }
			.all?
	end

	protected 
	def _parallel &func
		_chunk_size = (size / @threads.to_f).ceil
		_threads = self.each_slice(_chunk_size).map { |chunk|
			Thread.new {
				func.call(chunk)
			}
		}
		_threads.map {|thread|
			thread.value
		}
	end
end

a = ParallelArray.new(14) {|i| i*i}

print "Input:\t\t", a, "\n"

print "Map i -> i+1:\t", a.map{|i| i+1}, "\n"

print "Select i > 100:\t", a.select{|i| i > 100}, "\n"

print "any?\t\t", a.any?, "\n"
print "any > 100?\t", a.any?{|i| i > 100}, "\n"

print "all?\t\t", a.all?, "\n"
print "all > 100?\t",a.all?{|i| i > 100}, "\n"