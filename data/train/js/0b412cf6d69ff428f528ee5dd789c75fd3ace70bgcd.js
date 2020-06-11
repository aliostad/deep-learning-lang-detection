// gcd.js

// namespace
var GCD = {};

GCD.worker_id = 1;

// Create a Web Worker instance to do the task in its own thread.
GCD.AsyncWorker = function(id) {
	this.callbacks = {};
	this.asyncCount = 0;
	var self = this;

	var worker = new Worker('worker.js');
	worker.postMessage({'cmd': 'on_create', 'id': id});

	worker.onmessage = function(event) {
		var cb = self.callbacks[event.data.count];
		console.log('[' + id + ']' + ' result:' + event.data.result);
		if (cb)
			cb();
	};

	worker.onerror = function(error) {
		console.log('error in worker: [' + id + ':' + error.filename + ':' + error.lineno + '] ' + error.message);
	};
	this.worker = worker;
};

GCD.AsyncWorker.prototype.dispatch_async = function(func, callback, args) {
	this.asyncCount++;
	this.worker.postMessage({'cmd': 'dispatch_async', 'func': func.toString(), 'args': args, 'count': this.asyncCount});
	this.callbacks[this.asyncCount] = callback;
};

GCD.SerialQueue = function() {
	this.worker = new GCD.AsyncWorker(GCD.worker_id++);
};

GCD.SerialQueue.prototype.dispatch_async = function(func, callback, args) {
	this.worker.dispatch_async(func, callback, args);
};


GCD.ConcurrentQueue = function() {
	this.NUM_WORKERS = 4;

	this.workers = [];
	for (var i=0; i<this.NUM_WORKERS; i++)
		this.workers.push(new GCD.AsyncWorker(GCD.worker_id++));

	this.current = 0;
};

GCD.ConcurrentQueue.prototype.dispatch_async = function(func, callback, args) {
	// Simply round-robin scheduling
	this.workers[this.current++].dispatch_async(func, callback, args);
	if (this.current >= this.NUM_WORKERS)
		this.current = 0;
};


GCD.queue = function(isConcurrent) {
	if (isConcurrent)
		this.queue = new GCD.ConcurrentQueue();
	else
		this.queue = new GCD.SerialQueue();
};

GCD.queue.prototype.dispatch_async = function(func, callback, args) {
	this.queue.dispatch_async(func, callback, args);
};

// ----------------------------------------------------------------------------
// Original API
//

// Creating and Managing Queues
//
// dispatch_get_global_queue
// dispatch_get_main_queue
// dispatch_queue_create
// dispatch_get_current_queue
// dispatch_queue_get_label
// dispatch_set_target_queue
// dispatch_main

// Queuing Tasks for Dispatch
//
// dispatch_async
// dispatch_async_f
// dispatch_sync
// dispatch_sync_f
// dispatch_after
// dispatch_after_f
// dispatch_apply
// dispatch_apply_f
// dispatch_once

// Using Dispatch Groups
//
// dispatch_group_async
// dispatch_group_async_f
// dispatch_group_create
// dispatch_group_enter
// dispatch_group_leave
// dispatch_group_notify
// dispatch_group_notify_f
// dispatch_group_wait

// Managing Dispatch Objects
//
// dispatch_debug
// dispatch_get_context
// dispatch_release
// dispatch_resume
// dispatch_retain
// dispatch_set_context
// dispatch_set_finalizer_f
// dispatch_suspend

// Using Semaphores
//
// dispatch_semaphore_create
// dispatch_semaphore_signal
// dispatch_semaphore_wait

// Using Barriers
//
// dispatch_barrier_async
// dispatch_barrier_async_f
// dispatch_barrier_sync
// dispatch_barrier_sync_f

// Managing Dispatch Sources
//
// dispatch_source_cancel
// dispatch_source_create
// dispatch_source_get_data
// dispatch_source_get_handle
// dispatch_source_get_mask
// dispatch_source_merge_data
// dispatch_source_set_registration_handler
// dispatch_source_set_registration_handler_f
// dispatch_source_set_cancel_handler
// dispatch_source_set_cancel_handler_f
// dispatch_source_set_event_handler
// dispatch_source_set_event_handler_f
// dispatch_source_set_timer
// dispatch_source_testcancel

// Using the Dispatch I/O Convenience API
//
// dispatch_read
// dispatch_write

// Using the Dispatch I/O Channel API
//
// dispatch_io_create
// dispatch_io_create_with_path
// dispatch_io_read
// dispatch_io_write
// dispatch_io_close
// dispatch_io_set_high_water
// dispatch_io_set_low_water
// dispatch_io_set_interval

// Managing Dispatch Data Objects
//
// dispatch_data_create
// dispatch_data_get_size
// dispatch_data_create_map
// dispatch_data_create_concat
// dispatch_data_create_subrange
// dispatch_data_apply
// dispatch_data_copy_region

// Managing Time
//
// dispatch_time
// dispatch_walltime

// Managing Queue-Specific Context Data
//
// dispatch_queue_set_specific
// dispatch_queue_get_specific
// dispatch_get_specific