(ns ^{:doc "The main namespace"
      :author "Andrea Richiardi"
      :figwheel-load true}
    rest-resources-viz.core
  (:require [cljs.reader :as edn]
            [clojure.spec.alpha :as s]
            [clojure.spec.test.alpha :as stest :include-macros true]
            [clojure.string :as str]
            [clojure.set :as set]
            [adzerk.env :as env]
            [reagent.core :as r]
            [rest-resources-viz.model :as model]
            [rest-resources-viz.graph :as graph]
            [rest-resources-viz.spec :as rspec]
            [rest-resources-viz.util :as u])
  (:require-macros [rest-resources-viz.logging :as log]))

(enable-console-print!)

(env/def
  RESOURCE_DATA_URL "graph-data.edn")

(defn fetch-data! []
  (u/fetch-file! RESOURCE_DATA_URL (fn [gd]
                                     (if gd
                                       (swap! model/app-state assoc :graph-data (edn/read-string gd))
                                       (log/warn "Cannot fetch data!")))))

(defn btn-draw []
  [:button.btn {:on-click #(do (model/trash-graph-data!) (fetch-data!))}
   "Force draw"])

(defn btn-reset []
  [:button.btn {:on-click #(do (model/reset-state!) (fetch-data!))}
   "Reset state"])

(defn landing []
  [:div
   [graph/container]
   (when u/debug?
     [:div.row
      [btn-reset]
      [btn-draw]])])

(when u/debug?
  (stest/instrument 'rest-resources-viz.model/get-node-color)
  (stest/instrument 'rest-resources-viz.model/node-id)
  (stest/instrument 'rest-resources-viz.model/highligthed-nodes)
  (stest/instrument 'rest-resources-viz.model/clicked-node)
  (stest/instrument 'rest-resources-viz.model/clicked-family)
  (stest/instrument 'rest-resources-viz.graph.families/highlighted-family?))

(defn ^:export on-jsload []
  (.info js/console "Reloading Javascript...")
  (r/render [landing] (.getElementById js/document "app"))
  (fetch-data!))
