package com.teknonsys.twilio.client.event;

import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.event.shared.HasHandlers;

public interface HasDeviceHandlers extends HasHandlers
  {
  HandlerRegistration addDeviceReadyHandler(DeviceReadyHandler handler);
  HandlerRegistration addDeviceOfflineHandler(DeviceOfflineHandler handler);
  HandlerRegistration addIncomingConnectionHandler(IncomingConnectionHandler handler);
  HandlerRegistration addConnectionCanceledHandler(ConnectionCanceledHandler handler);
  HandlerRegistration addConnectionEstablishedHandler(ConnectionEstablishedHandler handler);
  HandlerRegistration addDisconnectHandler(DisconnectHandler handler);
  HandlerRegistration addPresenceHandler(PresenceHandler handler);
  HandlerRegistration addErrorHandler(ErrorHandler handler);
  }