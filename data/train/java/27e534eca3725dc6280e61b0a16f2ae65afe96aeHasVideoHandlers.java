package gwt.html5.video.client.handlers;

import com.google.gwt.event.shared.HandlerRegistration;

public interface HasVideoHandlers {
    HandlerRegistration addAbortHandler(VideoAbortHandler abortHandler);

    HandlerRegistration addCanPlayHandler(VideoCanPlayHandler canPlayHandler);

    HandlerRegistration addCanPlayThroughHandler(VideoCanPlayThroughHandler canPlayThroughHandler);

    HandlerRegistration addDurationChangeHandler(VideoDurationChangeHandler durationChangeHandler);

    HandlerRegistration addEmptyHandler(VideoEmptyHandler emptyHandler);

    HandlerRegistration addEndedHandler(VideoEndedHandler endedHandler);

    HandlerRegistration addErrorHandler(VideoErrorHandler errorHandler);

    HandlerRegistration addLoadDataHandler(VideoLoadDataHandler loadDataHandler);

    HandlerRegistration addLoadMetadataHandler(VideoLoadMetadataHandler loadMetadataHandler);

    HandlerRegistration addLoadStartHandler(VideoLoadStartHandler loadStartHandler);

    HandlerRegistration addPauseHanlder(VideoPauseHandler pauseHandler);

    HandlerRegistration addPlayHandler(VideoPlayHandler playHandler);

    HandlerRegistration addPlayingHandler(VideoPlayingHandler playingHandler);

    HandlerRegistration addProgressHandler(VideoProgressHandler progressHandler);

    HandlerRegistration addRateChangeHandler(VideoRateChangeHandler rateChangeHandler);

    HandlerRegistration addSeekedHandler(VideoSeekedHandler seekedHandler);

    HandlerRegistration addSeekingHandler(VideoSeekingHandler seekingHandler);

    HandlerRegistration addStalledHandler(VideoStalledHandler stalledHandler);

    HandlerRegistration addSuspendHandler(VideoSuspendHandler suspendHandler);

    HandlerRegistration addTimeUpdateHandler(VideoTimeUpdateHandler timeUpdateHandler);

    HandlerRegistration addVolumeChangeHandler(VideoVolumeChangeHandler volumeChangeHandler);

    HandlerRegistration addWaitingHandler(VideoWaitingHandler waitingHandler);
}
