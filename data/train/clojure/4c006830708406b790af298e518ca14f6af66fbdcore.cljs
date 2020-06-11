(ns utimer.core
  (:require [rum.core :as rum]
            [orchestra-cljs.spec.test :as st]

            ;; UTimer Modules
            [utimer.timer]
            [utimer.clock :as clock]
            [utimer.layout :as layout]

            ;; UTimer Components
            [utimer.components.header :refer [c-header]]
            [utimer.components.layout :refer [c-layout]]
            [utimer.components.flat-timer :refer [c-flat-timer]]
            ))

;; For testing and development
(st/instrument)


(enable-console-print!)


(defonce app-state
  (atom
   {:layout [{:type :flat}]}))


(rum/defc main < 
  rum/reactive
  [app-state]
  (let [{:keys [layout]} (rum/react app-state)]
    [:div.main-container
     (c-header app-state)
     (c-flat-timer (layout/element :flat))
     (c-flat-timer (layout/element :flat))
     ]))


(defn render []
  (rum/mount (main app-state) (. js/document (getElementById "app"))))
