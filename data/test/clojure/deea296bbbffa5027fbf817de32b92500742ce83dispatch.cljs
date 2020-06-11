(ns clojurescript-redux.dispatch
  (:require [clojurescript-redux.reducers :as reducers]))

(defn log-middleware [state next]
  (fn [action]
    (let [group-name (str "Action: " (:type action))
          new-state (next action)]
      (.groupCollapsed js/console group-name)
      (println state)
      (println action)
      (println new-state)
      (.groupEnd js/console group-name))))

(defn create-dispatch [app-state]
  (let [state @app-state]
    (->> #(swap! app-state reducers/app %)
         (log-middleware state))))

(defn bind-dispatch-raw [app-state action-creator]
  (let [dispatch (create-dispatch app-state)]
    (fn [& args]
      (dispatch (apply action-creator args)))))

(def bind-dispatch
  (memoize bind-dispatch-raw))
