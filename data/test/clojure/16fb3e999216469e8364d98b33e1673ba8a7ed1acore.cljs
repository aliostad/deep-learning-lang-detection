(ns clojurescript-redux.core
  (:require [clojurescript-redux.dispatch :as dispatch]
            [clojurescript-redux.containers :as containers]
            [clojurescript-redux.reducers :as reducers]
            [clojurescript-redux.routes :as routes]
            [clojurescript-redux.utils :as utils]
            [reagent.core :as reagent]))

(enable-console-print!)

(defn root [app-state]
  (-> (get-in @app-state [:router :handler] :not-found)
      containers/containers
      (utils/build-containers app-state)))

(defonce app-state
  (reagent/atom (reducers/app {} {:type :init})))

(defonce hook-routes
  (routes/hook-routes (dispatch/create-dispatch app-state)))

(reagent/render-component [root app-state]
                          (. js/document (getElementById "app")))
