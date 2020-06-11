;; # Web Server (Ring) functions
;;
;; This namespace manage the web server functionalities
;; including request dispatch, session management,
;; websocket/ajax calls, logon in addition to blackjack
;; related functionalities.
;;
;; The namespace uses `http-kit` as web server, `compojure` as
;; request routing engine, `hiccup` for generating html code,
;; `sente` for async websocket messaging plus the basing `ring`
;; middlewares.
(ns data15-blackjack.server
  (:require
    [ring.middleware.resource :as resources]
    [clojure.string :as str]
    [ring.middleware.defaults]
    [compojure.core :as comp :refer (defroutes GET POST)]
    [compojure.route :as route]
    [hiccup.core :as hiccup]
    [hiccup.page :refer (include-js include-css)]
    [clojure.core.async :as async :refer (<! <!! >! >!! put! chan go go-loop)]
    [taoensso.encore :as encore :refer ()]
    [taoensso.timbre :as timbre :refer (tracef debugf infof warnf errorf)]
    [taoensso.sente :as sente]
    [org.httpkit.server :as http-kit]
    [taoensso.sente.server-adapters.http-kit :refer (sente-web-server-adapter)]
    [data15-blackjack.blackjack :as blackjack])
  (:gen-class))

;; Logging config. The more the better.
(sente/set-logging-level! :trace)

(defn start-web-server!*
  "Start our fancy `http-kit` web server. Port is 3000 by default. This
  web server will serve our html pages, provide logon and session management
  and manage web socket based async channels."
  [ring-handler port]
  (println "Starting http-kit...")
  (let [http-kit-stop-fn (http-kit/run-server ring-handler {:port port})]
    {:server  nil                                           ; http-kit doesn't expose this
     :port    (:local-port (meta http-kit-stop-fn))
     :stop-fn (fn [] (http-kit-stop-fn :timeout 100))}))

;; -------------------------------------------------
;; ## Server-side setup

;; Register async channels used for the communication. The directly used
;; defs are:
;;
;; * `ch-chsk` - Receive channel
;; * `chsk-send!` - Send API function
;; * `connected-uids` - Watchable, readonly atom. This store all client ids. We
;; use this structure to send broadcast messages to all clients.
(let [{:keys [ch-recv send-fn ajax-post-fn ajax-get-or-ws-handshake-fn
              connected-uids]}
      (sente/make-channel-socket! sente-web-server-adapter {:packer :edn})]
  (def ring-ajax-post ajax-post-fn)
  (def ring-ajax-get-or-ws-handshake ajax-get-or-ws-handshake-fn)
  (def ch-chsk ch-recv)                                     ; ChannelSocket's receive channel
  (def chsk-send! send-fn)                                  ; ChannelSocket's send API fn
  (def connected-uids connected-uids))                      ; Watchable, read-only atom

