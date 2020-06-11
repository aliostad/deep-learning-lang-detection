(ns dev
  (:require [clojure.repl :refer :all]
            [clojure.pprint :refer [pp pprint]]
            [clojure.tools.namespace.repl :refer [refresh]]
            [mount.core :as mount]
            [intro-to-spec
             [queue :as q]
             [macros :as m]
             [zundoko :as z]]
            [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [clojure.spec.test :as t]))

(defn go []
  #_(s/instrument-all)
  (mount/start))

(defn stop []
  (mount/stop))

(defn reset []
  (stop)
  (reset! @#'t/instrumented-vars {})
  (refresh :after 'dev/go))
