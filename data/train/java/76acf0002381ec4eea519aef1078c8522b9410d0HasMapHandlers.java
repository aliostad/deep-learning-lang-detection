package com.davvo.visakarta.client.event;

import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.event.shared.HasHandlers;

public interface HasMapHandlers extends HasHandlers {

    public HandlerRegistration addMapMovedHandler(MapMovedHandler handler);
    
    public HandlerRegistration addMarkerMovedHandler(MarkerMovedHandler handler);
    
    public HandlerRegistration addMarkerClickedHandler(MarkerClickedHandler handler);
    
    public HandlerRegistration addMapTypeChanged(MapTypeChangedHandler handler);
        
}
