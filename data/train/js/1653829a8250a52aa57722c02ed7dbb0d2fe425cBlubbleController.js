exports.BlubbleController = function(blubble){
	var blubbleController = {};
	blubbleController.Blubble = blubble;
	blubbleController.PhotoPadController = require('controller/PhotoPadController').PhotoPadController(blubble);
	blubbleController.MusicPadController = require('controller/MusicPadController').MusicPadController(blubble);
	blubbleController.VideoPadController = require('controller/VideoPadController').VideoPadController(blubble);
	blubbleController.GamePadController = require('controller/GamePadController').GamePadController(blubble);
	blubbleController.DevicePadController = require('controller/DevicePadController').DevicePadController(blubble);
	return blubbleController;
};