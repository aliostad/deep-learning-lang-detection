import * as actions from '../Message'

describe('actions', () => {

	it('should create an action to reset error message', () => {
		expect(actions.resetErrorMessage()).toEqual({
			type: actions.RESET_ERROR_MESSAGE,
		});
	});

	it('should create an action to show normal message', () => {
		expect(actions.showMessage('Message ABC')).toEqual({
			type: actions.SHOW_MESSAGE,
			message: 'Message ABC',
		});
	});

	it('should create an action to show error message', () => {
		expect(actions.showErrorMessage('Error Message ABC')).toEqual({
			type: actions.SHOW_ERROR_MESSAGE,
			message: 'Error Message ABC',
		});
	});

});
