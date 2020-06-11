class RoomController {
  constructor(webrtcService, eventService, audioService, mediaService) {
    Object.assign(this, {
      webrtcService,
      eventService,
      audioService,
      mediaService
    });
  }
  init(element) {
    this.eventService.onRoomReady(() => {
      this.audioService.start();
    });

    this.webrtcService.init(element);
  }
  focus(id){
    this.mediaService.focus(id);
  }
  fullscreen(id){
    this.mediaService.fullscreen(id);
  }
}

RoomController.$inject = ['webrtcService', 'eventService', 'audioService', 'mediaService'];
angular.module('teamTalk.room').controller('RoomController', RoomController);
