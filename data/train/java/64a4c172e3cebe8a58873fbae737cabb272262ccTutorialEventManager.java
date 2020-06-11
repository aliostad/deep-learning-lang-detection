package com.eaw1805.www.client.events.tutorial;

import com.google.gwt.event.shared.HandlerManager;


public final class TutorialEventManager {
    static public HandlerManager handlerManager = new HandlerManager(null);

    public static void PositionClicked(final int x, final int y) {
        handlerManager.fireEvent(new PositionClickedEvent(x,y));
    }

    public static void addPositionClickedHandler(final PositionClickedHandler handler) {
        handlerManager.addHandler(PositionClickedEvent.getType(), handler);
    }

    public static void removePositionClickedHandler(final PositionClickedHandler handler) {
        handlerManager.removeHandler(PositionClickedEvent.getType(), handler);
    }
}
