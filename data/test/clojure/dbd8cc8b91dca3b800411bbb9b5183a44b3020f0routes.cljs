(ns todogo-cljs.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.history.Html5History)
  (:require [secretary.core :as secretary]
            [re-frame.core :as re-frame]
            [todogo-cljs.db :refer [get-todo-lists
                                    get-todo-list
                                    get-todos
                                    get-todo]]
            [todogo-cljs.navigation :refer [hook-browser-navigation!]]))


(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute "/" []
            (do (get-todo-lists)
                (re-frame/dispatch [:set-active-panel :todo-lists-panel])))

  (defroute "/lists/:id" [id]
            (do (get-todo-lists)
                (get-todo-list id)
                (get-todos id)
                (re-frame/dispatch [:set-active-panel :todo-list-panel])
                (re-frame/dispatch [:set-todo-list-id id])))

  (defroute "/lists/:list-id/todos/:id" [list-id id]
            (do (get-todo-lists)
                (get-todos list-id)
                (get-todo-list list-id)
                (get-todo list-id id)
                (re-frame/dispatch [:set-active-panel :todo-panel])
                (re-frame/dispatch [:set-todo-list-id list-id])
                (re-frame/dispatch [:set-todo-id id])))

  (defroute "/sign-up" []
    (re-frame/dispatch [:set-active-panel :sign-up-panel]))

  (defroute "/sign-in" []
    (re-frame/dispatch [:set-active-panel :sign-in-panel]))

  (defroute "/about" []
    (re-frame/dispatch [:set-active-panel :about-panel]))


  ;; --------------------
  (hook-browser-navigation!))
