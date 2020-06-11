(ns goat.core
  (:require [clojure.core.reducers :as r]
            [robert.hooke :refer [add-hook clear-hooks]])
  (:import [clojure.lang Var Symbol IFn IPersistentMap]))

(defrecord FPerf [name call-count total-time])

(def perf-funs (ref {}))

(defn fun-name [^Var fun]
  (symbol (str (.getName (.-ns fun)) "/" (.-sym fun))))

(defn get-fperf
  "Argument name is a fully qualified symbol"
  [^Symbol name]
  (get @perf-funs name))

(defn get-fperf-data []
  @perf-funs)

(defn sort-by-keys [ks coll]
  (loop [sort-keys ks xs coll]
    (if-let [k (first sort-keys)]
      (recur (rest sort-keys) (sort-by k xs))
      xs)))

(defn get-top-fperf
  ([x]
   (get-top-fperf x :total-count :total-time))
  ([x & ks]
   (->> (get-fperf-data)
        vals
        (filter #((complement zero?) (:call-count %) ))
        (sort-by-keys ks)
        reverse
        (take x))))

(defn update-fperf
  "Takes a map function call-count and total function time, and then updates the FPerf instance in the map"
  [^IPersistentMap m ^Symbol fun ^long call-count ^long total-time]
  (let [^FPerf fperf (get m fun (FPerf. fun 0 0))]
    (FPerf.
     (:name fperf)
     (unchecked-add (:call-count fperf) call-count)
     (unchecked-add (:total-time fperf) total-time))))

(defn add-perf-data
  "Calls the update-fperf function and assoc's its results into the perf-funs map"
  [^Symbol n ^long total-time]
  (dosync
   (commute perf-funs #(assoc % n (update-fperf % n 1 total-time)))))

(defn time-fun
  "Used by instrument-function to encupsulate a function and time its execution in milliseconds.
   This function will call the add-perf-data function after its applied f to its args"
  [^Symbol n ^IFn f args]
  (let [start-time (System/currentTimeMillis)
        res (apply f args)
        stop-time (System/currentTimeMillis)]
    (add-perf-data n (unchecked-subtract stop-time start-time))
    res))

(defn instrument-function "Takes a single function and calls add-hook attaching the time-fun to it"
  [^Symbol n ^Var fun]
  (add-hook fun (fn [f & args] (time-fun n f args)))) ; we use a closure to close over n, because the function name is not available when called

(defn reset-instrumentation!
  "When called with no arguments, removes all instrumentation.
   Optionally takes a target namespace. When given, removes instrumentation for
   that namespace only."
  ([]
   (doseq [f-var (map find-var (keys @perf-funs))]
     (clear-hooks f-var)))
  ([^Symbol target-ns]
   (doseq [f-var (map find-var (filter #(= (namespace %) (str target-ns)) (keys @perf-funs)))]
     (clear-hooks f-var))))

(defn clear-perf-data! "Clear performance data"
  []
  (dosync (ref-set perf-funs {})))

(defn instrument-functions!
  [^Symbol target-ns]
  (let [all-vars (vals (ns-publics target-ns))
        fns (r/filter #(contains? (meta %) :arglists) all-vars)
        fun-map (r/fold (fn
                          ([] {})
                          ([m fun]
                           (let [n (fun-name fun)]
                             (instrument-function n fun)
                             (assoc m n (FPerf. n 0 0)))))
                        fns)]
    (dosync (alter perf-funs into fun-map))))
