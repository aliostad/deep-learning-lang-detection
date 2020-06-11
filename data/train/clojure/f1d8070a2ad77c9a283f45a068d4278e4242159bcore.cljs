(ns front-boiler.core
  (:require [cljs.core.async :as async :refer [>! <! alts! chan sliding-buffer close!]]
            [front-boiler.async :refer [put!]]
            [clojure.string :as string]
            [goog.dom]
            [goog.dom.DomHelper]
            [front-boiler.components.app :as app]
            [front-boiler.config :as config]
            [front-boiler.controllers.controls :as controls-con]
            [front-boiler.controllers.navigation :as nav-con]
            [front-boiler.routes :as routes]
            [front-boiler.controllers.api :as api-con]
            [front-boiler.controllers.ws :as ws-con]
            [front-boiler.controllers.errors :as errors-con]
            [front-boiler.extensions]
            [front-boiler.instrumentation :as instrumentation :refer [wrap-api-instrumentation]]
            [front-boiler.state :as state]
            [goog.events]
            [om.core :as om :include-macros true]
            [front-boiler.pusher :as pusher]
            [front-boiler.history :as history]
            [front-boiler.browser-settings :as browser-settings]
            [front-boiler.utils :as utils :refer [mlog merror third set-canonical!]]
            [front-boiler.datetime :as datetime]
            [front-boiler.timer :as timer]
            [secretary.core :as sec])
  (:require-macros [cljs.core.async.macros :as am :refer [go go-loop alt!]]
                   [front-boiler.utils :refer [inspect timing swallow-errors]]))

(enable-console-print!)

;; declare channels

(def controls-ch
  (chan))

(def api-ch
  (chan))

(def errors-ch
  (chan))

(def navigation-ch
  (chan))

(def ws-ch
  (chan))

(defn app-state []
  (let [initial-state (state/initial-state)]
    (atom (assoc initial-state
              ;; TODO Replace with ajax call to backend
              ;;      for inital user settings
              ;; :current-user (-> js/window
              ;;                   (aget "renderContext")
              ;;                   (aget "current_user")
              ;;                   utils/js->clj-kw)
              :current-user {:admin false
                             :dev-admin false
                             :login "test-user"}
              ;; TODO Replace with ajax call to backend
              ;;      for inital user settings
              ;; :render-context (-> js/window
              ;;                     (aget "renderContext")
              ;;                     utils/js->clj-kw)
              :render-context {:instrument false
                               :user_session_settings {:om_build_id "dev"}}
              :comms {:controls  controls-ch
                      :api       api-ch
                      :errors    errors-ch
                      :nav       navigation-ch
                      :ws        ws-ch
                      :controls-mult (async/mult controls-ch)
                      :api-mult (async/mult api-ch)
                      :errors-mult (async/mult errors-ch)
                      :nav-mult (async/mult navigation-ch)
                      :ws-mult (async/mult ws-ch)}))))

(def debug-state)

(defn log-channels?
  "Log channels in development, can be overridden by the log-channels query param"
  []
  (:log-channels? utils/initial-query-map (config/log-channels?)))

