(ns clojurescript-redux.containers
  (:require [clojurescript-redux.dispatch :as dispatch]
            [clojurescript-redux.components :as components]
            [clojurescript-redux.actions :as actions]))

(defn index [app-state _]
  (let [bind-dispatch (partial dispatch/bind-dispatch app-state)]
    [components/counters {:counters (:counters @app-state)
                          :total (reduce #(+ %1 (:count %2)) 0 (:counters @app-state))
                          :handle-add-counter (bind-dispatch actions/add-counter)
                          :handle-pop-counter (bind-dispatch actions/pop-counter)
                          :handle-inc-counter (bind-dispatch actions/inc-counter)
                          :handle-dec-counter (bind-dispatch actions/dec-counter)}]))

(defn route-a [app-state children]
  [:div
   [:div.tabs
    [components/link-to (:router @app-state) :route-a "Index"]
    [components/link-to (:router @app-state) :subroute-a "Subpage"]]
   [:h1 "Route A Index"]
   children])

(defn route-b [app-state _]
  [:h1 "Route B"])

(defn subroute-a [app-state _]
  [:h2 "Subpage"])

(defn not-found [app-state _]
  [:h1 "404"])

(defn root [app-state children]
  [:div
   [:div.menu
    [:div.l-content
     [components/link-to (:router @app-state) :counters "Counters"]
     [components/link-to (:router @app-state) :route-a "Route-a"]
     [components/link-to (:router @app-state) :route-b "Route-b"]]]
   [:div.l-content.main children]])

(def containers
  {:counters [root index]
   :route-a [root route-a]
   :subroute-a [root route-a subroute-a]
   :route-b [root route-b]
   :not-found [root not-found]})
