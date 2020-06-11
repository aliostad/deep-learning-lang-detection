(ns user
  (:require [clojure.spec.test :as stest]
            [clojure.tools.namespace.repl :refer [refresh]]
            [datomic.api :as d]
            [figwheel-sidecar.repl-api :as ra]
            [mount.core :as mount :refer [defstate]]
            [odin.datomic :refer [conn]]
            [odin.config :as config :refer [config]]
            [odin.core]
            [odin.seed :as seed]
            [taoensso.timbre :as timbre]))


(timbre/refer-timbre)


;; =============================================================================
;; Reloaded
;; =============================================================================


(def start #(mount/start-with-args {:env :dev}))


(def stop mount/stop)


(defn- in-memory-db?
  "There's a more robust way to do this, but it's not really necessary ATM."
  [uri]
  (clojure.string/starts-with? uri "datomic:mem"))


(defstate seeder
  :start (when (in-memory-db? (config/datomic-uri config))
           (timbre/debug "seeding dev database...")
           (seed/seed conn)))


(defn go []
  (start)
  (stest/instrument)
  :ready)


(defn reset []
  (stop)
  (refresh :after 'user/go))


;; =============================================================================
;; Figwheel
;; =============================================================================


(defn start-figwheel! []
  (when-not (ra/figwheel-running?)
    (timbre/debug "starting figwheel server...")
    (ra/start-figwheel!)))


(defn cljs-repl [& [build]]
  (ra/cljs-repl (or build "odin")))


(defn go! []
  (go)
  (start-figwheel!)
  (timbre/debug "⟡ WE ARE GO! ⟡"))
