(ns brun.term
  (:require [lanterna.terminal :as t]
            [taoensso.timbre :as timbre :refer [info debug]]))


(declare poll-terminal-keys)
(declare state) ;; FIXME

(defn start-terminal []
  (let [term (t/get-terminal :text)]
    (t/start term)
    term))


(defn quit []
  (info "quiting...")
  ;;(cleanup)
  (System/exit 0))


(defn show-hide-browser []
  (let [pos (if (:hidden @state)
              (:position @state)
              (org.openqa.selenium.Point. 10000 10000))]
    (-> (driver/manage) .window (.setPosition pos)))
  (swap! state update-in [:hidden] not)
  (if (:hidden @state)
    (info "hiding browser")
    (info "showing browser")))


(defn show-help []
  (info "v - show/hide browser")
  (info "X - quit")
  (info "h - help"))

(def console-keys {\v show-hide-browser
                   \X quit
                   \h show-help})


(defn poll-terminal-keys []
  (let [term (:term @state)]
    (future
      (while true
        (let [k (t/get-key-blocking term {:interval 250})]
          (debug "pressed" k "key")
          (when-let [a (console-keys k)]
            (a)))))))
