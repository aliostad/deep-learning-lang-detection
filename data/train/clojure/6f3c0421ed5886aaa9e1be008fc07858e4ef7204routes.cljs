(ns engaged.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [clojure.string :as str]
            [accountant.core :as accountant]
            [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [mount.core :refer [defstate]]
            [re-frame.core :as re-frame]))

;; TODO make this a lot less hacky.  currently secretary uses a
;; hash prefix but accountant doesn't, so when accountant calls
;; this it doesn't include that in the path parameter.  we
;; recreate the path parameter including the hash, then strip off
;; the hash for secretary's dispatch function.
(defn dispatch! [path]
  (if (str/includes? path "id_token")
    (re-frame/dispatch-sync [:login-resuming])
    (let [path (-> (str (-> js/window .-location .-pathname)
                        (-> js/window .-location .-search)
                        (-> js/window .-location .-hash))
                   (subs 2))]
      (secretary/dispatch! path))))

(defonce routing-config
  (do
    (secretary/set-config! :prefix "#")

    (defroute lobby "/" []
      (re-frame/dispatch [:set-route :lobby]))

    (defroute about "/about" []
      (re-frame/dispatch [:set-route :about]))

    (defroute game "/game/:id" [id]
      (re-frame/dispatch [:set-route [:game id]]))

    (accountant/configure-navigation! {:nav-handler  dispatch!
                                       :path-exists? secretary/locate-route})))

(defstate initial-dispatch
  :start (accountant/dispatch-current!))
