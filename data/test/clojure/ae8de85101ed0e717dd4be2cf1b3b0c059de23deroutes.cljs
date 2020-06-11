
(ns nexus.routes
  (:require [secretary.core :as secretary :refer-macros [defroute]]
            [re-frame.core :refer [subscribe dispatch]]
            [goog.events :as events]
            [goog.history.EventType :as HistoryEventType]
            [accountant.core :as accountant])
  (:import goog.History))

(defn logged-in? []
  @(subscribe [:auth/token]))

(defn redirect-to
  [resource]
  (secretary/dispatch! resource)
  (.setToken (History.) resource))

; (defn run-events [events]
;   (doseq [event events]
;     (if (logged-in?)
;         (dispatch event)
;         (dispatch [:add-login-event event]))))

(defn context-url [url]
  (let [host (-> js/window .-location .-host)
        path (-> js/window .-location .-pathname)]
    (str host path url)))

(defn href [url]
  {:href (str js/context url)})

(defn navigate! [url]
  (accountant/navigate! url))

; (defn home-page-events [& events]
;   (.scrollTo js/window 0 0)
;   (run-events (into
;                 [
;                 ;  [:load-tags]
;                  [:set-active-page :home]]
;                 events)))

(secretary/defroute "/" []
  (js/console.log "DISPATCHED ROUTE /")
  (if (logged-in?)
      (do
        (js/console.log "NOT LOGGED IN... REDIRECTING")
        (dispatch [:set-active-panel :login]))
      (do
        (js/console.log "YES LOGGED IN")
        (dispatch [:set-active-panel :editor]))))

; (secretary/defroute "/login" []
;   (dispatch [:set-active-panel :login]))
  ; (navigate! "bots"))

; (secretary/defroute "/bots" []
;   (if (logged-in?)
;     (dispatch [:set-active-panel :bots])))
    ; (redirect-to "/login")))
  ;;  load bots by publisher)

; (secretary/defroute "/bots/:bot-id" {:as params}
;   (dispatch [:set-active-panel :bots params]))
  ;; load bot with id

; (secretary/defroute "/editor/:course-id" {:as params}
;   (dispatch [:set-active-panel :editor params]))
  ;; load course with id

; (secretary/defroute "*" []
;   (dispatch [:set-active-panel :notfound]))

; (secretary/defroute (context-url "/edit-issue") []
  ; (if-not (logged-in?)
  ;   (navigate! "/")
  ;   (dispatch [:set-active-page :edit-issue])))

; (defn hook-browser-navigation! []
;   (doto (History.)
;     (events/listen
;       HistoryEventType/NAVIGATE
;       (fn [event]
;         (secretary/dispatch! (.-token event))))
;     (.setEnabled true)))
;   (accountant/configure-navigation!
;     {:nav-handler
;      (fn [path]
;        (js/console.log "nav handler")
;        (secretary/dispatch! path))
;      :path-exists?
;      (fn [path]
;        (secretary/locate-route path))})
;   (accountant/dispatch-current!))
