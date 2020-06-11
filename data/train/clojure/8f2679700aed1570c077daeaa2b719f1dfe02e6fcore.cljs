(ns todo-mvc.android.core
  (:require [reagent.core :as r]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [todo-mvc.events :refer [load-todos]]
            [todo-mvc.subs]
            [todo-mvc.root :refer [root]]))

(def ReactNative (js/require "react-native"))

(def app-registry (.-AppRegistry ReactNative))

(defn app-root []
  [root])

(defn init []
  (dispatch-sync [:initialize-db])
  (load-todos
    (fn [{:keys [todos showing]}]
      (dispatch [:load-todos todos])
      (dispatch [:set-showing showing])))
  (.registerComponent app-registry "TodoMvc" #(r/reactify-component app-root)))