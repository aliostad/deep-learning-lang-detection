(ns forum.core
  (:require [reagent.core :as r]
            [re-frame.core :as rf]
            [secretary.core :as secretary]
            [goog.events :as events]
            [goog.history.EventType :as HistoryEventType]
            [markdown.core :refer [md->html]]
            [ajax.core :refer [GET POST]]
            [forum.ajax :refer [load-interceptors!]]
            [forum.handlers]
            [forum.components.core :as c  ]
            [forum.subscriptions]
            )
  (:import goog.History))

(defn dispatch
  [route]
  (print  (str "dispatch: " (str route)))
  (rf/dispatch route))
;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (dispatch [:set-page :home]))

(secretary/defroute "/:page" [page]
  (print (str "current page: " page))
  (dispatch [:set-page (keyword page)]))

(secretary/defroute "/forum/:section" [section]
  (dispatch [:set-page :forum])
  (dispatch [:set-section (keyword section)]))

(secretary/defroute "/forum/:section/new" [section]
  (dispatch [:set-page :forum])
  (dispatch [:set-section (keyword section)])
  (dispatch [:set-state-of-section (keyword section) :new]))


(secretary/defroute "/forum/:section/posts" [section]
  (dispatch [:set-page :forum])
  (dispatch [:set-section (keyword section)])
  (dispatch [:set-state-of-section (keyword section) :list]))


(secretary/defroute "/forum/:section/new" [section]
  (dispatch [:set-page :forum])
  (dispatch [:set-section (keyword section)])
  (dispatch [:set-state-of-section (keyword section) :new]))

(secretary/defroute "/forum/:section/post/:id" [section id]
  (dispatch [:set-page :forum])
  (dispatch [:set-section (keyword section)])
  (dispatch [:set-state-of-section (keyword section) :single])
  (dispatch [:set-post-in-section (keyword section) id]))

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     HistoryEventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -------------------------
;; Initialize app
(defn fetch-docs! []
  (GET "/docs" {:handler #(dispatch [:set-docs %])}))

(defn hello [] [:div [:h1 "hello"]])

(defn mount-components []
  (r/render c/app (.getElementById js/document "app")))

(defn init! []
  (rf/dispatch-sync [:initialize-db])
  (load-interceptors!)
  ;; (fetch-docs!)
  (hook-browser-navigation!)
  (mount-components)
  )