(defn controls-handler
  [value state container]
  (when (log-channels?)
    (mlog "Controls Verbose: " value))
  (swallow-errors
   (binding [front-boiler.async/*uuid* (:uuid (meta value))]
     (let [previous-state @state]
       ;; apply control-event partial with state as the last argument
       (swap! state (partial controls-con/control-event container (first value) (second value)))
       ;; if specified, apply some functuon after control-event is executed.
       (controls-con/post-control-event! container (first value) (second value) previous-state @state)))))

(defn nav-handler
  [[navigation-point {:keys [inner? query-params] :as args} :as value] state history]
  (when (log-channels?)
    (mlog "Navigation Verbose: " value))
  (swallow-errors
   (binding [front-boiler.async/*uuid* (:uuid (meta value))]
     (let [previous-state @state]
       (swap! state (partial nav-con/navigated-to history navigation-point args))
       (nav-con/post-navigated-to! history navigation-point args previous-state @state)
       (set-canonical! (:_canonical args))))))

(defn api-handler
  [value state container]
  (when (log-channels?)
    (mlog "API Verbose: " (first value) (second value) (utils/third value)))
  (swallow-errors
   (binding [front-boiler.async/*uuid* (:uuid (meta value))]
     (let [previous-state @state
           message (first value)
           status (second value)
           api-data (utils/third value)]
       (swap! state (wrap-api-instrumentation (partial api-con/api-event container message status api-data)
                                              api-data))
       (when-let [date-header (get-in api-data [:response-headers "Date"])]
         (datetime/update-server-offset date-header))
       (api-con/post-api-event! container message status api-data previous-state @state)))))

(defn ws-handler
  [value state pusher]
  (when (log-channels?)
    (mlog "websocket Verbose: " (pr-str (first value)) (second value) (utils/third value)))
  (swallow-errors
   (binding [front-boiler.async/*uuid* (:uuid (meta value))]
     (let [previous-state @state]
       (swap! state (partial ws-con/ws-event pusher (first value) (second value)))
       (ws-con/post-ws-event! pusher (first value) (second value) previous-state @state)))))

(defn errors-handler
  [value state container]
  (when (log-channels?)
    (mlog "Errors Verbose: " value))
  (swallow-errors
   (binding [front-boiler.async/*uuid* (:uuid (meta value))]
     (let [previous-state @state]
       (swap! state (partial errors-con/error container (first value) (second value)))
       (errors-con/post-error! container (first value) (second value) previous-state @state)))))

(declare reinstall-om!)

(defn install-om [state container comms instrument?]
  (om/root
   app/app
   state
   {:target container
    :shared {:comms comms
             :timer-atom (timer/initialize)
             :_app-state-do-not-use state}
    :instrument (let [methods (cond-> om/no-local-state-methods
                                instrument? instrumentation/instrument-methods)
                      descriptor (om/no-local-descriptor methods)]
                  (fn [f cursor m]
                    (om/build* f cursor (assoc m :descriptor descriptor))))
    :opts {:reinstall-om! reinstall-om!}}))

(defn find-top-level-node []
  (.-body js/document))

(defn find-app-container []
  (goog.dom/getElement "om-app"))

(defn main [state top-level-node history-imp instrument?]
  (let [comms       (:comms @state)
        container   (find-app-container)
        uri-path    (.getPath utils/parsed-uri)
        pusher-imp (pusher/new-pusher-instance (config/pusher))
        controls-tap (chan)
        nav-tap (chan)
        api-tap (chan)
        ws-tap (chan)
        errors-tap (chan)]
    (routes/define-routes! state)
    (install-om state container comms instrument?)

    (async/tap (:controls-mult comms) controls-tap)
    (async/tap (:nav-mult comms) nav-tap)
    (async/tap (:api-mult comms) api-tap)
    (async/tap (:ws-mult comms) ws-tap)
    (async/tap (:errors-mult comms) errors-tap)

    (go (while true
          (alt!
           controls-tap ([v] (controls-handler v state container))
           nav-tap ([v] (nav-handler v state history-imp))
           api-tap ([v] (api-handler v state container))
           ws-tap ([v] (ws-handler v state pusher-imp))
           errors-tap ([v] (errors-handler v state container))
           ;; Capture the current history for playback in the absence
           ;; of a server to store it
           (async/timeout 10000) (do #_(print "TODO: print out history: ")))))))

(defn subscribe-to-user-channel [user ws-ch]
  (put! ws-ch [:subscribe {:channel-name (pusher/user-channel user)
                           :messages [:refresh]}]))
;; Helper methods
;; TODO move to own file

(defn apply-app-id-hack
  "Hack to make the top-level id of the app the same as the
   current knockout app. Lets us use the same stylesheet."
  []
  (goog.dom.setProperties (goog.dom/getElement "app") #js {:id "om-app"}))

(defn toggle-admin []
  (swap! debug-state update-in [:current-user :admin] not))

(defn toggle-dev-admin []
  (swap! debug-state update-in [:current-user :dev-admin] not))

(defn explode []
  (swallow-errors
    (assoc [] :deliberate :exception)))

(defn  app-state-to-js
  "Used for inspecting app state in the console."
  []
  (clj->js @debug-state))

(defn add-css-link [path]
  (let [link (goog.dom/createDom "link"
               #js {:rel "stylesheet"
                    :href (str path "?t=" (.getTime (js/Date.)))})]
    (.appendChild (.-head js/document) link)))

;; start/restart app

(defn reinstall-om! []
  (install-om debug-state (find-app-container) (:comms @debug-state) true))

(defn setup! []
  (apply-app-id-hack)
  (let [state (app-state)
        top-level-node (find-top-level-node)
        history-imp (history/new-history-imp top-level-node)
        instrument? (get-in @state [:render-context :instrument])]
    ;; globally define the state so that we can get to it for debugging
    (set! debug-state state)
    (when instrument?
      (instrumentation/setup-component-stats!))
    (browser-settings/setup! state)
    (main state top-level-node history-imp instrument?)
    (if-let [error-status (get-in @state [:render-context :status])]
      ;; error codes from the server get passed as :status in the render-context
      (put! (get-in @state [:comms :nav]) [:error {:status error-status}]))
    (when-let [user (:current-user @state)]
      (subscribe-to-user-channel user (get-in @state [:comms :ws])))))

(setup!)

(defn on-js-reload [] (reinstall-om!))
