(ns puppetlabs.experimental.websockets.client)

(defprotocol WebSocketProtocol
  "Functions to manage the lifecycle of a websocket session"
  (idle-timeout! [this ms]
    "Set the idle timeout for the session, in milliseconds")
  (connected? [this]
    "Returns a boolean indicating if the session is currently connected")
  (send! [this msg]
    "Send a message to the websocket client")
  (close! [this] [this code reason]
    "Close the websocket session.")
  (remote-addr [this]
    "Find the remote address of a websocket client")
  (ssl? [this]
    "Returns a boolean indicating if the session was established by wss://")
  (peer-certs [this]
    "Returns an array of X509Certs presented by the ssl peer, if any")
  (request-path [this]
    "Returns the URI path used in the websocket upgrade request to the server"))
