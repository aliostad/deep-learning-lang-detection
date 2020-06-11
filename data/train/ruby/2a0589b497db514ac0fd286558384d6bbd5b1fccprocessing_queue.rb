require "thread"

class ProcessingError < StandardError; end

module ProcessingQueue

	def setup_processing_queue
		@process_queue = []
		@process_queue_mutex = Mutex.new
		@process_queue_started = false
	end

	def enqueue(request, &callback)
		if ready?
			@process_queue_mutex.synchronize {
				@process_queue << [request, callback]
			}
			process_next unless @process_queue_started
		else
			not_ready(request, &callback)
		end
	end

	private
	def process_next
		@process_queue_mutex.synchronize {
			item = @process_queue.shift
			@process_queue_started = !item.nil?
			if @process_queue_started
				begin
					process(item[0], &item[1])
				rescue ProcessingError => e
					@process_queue_started = false
				end
			end
		}
		process_next if @process_queue_started
	end

end
