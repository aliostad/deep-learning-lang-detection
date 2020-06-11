(ns docker.ui.routes 
  (:require-macros 
   [secretary.core :refer [defroute]])
  (:require
   [docker.ui.views :as view]
   [re-frame.core :as re-frame]))

(defroute "/containers/:id" [id]
  (re-frame/dispatch [:inspect-container id]))

(defroute "/stats" [] 
  (re-frame/dispatch [:change-view view/stats-view]))

(defroute "/containers/:id/start" [id]
  (re-frame/dispatch [:change-view #(view/start-view id) ]))

(defroute "/containers/:id/start/complete" [id] 
  (re-frame/dispatch [:change-view #(view/start-complete-view id) ]))

(defroute "/containers/:id/start/failure" [id] 
  (re-frame/dispatch [:change-view #(view/start-failure-view id) ]))

(defroute "/containers/:id/stop" [id]
  (re-frame/dispatch [:change-view #(view/stop-view id) ]))

(defroute "/containers/:id/stop/complete" [id]
  (re-frame/dispatch [:change-view #(view/stop-complete-view id) ]))

(defroute "/containers/:id/stop/failure" [id]
  (re-frame/dispatch [:change-view #(view/stop-failure-view id) ]))



