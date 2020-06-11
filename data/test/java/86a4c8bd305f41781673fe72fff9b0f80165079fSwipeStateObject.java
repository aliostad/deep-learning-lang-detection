package net.peakgames.erkan.sandbox;

public class SwipeStateObject {

    public SwipeHandler currentSwipeHandler;
    public SwipeHandler prevSwipeHandler;

    public SwipeStateObject() {

    }

    public void itemStartedToSwipe(SwipeHandler newHandler) {
        if (currentSwipeHandler == null) {
            currentSwipeHandler = newHandler;
            return;
        }

        if (currentSwipeHandler == newHandler) {
            return;
        }

        if (prevSwipeHandler != null) {
            prevSwipeHandler.resetViewPositionWithAnim();
        }

        prevSwipeHandler = currentSwipeHandler;
        currentSwipeHandler = newHandler;
    }

    public void setOpenedHandler (SwipeHandler swipeHandler) {
        if (currentSwipeHandler != null && currentSwipeHandler != swipeHandler) {
            currentSwipeHandler.resetViewPositionWithAnim();
        }
        currentSwipeHandler = swipeHandler;
    }
}
