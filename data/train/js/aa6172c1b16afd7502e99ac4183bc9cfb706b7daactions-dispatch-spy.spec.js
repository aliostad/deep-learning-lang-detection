'use strict';
jest.dontMock('../../lib/spy');
jest.dontMock('../../lib/actions-dispatch-spy');
describe('Lib.ActionsDispatchSpy', function() {
	var Spy, ActionsDispatchSpy;
	beforeEach(function() {
		Spy = require('../../lib/spy');
		ActionsDispatchSpy = require('../../lib/actions-dispatch-spy');
	});
	describe('result when instantiated with dispatch binder', function() {
		var dispatchBinder, spy;
		beforeEach(function() {
			dispatchBinder = {};
			spy = new ActionsDispatchSpy(dispatchBinder);
		});
		it('should be an instance of Spy', function() {
			expect(spy instanceof Spy).toBe(true);
		});
		it('when dispatchBinder.dispatch() called with params, should update .__calls__', function() {
			dispatchBinder.dispatch('foo', 'bar');
			expect(spy.__calls__).toEqual([ ['foo', 'bar'] ]);
		});
	});
});
