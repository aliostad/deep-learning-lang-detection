(ns faceboard.app
  (:require-macros [faceboard.macros.logging :refer [log log-err log-warn log-info]])
  (:require [om.core :as om]
            [om-tools.core :refer-macros [defcomponent]]
            [faceboard.env :as env]
            [faceboard.state :refer [app-state]]
            [faceboard.controller :refer [perform!]]
            [faceboard.views.main :refer [main-component]]
            [faceboard.instrumentation :as instrumentation]
            [faceboard.dispatcher :as dispatcher]))

(defn- root-app-element []
  (.getElementById js/document "app"))

(defn- href-handler [e]
  (this-as a
    (.stopPropagation e)
    (when-not (.hasAttribute a "target")
      (.preventDefault e)
      (.setAttribute a "target" "_blank")
      (.click a))))

(defn- turn-all-hrefs-to-external-links []
  (let [delegate (js/Delegate. (root-app-element))
        on (aget delegate "on")]
    (.call on delegate "click" "a" href-handler)))

(defn init! []
  (turn-all-hrefs-to-external-links)
  (dispatcher/start-handling-commands))

(def app-opts
  (merge
    {:target (root-app-element)}
    (if env/instrument?
      {:descriptor (instrumentation/patch-om!)})))

(defn mount! []
  (om/root main-component app-state app-opts))

(when env/local?
  (aset js/window "faceboard_reloader" mount!))