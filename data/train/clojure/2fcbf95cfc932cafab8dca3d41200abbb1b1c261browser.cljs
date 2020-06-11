(ns structurize.system.browser
  (:require [structurize.system.state :refer [write!]]
            [bidi.bidi :as b]
            [cemerick.url :refer [map->query query->map]]
            [clojure.string :as str]
            [com.stuartsierra.component :as component]
            [goog.events :as events]
            [goog.dom :as dom]
            [medley.core :as m]
            [taoensso.timbre :as log])
  (:import goog.history.Html5History
           goog.history.EventType
           goog.dom.ViewportSizeMonitor))

;; exposed functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn change-location!
  "Updates the browser's location accordingly. The browser will fire a navigation
   event if the location changes, which will be dealt with by a listener.

   Params:
   prefix - the part before the path, set it if you want to navigate to a different site
   path - the path you wish to navigate to
   query - map of query params
   replace? - ensures that the browser replaces the current location in history"
  [{:keys [history] :as Φ} {:keys [prefix path query replace?]}]

  (let [query-string (when-not (str/blank? (map->query query)) (str "?" (map->query query)))
        current-path (-> (.getToken history) (str/split "?") first)
        token (str (or path current-path) query-string)]
    (log/debug "dispatching change of location to browser:" (str prefix token))
    (cond
      prefix (set! js/window.location (str prefix token))
      replace? (.replaceToken history token)
      :else (.setToken history token))))


;; helper functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn resize [{:keys [config-opts] :as Φ}]
  (let [{:keys [xs sm md lg]} (get-in config-opts [:viewport :breakpoints])
        width (.-width (dom/getViewportSize))
        breakpoint (cond
                     (< width xs) :xs
                     (< width sm) :sm
                     (< width md) :md
                     (< width lg) :lg
                     :else :xl)]

    (log/debug "receiving resize from browser")

    (write! Φ :browser/resize
            (fn [x]
              (assoc x :viewport {:width width
                                  :height (.-height (dom/getViewportSize))
                                  :breakpoint breakpoint})))))

(defn make-transformer
  "Custom transformer required to manage query parameters."
  []
  (let [transformer (Html5History.TokenTransformer.)]
    (set! transformer.retrieveToken
          (fn [path-prefix location]
            (str (.-pathname location) (.-search location))))
    (set! transformer.createUrl
          (fn [token path-prefix location]
            (str path-prefix token)))
    transformer))


(defn make-history []
  (doto (Html5History. js/window (make-transformer))
    (.setPathPrefix "")
    (.setUseFragment false)))


(defn listen-for-change-of-location [{:keys [config-opts history] :as Φ}]
  (let [handler (fn [g-event]
                  (let [routes (:routes config-opts)
                        token (.getToken history)
                        [path query] (str/split token "?")
                        location (merge {:path path
                                         :query (->> query query->map (m/map-keys keyword))}
                                        (b/match-route routes path))]
                    (log/debug "receiving change of location from browser:" token)
                    (when-not (.-isNavigation g-event)
                      (js/window.scrollTo 0 0))
                    (write! Φ :browser/change-location
                            (fn [x]
                              (assoc x :location location)))))]
    (doto history
      (events/listen EventType.NAVIGATE #(handler %))
      (.setEnabled true))))


(defn listen-for-resize [{:keys [config-opts] :as Φ}]
  (let [handler (js/window._.debounce #(resize Φ)
                                      100
                                      #js {:trailing true})]

    ;; trigger an initial resize
    (resize Φ)

    (doto (ViewportSizeMonitor.)
      (events/listen events/EventType.RESIZE handler))))


;; component setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrecord Browser [config-opts state]
  component/Lifecycle

  (start [component]
    (log/info "initialising browser")
    (let [history (make-history)
          φ {:config-opts config-opts
             :!app-state (:!app-state state)
             :!tooling-state (:!tooling-state state)
             :history history}]
      (log/info "begin listening for change of location from the browser")
      (listen-for-change-of-location φ)
      (log/info "begin listening for resize from the browser")
      (listen-for-resize φ)
      (assoc component :history history)))

  (stop [component] component))
