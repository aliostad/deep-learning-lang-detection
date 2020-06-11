(ns vchain.routes 
  (:require [secretary.core :as secretary :include-macros true :refer [defroute]]
            [om.core :as om]
            vchain.app
            vchain.history))

(defn dispatch! [r]
  (secretary/dispatch! r))

; Make back button handle pushState by 
; dispatching the new location
(vchain.history/on-state-change
  #(dispatch! %))

; Set up routes
(defroute "/entity/new" []
  (vchain.app/set-new-entity!))

(defroute "/entity/:slug" {:as params}
  (vchain.app/set-current-entity! (:slug params)))

(defroute "/login" [] 
  (vchain.app/login!))

(defroute "/logout" []
  (vchain.app/logout!))

