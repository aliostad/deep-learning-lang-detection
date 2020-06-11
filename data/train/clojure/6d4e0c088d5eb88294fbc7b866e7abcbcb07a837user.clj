(ns user
  (:require [api.core]
            [clojure.spec.test :as stest]
            [clojure.tools.namespace.repl :refer [refresh]]
            [mount.core :as mount :refer [defstate]]))


;; =============================================================================
;; Reloaded
;; =============================================================================


(def start #(mount/start-with-args {:env :dev}))


(def stop mount/stop)


(defn go []
  (start)
  (stest/instrument)
  :ready)


(defn reset []
  (stop)
  (refresh :after 'user/go))
