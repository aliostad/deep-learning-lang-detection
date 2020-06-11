
//
// FileControl audio viewer
//
Ui.LBox.extend('KJing.AudioControllerViewer', {
	controller: undefined,
	mediaController: undefined,
	mediaBar: undefined,

	constructor: function(config) {
		this.controller = config.controller;
		delete(config.controller);

		this.mediaController = new KJing.MediaController({ controller: this.controller, verticalAlign: 'top', horizontalAlign: 'left', width: 0, height: 0 });
		this.append(this.mediaController);
		this.mediaBar = new KJing.MediaPlayBar({ media: this.mediaController, verticalAlign: 'bottom' });
		this.append(this.mediaBar);
	}
});

KJing.ResourceControllerViewer.register('file:audio', KJing.AudioControllerViewer);
