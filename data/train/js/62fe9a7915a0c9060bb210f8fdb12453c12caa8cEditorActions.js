import Actions from './Actions';

export default
class EditorActions extends Actions {

	static reset() {
		super.dispatch('EditorReset', arguments);
	}

	static load(file) {
		super.dispatch('EditorLoad', arguments);
	}

	static update(code) {
		super.dispatch('EditorUpdate', arguments);
	}

	static run() {
		super.dispatch('EditorRun', arguments);
	}

	static abort() {
		super.dispatch('EditorAbort', arguments);
	}

	static receiveRunning() {
		super.dispatch('EditorReceiveRunning', arguments);
	}

	static receiveSuccess(status, warnings) {
		super.dispatch('EditorReceiveSuccess', arguments);
	}

	static receiveError(message) {
		super.dispatch('EditorReceiveError', arguments);
	}

	static receiveCode(code) {
		super.dispatch('EditorReceiveCode', arguments);
	}

	static updateFilter(filter) {
		super.dispatch('EditorUpdateFilter', arguments);
	}

	static receiveExamples(examples) {
		super.dispatch('EditorReceiveExamples', arguments);
	}

	static toggleGroup(group) {
		super.dispatch('EditorToggleGroup', arguments);
	}

	static upload(file) {
		var fileTypes = [
			"text/plain"   ,
			"text/x-c++src",
			"text/x-csrc"  ,
			"text/x-chdr"  ,
			"text/x-c++hdr",
		];


		if (fileTypes.indexOf(file.type) < 0)
			return;

		if(file.size > 1000000) 
			return;

		super.dispatch('EditorUpload', arguments);
	}
}
