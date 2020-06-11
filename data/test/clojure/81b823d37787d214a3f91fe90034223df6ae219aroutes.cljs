(ns laconic-cms.routes
  (:require [re-frame.core :as rf]
            [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as HistoryEventType])
  (:import goog.History))

(def prefix "#")

(secretary/set-config! :prefix prefix)

(secretary/defroute "/" []
  (rf/dispatch [:set-active-page :home]))

(secretary/defroute "/admin" []
  (rf/dispatch [:set-active-page :admin])
  (rf/dispatch [:admin/set-active-panel :dashboard]))

; Some generalized logic for the admin dashboard
; Should work as long as the naming conventions are followed

(secretary/defroute "/admin/:panel" [panel]
  (rf/dispatch [:set-active-page :admin])
  (rf/dispatch [:admin/set-active-panel (keyword panel)]))

; `panel` is expected to be a plural word
(secretary/defroute "/admin/:panel/:id/edit" [panel id]
  (let [sing-panel (.singular js/pluralize panel)]
    (rf/dispatch [:set-active-page :admin])
    (rf/dispatch-sync [(keyword (str "load-" sing-panel)) (js/parseInt id)])
    (rf/dispatch [:admin/set-active-panel (keyword (str "edit-" sing-panel))])))

; end of generalized logic

(secretary/defroute "/about" []
  (rf/dispatch [:set-active-page :about]))

(secretary/defroute "/posts/:id" [id]
  (rf/dispatch-sync [:load-post (js/parseInt id)])
  (rf/dispatch [:set-active-page :post]))

(secretary/defroute "/contact" []
  (rf/dispatch [:set-active-page :contact]))

(secretary/defroute "/gallery" []
  (rf/dispatch-sync [:list-galleries])
  (rf/dispatch [:set-active-page :gallery]))

(secretary/defroute "/gallery/:owner" [owner]
  (rf/dispatch-sync [:fetch-gallery-thumbs owner])
  (rf/dispatch [:set-active-page :user-gallery]))

; MOCKUP

(secretary/defroute "/page" []
  (rf/dispatch [:set-active-page :page]))

; END OF MOCKUP

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
      HistoryEventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))
