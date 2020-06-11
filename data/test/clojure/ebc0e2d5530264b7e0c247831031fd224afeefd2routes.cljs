(ns lf.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History
    ;[goog.history EventType]
           )
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as re-frame]))

;(defn hook-browser-navigation! []
;  (doto (History.)
;    (events/listen
;      EventType/NAVIGATE
;      (fn [event]
;        (secretary/dispatch! (.-token event))))
;    (.setEnabled true)))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute "/Home" []
            (re-frame/dispatch [:set-active-panel :Home]))
  (defroute "/Task" []
            [(re-frame/dispatch [:set-active-panel :Task])
             (re-frame/dispatch [:request-queues])
             (re-frame/dispatch [:request-workers])
             (re-frame/dispatch [:request-tasks])

             ])
  (defroute "/Data" []
            (re-frame/dispatch [:set-active-panel :Data]))
  (defroute "/Trigger" []
            (re-frame/dispatch [:set-active-panel :Trigger]))
  ;(defroute "/Home" []
  ;          (re-frame/dispatch [:set-active-panel :Home]))

  (defroute "/About" []
            (re-frame/dispatch [:set-active-panel :About]))


  ;; --------------------
  (hook-browser-navigation!)
  )




;; 用这个就行
(defn app-routes-auto [panel-list]
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here

  ;(.log js/console (str (first panel-list)))
  (defroute "/" []
            (re-frame/dispatch [:set-active-panel (keyword (first panel-list))]))


  (doseq [item panel-list]
    (defroute (str "/" item) []
              (re-frame/dispatch [:set-active-panel (keyword item)]))
    )

  ;(defroute "/Task" []
  ;          [(re-frame/dispatch [:set-active-panel :task])
  ;           (re-frame/dispatch [:request-queues])
  ;           (re-frame/dispatch [:request-workers])
  ;           (re-frame/dispatch [:request-tasks])
  ;           ])

  ;; --------------------
  (hook-browser-navigation!)

  ;; Quick and dirty history configuration. 用这个
  ;(let [h (History.)]
  ;  (goog.events/listen h EventType/NAVIGATE #(secretary/dispatch! (.-token %)))
  ;  (doto h (.setEnabled true)))

  )









;(defn current-page []
;  [:div [(session/get :current-page)]])


;; -------------------------
;; Routes

;(secretary/set-config! :prefix "#")
;
;(secretary/defroute "/" []
;                    (session/put! :current-page #'Home))
;(secretary/defroute "/Home" []
;                    (session/put! :current-page #'Home))
;(secretary/defroute "/Task" []
;                    (session/put! :current-page #'Task))
;(secretary/defroute "/Data" []
;                    (session/put! :current-page #'Data))
;(secretary/defroute "/Trigger" []
;                    (session/put! :current-page #'Trigger))
;(secretary/defroute "/About" []
;                    (session/put! :current-page #'About))
;
