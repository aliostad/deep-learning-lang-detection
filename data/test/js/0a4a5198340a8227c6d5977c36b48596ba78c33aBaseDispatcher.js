var invariant = require('./lib/invariant');
var BaseDispatchCycle = require('./BaseDispatchCycle');

var IS_DISPATCHING = false;

class BaseDispatcher {
	constructor(registry) {
		this.registry = registry;
	}

	isDispatching() {
		return IS_DISPATCHING;
	}

	register(cb) {
		return this.registry.register(cb);
	}

	unregister(id) {
		return this.registry.unregister(id);
	}

	waitFor(...ids) {
		invariant(
			IS_DISPATCHING || !this.currentDispatch,
			'Dispatcher.waitFor(...): Cannot call waitFor while not currently dispatching.'
		);

		ids.forEach((id) => {
			invariant(
				!this.currentDispatch.isPending(id),
				`Dispatcher.waitFor(...): Circular dependency detected while waiting for ${id}`
			);

			invariant(
				this.registry.has(id),
				`Dispatcher.waitFor(...): ${id} does not map to a registered dispatch table.`
			);

			if (this.currentDispatch.isHandled(id)) {
				// we've already handled this dispatch during the current round - move on.
				return;
			}

			this.currentDispatch.dispatchTo(id, this.registry.get(id));
		});
	}

	dispatch(action, params) {
		this.willDispatch(action, params, () => {
			this.startDispatch(action, params, (currentDispatch) => {
				IS_DISPATCHING = true;
				this.currentDispatch = currentDispatch;
				this.currentDispatch.start({action, params});
				var entries = this.registry.getAll();
				try {
					for (var id in entries) {
						currentDispatch.dispatchTo(id, entries[id]);
					}

				} finally {
					IS_DISPATCHING = false;
					this.endDispatch(this.currentDispatch);
					this.currentDispatch = null;
				}
			});
		});
	}

	startDispatch(action, params, start) {
		start(new BaseDispatchCycle());
	}
}

module.exports = BaseDispatcher;