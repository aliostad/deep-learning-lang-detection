var invariant = require('./lib/invariant');
var warning = require('./lib/warning');

var QueuedDispatcher = {
	construct() {
		this.__dispatchQueue__ = [];
	},
	
	willDispatch(action, params, dispatch) {
		if (this.isDispatching()) {
			warning(
				!this.isDispatching(),
				'Dispatcher.dispatch(...): Cascading dispatch detected. \n' +
				`You have tried to dispatch an action of type '${action}' while simultaneously dispatching an action of type '${this.currentDispatch.action}'. ` +
				'This action will be queued until the pending payload has finished dispatching. ' +
				'Actions should avoid cascading updates wherever possible.'
			);

			return this.queueDispatch(action, params);
		}
		dispatch();
	},
	
	queueDispatch(action, params) {
		if (!this.isDispatching()) {
			this.dispatch(action, params)
		}
		this.__dispatchQueue__.push({action, params})
	},
	
	flushQueue() {
		var queued;
		while(queued = this.__dispatchQueue__.pop())
			this.dispatch(queued.action, queued.params);
	},
	
	endDispatch() {
		this.flushQueue();
	},
}

module.exports = QueuedDispatcher;