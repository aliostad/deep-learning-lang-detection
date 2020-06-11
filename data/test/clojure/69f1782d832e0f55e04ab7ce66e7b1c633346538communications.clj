(ns frereth-renderer.communications
  (:require   ; [byte-streams :as streams]
            [clojure.core.async :as async]
            [clojure.pprint :refer (pprint)]
            ;;[clojurewerkz.buffy.core :as buffy]
            [com.stuartsierra.component :as component]
            [plumbing.core :as pc :refer (defnk)]
            [ribol.core :refer (escalate manage on raise raise-on)]
            [schema.core :as s]
            [taoensso.timbre :as log]
            [zeromq.zmq :as mq])
  (:import [org.zeromq ZMQ$Context])
  (:gen-class))

(set! *warn-on-reflection* true)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Schema

;; It seems like there really should be a base class that's
;; less implementation-specific.
;; There doesn't seem to be. Oh well.
(s/defrecord Channels [ui :- clojure.core.async.impl.channels.ManyToManyChannel
                       uo :- clojure.core.async.impl.channels.ManyToManyChannel
                       cmd :- clojure.core.async.impl.channels.ManyToManyChannel
                       terminator :- clojure.core.async.impl.channels.ManyToManyChannel]
  component/Lifecycle
  (start
    [this]
    (into this {:ui (async/chan)
                :uo (async/chan)
                :cmd (async/chan)
                :terminator (async/chan)}))
  (stop
    [this]
    (log/info "Stopping communications system")
    (if cmd
      (do
        ;; Do this, to stop both the i/o threads
        (log/debug "Commanding r/w threads to quit")
        ;; TODO: Should really count up the threads in the coupler and
        ;; send one exit message to each.
        ;; Pretty solidly qualifies as YAGNI.
        ;; Actually, should send this off to individual r/w threads. With a timeout
        ;; in case that thread doesn't exist. Except that there doesn't seem to be
        ;; an equivalent to timeouts when it comes to sending.
        (async/>!! cmd :exit)
        (log/debug "First exit command sent")
        (async/>!! cmd :exit)
        (log/debug "Second exit command sent")
        ;; Though it would be cleaner to just close this channel and
        ;; make them smart enough to understand what that means.
        ;; TODO: Make that work.
        (async/close! cmd)
        (log/debug "Exiting messages sent"))
      (log/warn "Missing command channel from client"))
    (doseq [c [ui uo cmd terminator]]
      (when c
        (async/close! c)))
    (async/>!! terminator :exiting)
    (into this {:ui nil
                :uo nil
                :cmd nil
                :terminator nil})))

(s/defrecord Context [context :- ZMQ$Context]
  component/Lifecycle
  (start
    [this]
    (assoc this :context (mq/context 1)))
  (stop
    [this]
    ;; Do need to make sure the sockets are all closed first.
    ;; Which seems to mean joining the i/o threads in :coupling
    (.close ^ZMQ$Context (:context this))  ; TODO: Getting a compiler warning about reflection ??
    (assoc this :context nil)))

;; These are actually both async/thread instances
(def coupler-map {ui->client s/Any
                  client-ui s/Any})

(declare couple)
(s/defrecord Coupling [coupling :- coupler-map
                       context :- Context
                       channels :- Channels]
  component/Lifecycle
  (start
   [this]
   ;; Need an async channel that uses this socket
   ;; to communicate back and forth with the graphics namespace
   ;; to actually implement the UI.
   ;; This is what I've come up with so far
   (assoc this :coupling (couple (:context context)
                                 (:ui channels)
                                 (:uo channels)
                                 (:cmd channels))))
  (stop
   [this]
   (into this {:coupling nil
               :context nil
               :channels nil})))

(s/defrecord URI [protocol :- s/Str
                address :- s/Str
                port :- s/Int]
  component/Lifecycle
  (start [this] this)
  (stop [this] this))

(s/defrecord ClientUrl [uri :- URI]
  component/Lifecycle
  (start [this] this)
  (stop [this] this))

