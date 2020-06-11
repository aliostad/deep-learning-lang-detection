package com.inepex.ineFrame.client.misc;

import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.user.client.ui.LayoutPanel;

public class HandlerAwareLayoutPanel extends LayoutPanel {

    private HandlerHandler handlerHandler = new HandlerHandler();

    public void registerHandler(HandlerRegistration handlerRegistration) {
        handlerHandler.registerHandler(handlerRegistration);
    }

    @Override
    protected void onDetach() {
        handlerHandler.unregister();
        super.onDetach();
    }
}