(defn number-of-connected-users
  "Number of identified users connected"
  []
  (count (filter #(not= :taoensso.sente/nil-uid %) (:any @connected-uids))))

;; ----------------------------
;; # Ring Handlers

(defn login!
  "Login methods sets the user name. No real login, just associate the username with
  the websocket. Later on this user-id will be used to send messages to one client only"
  [ring-request]
  (let [{:keys [session params]} ring-request
        {:keys [role user-id]} params]
    (debugf "Login request: %s" params)
    (blackjack/set-player-name! role user-id)
    {:status 200 :session (assoc session :role role :uid user-id)}))

(defn landing-pg-handler
  "Langing page containing the tableau JS API vizardry. This is the main HTML
  page serving requests hitting the `/` URL. HTML is generated thru hiccup library"
  [_]
  (hiccup/html
    [:head
     (include-js "http://public.tableau.com/javascripts/api/tableau-2.0.1.min.js")
     (include-css "css/page.css")]
    [:div#debug]
    [:div#tableau-viz]
    [:div#div-login
     [:h2 "Set user user-id"]
     [:p [:input#input-login {:type :text :placeholder "Enter your name:"}]
      [:button#btn-player1 {:class "login-button" :type "button"} "I'm Player 1"]
      [:button#btn-player2 {:class "login-button" :type "button"} "I'm Player 2"]]]
    [:p#game-buttons
     [:button#btn-hit {:class "game-button" :type "button"} "hit"]
     [:button#btn-stand {:class "game-button" :type "button"} "stand"]
     [:button#btn-reset {:class "game-button" :type "button"} "new"]]
    [:script {:src "js/client.js"}]))                       ; Include our cljs target

(defroutes my-routes
           "Basic endpoints:

           * `/`      langing page,
           * `/chsh`  sente channels,
           * `/login` to set user name
           * plus the usual static resources"
           (GET "/" req (landing-pg-handler req))
           ;;
           (GET "/chsk" req (ring-ajax-get-or-ws-handshake req))
           (POST "/chsk" req (ring-ajax-post req))
           (POST "/login" req (login! req))
           ;;
           (route/resources "/")                            ; Static files, notably public/js/client.js (our cljs target)
           (route/not-found (hiccup/html
                              [:h1 "Invalid URL"])))

(def my-ring-handler
  "The ring handler is reponsible to start ring web server, setup routing
  and session management default"
  (let [ring-defaults-config
        (assoc-in ring.middleware.defaults/site-defaults [:security :anti-forgery]
                  {:read-token (fn [req] (-> req :params :csrf-token))})]
    (ring.middleware.defaults/wrap-defaults my-routes ring-defaults-config)))

;; ----------------------------------------------------------------------------
;; # Routing handlers

(defn server->all-users!
  "Send message to all connected, authenticated users"
  [message]
  (doseq [uid (:any @connected-uids)]
    (when-not (= uid :sente/nil-uid)
      (chsk-send! uid message))))

(defn broadcast-state!
  "Broadcast state: send blackjack game's state to connected users"
  []
  (server->all-users! [:data15-blackjack/broadcast-state @blackjack/game]))

(defmulti event-msg-handler
          "Define multifunction to dispach messages based on `event-id`s"
          :id)

(defn event-msg-handler*
  "Log every incoming message and dispatch them."
  [{:as ev-msg :keys [id ?data event]}]
  (debugf "Event: %s" event)
  (event-msg-handler ev-msg))

;; default event handler: log (and optionally reply) for each
;; unidentified event message
(defmethod event-msg-handler :default
  [{:as ev-msg :keys [event id ?data ring-req ?reply-fn send-fn]}]
  (let [session (:session ring-req)
        uid (:uid session)]
    (debugf "Unhandled event: %s" event)
    (when ?reply-fn
      (?reply-fn {:umatched-event-as-echoed-from-from-server event}))))

;; This is out main event, the `click`. The message contains the
;; button name triggered on client side (or `load` which simply
;; request the current state). The blackjack engine will be invoked
;; after each message with the necessary additional parameters
;; including player's role and number of connected users.
;;
;; Finally we call `broadcast-state!` to tell the actual game state
;; to the clients.
(defmethod event-msg-handler :data15-blackjack/click
  [{:as ev-msg :keys [event id ?data ring-req ?reply-fn send-fn]}]
  (let [{:keys [uid role]} (:session ring-req)]
    (debugf "Initalize request: %s uid: %s data: %s" event uid ?data)
    (condp = ?data
      "load" nil
      "reset" (blackjack/start-game)
      "stand" (blackjack/stand role (number-of-connected-users))
      "hit" (blackjack/hit-me role))
    (broadcast-state!)))

;; ------------------------------------------------
;; ## Init web server

;; Web server atom to store server information in
;;
;;     ```{:server _ :port _ :stop-fn (fn [])}```
;;
;; format
(defonce web-server_
         (atom nil))                                        ;

(defn stop-web-server!
  "Invoke server's stop function."
  [] (when-let [m @web-server_] ((:stop-fn m))))

(defn start-web-server!
  "Start web server on `port`. Stop first, if it's already running.
  Store the server info in `web-server_` atom."
  [& [port]]
  (stop-web-server!)
  (let [{:keys [stop-fn port] :as server-map}
        (start-web-server!* (var my-ring-handler)
                            (or port 3000))
        uri (format "http://localhost:%s/" port)]
    (debugf "Web server is running at `%s`" uri)
    (reset! web-server_ server-map)))

;; Atom to store message router state.
(defonce router_ (atom nil))

(defn stop-router!
  "Stop router if we aware of any router stopper callback function."
  [] (when-let [stop-f @router_] (stop-f)))

(defn start-router!
  "Stop and start router while storing the router stop-function in `router_` atom."
  []
  (stop-router!)
  (reset! router_ (sente/start-chsk-router! ch-chsk event-msg-handler*)))

(defn start!
  "Start message web socket async message router and web server"
  []
  (start-router!)
  (start-web-server!))

;; start things from REPL immediately
(start-router!)

(defn -main
  "In case you start the server from command line here is a nice `main` function"
  [& args] (start!))