(declare build-url)
(s/defrecord ClientSocket [context :- Context
                            socket  ; Something like a ZMQ$Socket...depends on the underlying library
                            url :- ClientUrl]
  component/Lifecycle
  (start
   [this]
   (log/info "Starting Client Socket to: "
             (with-out-str (pprint  url))
             "\nout of:"
             (with-out-str (pprint this)))
   (try
     ;; Q: Is this really a dealer?
     ;; A: Yes. It should only connect to one client's Router,
     ;; but the messaging is still asynchronous.
     ;; And we don't care where the messages go.
     (let [sock (mq/socket (:context context) :dealer)
           real-url (build-url (:uri url))]
       (try
         (mq/connect sock real-url)
         (catch RuntimeException ex
           (raise [:client-socket-connection-error
                   {:reason ex
                    :details this
                    :url real-url
                    :socket sock}])))
       (assoc this :socket sock))
     (catch RuntimeException ex
       (log/error ex)
       (raise [:client-socket-creation-failure
               {:reason ex}]))))
  (stop
   [this]
   (mq/disconnect socket (build-url (:uri url)))
   (mq/set-linger socket 0)
   (mq/close socket)
   (assoc this :socket nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Utilities

(defn client->ui-hand-shake
  "This is really the response part of the handshake that was initiated
sometime during ui->client.

It feels backwards, but it really does make basic sense:
Client SENDs a \"whatcha got?\" message when it's ready for input, then
sits around waiting patiently for a response.

Of course, that approach is dumb on the client side: it really needs to deal
with timeouts, exit messages, etc. But I need something basic working before
I try to handle edge cases."
  [sock]
  (let [msg (mq/receive sock)]
    ;; TODO: Really should verify that messages contents. For details like
    ;; protocol, version, etc.
    (mq/send sock :PONG)))

(defn client->ui-loop [reader-sock ->ui cmd r->w w->r]
  ;; TODO: I really want to manage these exceptions right here, if at all possible.
  (raise-on [NullPointerException :zmq-npe
             Throwable :unknown]
            (loop []
              ;; The vast majority of the time, this should be throwing
              ;; an Again exception.
              ;; Realistically, should be doing a Poll instead of a Read.
              ;; Or maybe a Read w/ a timeout.
              ;; Q: how's the language wrapper set up?
              (let [msg (mq/receive reader-sock :dont-wait)]
                (when msg
                  (raise-on [Exception :async-fail]
                            ;; This is really happening inside a go block. Who cares?
                            (async/>!! ->ui msg))))
              ;; Check for incoming async messages.
              ;; TODO: really should be able to poll all this at once. Though that may
              ;; really mean delving into internals that should not be dredged.
              ;; Especially in APIs that are this volatile
              (let [to (async/timeout 1)]
                (let [[v ch] (async/alts!! [cmd w->r to])]
                  (condp = ch
                    to (recur)
                    w->r (do
                           ;; This is really just around because I keep running into issues where I need these
                           ;; channels to communicate. There isn't anything specific here yet, so this qualifies
                           ;; as YAGNI...but not doing it would count as premature optimization.
                           (throw (RuntimeException. "What does a writer->reader direct message actually mean?")))
                    (do
                      ;; Received a message from cmd
                      (log/info "cmd message: Assume this means exit gracefully"))))))))

(defn client->ui
  "Invoke thread that receives messages from the client and forwards 
them to...somewhere else.
At this point, the Client Heartbeat handler probably makes as much sense
as anything else.
ctx is the 0mq messaging context
->ui is the core.async channel where events go out.
cmd is the command/control channel that lets us know when it's time to quit.

It's very tempting to have ->ui messages go to the client-heartbeat thread,
but that's an oversimplification. Unless we pull more sockets into the
picture.

Or maybe that's perfect. What could possibly know more about what to do with
any given message than the FSM (which is where those messages go).

Then again, why not just send these messages directly to the FSM and eliminate
the whole client-heartbeat thread thing?"
  [ctx ->ui cmd r->w w->r]
  ;; Subscribe to server events from the client
  (manage
   ;; TODO: Allow binding to external addresses. Though we should really
   ;; reject a client coming in from the wrong place. That really gets
   ;; into encrypted sockets and white-list auth.
   ;; Of course, it's also for remote clients/renderers. Which is definitely
   ;; a "future version" feature.
   (let [socket (mq/socket ctx :rep)
         ;; TODO: This really needs to be * if I'm going to deal
         ;; with remote clients
         ;; Or switch to inproc, if that's a different middleware
         ;; layer sort of thing.
         ;; Either way, this approach is wrong.
         port (mq/bind-random-port socket "tcp://127.0.0.1")]
     ;; Let the input thread know which port this is listening on.
     (log/info "Telling the Client to connect on port: " port)
     (async/>!! r->w port)
     (log/debug "Shaking hands with client")
     (client->ui-hand-shake socket)
     (log/info "Entering Read Thread on socket " ->ui)
     (client->ui-loop socket ->ui cmd))
   (on :zmq-npe [ex]
       ;; Debugging...what makes more sense instead?
       (escalate ex))))

(defn ui->client-loop
  "Read messages from the actual UI and forward them to the Client.
ui-> is the async socket to receive those messages.
cmd is the async command channel used to pass control messages into this thread.
->client is the 0mq socket to the client."
  [ui-> cmd ->client r->w w->r]
  (log/debug "Entering ui->client message loog")
  (loop [to (async/timeout 60)] ; TODO: How long to wait?
    (let [[v ch] (async/alts!! [ui-> cmd r->w to])]
      (condp = ch
        ;; TODO: Should probably look into processing
        ;; this message.
        ui-> (do
               (log/debug "UI message for client:\n" v)
               (mq/send ->client v)
               (let [ack (mq/receive ->client)]
                 (log/debug ack)))
        r->w (do
               ;; This channel was put in place originally so the 'reader' can tell this
               ;; thread which port it's listening on, so this 'writer' thread can inform
               ;; the client.
               (log/error "Reader communicating with writer:\n" v)
               (throw (RuntimeException. "I don't have a clue how to deal with this")))
        cmd (do
              (log/debug v)
              ;; The most obvious possibility here is the command to exit.
              ;; Q: Do I want to put a 'done' flag in an atom to exit?
              (throw
               (RuntimeException. "Received message over command channel.
Need to handle this.")))
        to nil
        ;; TODO: Check some flag to determine whether we're done.
        ;; That should really be signalled by cmd returning nil.
        ;; So, honestly, we don't care about this timeout.
        ))
    (recur (async/timeout 60))))

(defn ui->client
  "Push user events to the client to forward along to the server(s)
  Using a REQ socket here seems at least a little dubious. The alternatives
  that spring to mind seem worse. I send input to the Client over this channel,
  it returns an ACK. Any real feedback comes over the client->ui socket.
  This approach fails in that I really need to kill and recreate the socket
  when the communication times out.
  That approach fails in that I need to get *something* working before I
  start worrying about things like error handling."
  [ctx from-ui cmd r->w w->r]
  (let [writer-sock (mq/socket ctx :dealer)
        url "tcp://127.0.0.1:7842"]  ; TODO: magic strings are evil
    (try
      (mq/connect writer-sock url)
      (try
        (log/debug "Waiting for reader thread to share its port")
        (let [reader-port (async/<!! r->w)]
          (log/info "Pushing HELO to client, listening on port " reader-port)
          (try
            (mq/send writer-sock (.getBytes ":helo") (:send-more mq/socket-options))
            (catch java.lang.ClassCastException ex
              (log/error ex "Trying to send HELO")
              (raise [:handshake-failure
                      :reason ex])))

          ;; Trigger the client to connect to the socket bound in the
          ;; client->ui thread

          (comment (log/warn "Use protocol buffers instead")
                   (let [port-spec (buffy/spec :port (buffy/short-type))
                         buffer (buffy/compose-buffer port-spec)]
                     (buffy/set-field buffer :port reader-port)
                     (mq/send writer-sock buffer)))
          (mq/send writer-sock (.getBytes (pr-str {:port reader-port})))
          (log/debug "Client accepted the HELO. Waiting for an ACK...")
          ;; Getting to here. Values getting horribly mangled in transmission.
          (log/warn "FIXME: Make sure this works")
          ;; FIXME: Start here!
          ;; Wait for the other side of the hand-shake
          (let [ack (mq/receive writer-sock)]
            (log/debug (str "Handshake:\n" ack)))
          (ui->client-loop from-ui cmd writer-sock r->w w->r))
        (finally
          (mq/disconnect writer-sock url)))
      (finally 
        (mq/set-linger writer-sock 0)
        (mq/close writer-sock)))))

(s/defn couple
  "Need to read from both the UI (keyboard, mouse, etc) and the client socket
that's relaying messages from the server.

Gets more complicated when we start talking about multiple servers, but that's
YAGNI for this version.

This should be low-hanging fruit, but it's actually looking like some pretty hefty
meat."
  [ctx :- ZMQ$Context
   from-ui :- clojure.core.async.impl.channels.ManyToManyChannel
   to-ui :- clojure.core.async.impl.channels.ManyToManyChannel
   cmd :- clojure.core.async.impl.channels.ManyToManyChannel]
  (let [ ;; read/write threads really need the capability to communicate
        r->w (async/chan)
        w->r (async/chan)
        writer-thread (async/thread (ui->client ctx from-ui cmd r->w w->r))
        reader-thread (async/thread (client->ui ctx to-ui cmd r->w w->r))]
    (log/info "Background threads created")
    {:ui->client writer-thread
     :client->ui reader-thread}))

(s/defn build-url
  "This is pretty naive.
But works for my purposes"
  [{:keys [protocol address port] :as uri} :- URI]
  (log/info "Building a url based on:\n" (with-out-str (pprint uri)))
  (str protocol "://" address ":" port))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Public

(defn new-channels
  []
  (map->Channels {}))

(defn new-client-socket
  [cfg]
  ;; Specifying the context and socket should really be rare enough
  ;; that I just take those options away.
  (map->ClientSocket (cond-> {}
                       (:context cfg) (assoc :context (:context cfg))
                       (:socket cfg) (assoc :socket (:socket cfg))
                       (:url cfg) (assoc :url (:url cfg)))))

;; This next line's failing because I'm missing schema.core/fn.
;; Q: What's the problem?
(defn new-client-url
  [{:keys [client-url]}]
  (let [params (get-in client-url [:protocol :address :port])
        uri (strict-map->URI params)]
    (log/info "Initial client URL: " (with-out-str (pprint params)))
    (strict-map->ClientUrl {:uri uri})))

(defn new-context
  []
  (map->Context {}))

(defn new-coupling
  []
  (map->Coupling {}))
