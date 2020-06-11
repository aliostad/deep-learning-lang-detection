(ns faceboard.env
  (:require-macros [faceboard.macros.logging :refer [log log-err log-warn log-info]])
  (:require [faceboard.devtools :as devtools]
            [faceboard.figwheel :as figwheel]))

(defn defined? [v]
  (not (nil? v)))

(def js-env (aget js/window "faceboard_env"))
(def platform (js->clj js/platform :keywordize-keys true))
(def env (js->clj js-env :keywordize-keys true))

(def mac? (= (get-in platform [:os :family]) "OS X"))
(def git-revision (:git-revision env))
(def local? (not (defined? (:production env))))
(def firebase-db (get env :firebase-db "blinding-heat-4410"))
(def domain (.-host js/location))
(def instrument? (and local? false))
(def simple-profile? (and local? true))

(defn init! []
  (enable-console-print!)
  (when local?
    (devtools/install!)
    (figwheel/start)))