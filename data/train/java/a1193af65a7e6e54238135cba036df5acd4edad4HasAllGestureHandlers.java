package de.fuberlin.mindmap2d.client.touch.events;

import com.google.gwt.event.shared.HandlerRegistration;


public interface HasAllGestureHandlers {
	/**
	   * Adds a {@link DoubleTapGestureHandler} handler.
	   * 
	   * @param handler the double tap gesture handler
	   * @return {@link DoubleTapGestureHandler} used to remove this handler
	   */
	  HandlerRegistration addDoubleTapGestureHandler(DoubleTapGestureHandler handler);
	 
	  /**
	   * Adds a {@link HoldAndTapGestureHandler} handler.
	   * 
	   * @param handler the hold and tap gesture handler
	   * @return {@link HoldAndTapGestureHandler} used to remove this handler
	   */
	  HandlerRegistration addHoldAndTapGestureHandler(HoldAndTapGestureHandler handler);
	  
	  /**
	   * Adds a {@link MoveGestureHandler} handler.
	   * 
	   * @param handler the move gesture handler
	   * @return {@link MoveGestureHandler} used to remove this handler
	   */
	  HandlerRegistration addMoveGestureHandler(MoveGestureHandler handler);
	  
	  /**
	   * Adds a {@link PullOutGestureHandler} handler.
	   * 
	   * @param handler the pull gesture handler
	   * @return {@link PullOutGestureHandler} used to remove this handler
	   */
	  HandlerRegistration addPullOutGestureHandler(PullOutGestureHandler handler);
	  
	  /**
	   * Adds a {@link PushInGestureHandler} handler.
	   * 
	   * @param handler the push gesture handler
	   * @return {@link PushInGestureHandler} used to remove this handler
	   */
	  HandlerRegistration addPushInGestureHandler(PushInGestureHandler handler);
	  
	  /**
	   * Adds a {@link TapGestureHandler} handler.
	   * 
	   * @param handler the tap gesture handler
	   * @return {@link TapGestureHandler} used to remove this handler
	   */
	  HandlerRegistration addTapGestureHandler(TapGestureHandler handler);
	  
	  /**
	   * Adds a {@link ZoomInGestureHandler} handler.
	   * 
	   * @param handler the zoom in gesture handler
	   * @return {@link ZoomInGestureHandler} used to remove this handler
	   */
	  HandlerRegistration addZoomInGestureHandler(ZoomInGestureHandler handler);
	  
	  /**
	   * Adds a {@link ZoomOutGestureHandler} handler.
	   * 
	   * @param handler the zoom out gesture handler
	   * @return {@link ZoomOutGestureHandler} used to remove this handler
	   */
	  HandlerRegistration addZoomOutGestureHandler(ZoomOutGestureHandler handler);
}
