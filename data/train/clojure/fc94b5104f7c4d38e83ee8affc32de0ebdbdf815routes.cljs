(ns owlet.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History)
  (:require [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as rf]))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute "/" []
            (rf/dispatch [:set-active-view :welcome-view]))

  (defroute "/404" []
            (rf/dispatch [:get-content-from-contentful :show-not-found]))

  (defroute "/about" []
            (rf/dispatch [:get-content-from-contentful :show-about]))

  (defroute "/settings" []
            (rf/dispatch [:get-content-from-contentful :show-settings]))

  (defroute "/confirm/:sub-info" {:as params} []
            (rf/dispatch [:set-active-view :confirm-view params]))

  (defroute "/subscribed/:sub-info" {:as params}
            (rf/dispatch [:get-content-from-contentful :show-subscribed params]))

  (defroute "/unsubscribe" []
            (rf/dispatch [:set-active-view :unsubscribe-view]))

  (defroute "/branches" []
            (rf/dispatch [:get-content-from-contentful :show-branches]))

  (defroute "/skill/:skill" {:as params}
            (rf/dispatch [:get-content-from-contentful :show-skill (:skill params)]))

  (defroute "/platform/:platform" {:as params}
            (rf/dispatch [:get-content-from-contentful :show-platform (:platform params)]))

  (defroute "/branch/:branch" {:as params}
            (rf/dispatch [:get-content-from-contentful :show-branch (:branch params)]))

  (defroute "/activity/#!:activity" {:as params}
            (rf/dispatch [:get-content-from-contentful :show-activity (:activity params)]))

  (defroute "*" []
            (let [uri (-> js/window .-location .-href)]
              (if (re-find #"%23" uri)
                (let [new-uri (js/decodeURIComponent uri)]
                  (set! (-> js/window .-location) new-uri))
                (set! (.-location js/window) "/#/404"))))

  ; Ensure browser history uses Secretary to dispatch.
  (doto (History.)
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))
