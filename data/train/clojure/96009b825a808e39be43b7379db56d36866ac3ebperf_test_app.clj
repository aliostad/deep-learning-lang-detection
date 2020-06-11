(ns lupapalvelu.perf-test-app
  (:require [lupapalvelu.perf-test]
            [lupapalvelu.perf-mon :refer :all]))

(comment

  (instrument-ns 'lupapalvelu.perf-test)

  (defn- append-summary [summary [f-name args duration sub-contexts]]
    (let [[c v] (get summary f-name [0 0.0])
          summary (assoc summary f-name [(inc c) (+ v duration)])
          summary (reduce append-summary summary sub-contexts)]
      summary))

  (defn perf-logger [context]
    (let [summary (reduce append-summary {} context)]
      (println
        (with-out-str
          (let [k (ffirst context)
                [c v] (get summary k)]
            (println (format "%s: %5d:  %9.3f ms (%.3f ms)" k c (/ v 1000000.0) (/ (/ v 1000000.0) c)))
            (doseq [[k [c v]] (dissoc summary k)]
            (println (format "   %-60s %5d:  %9.3f ms (%.3f ms)" (str k \:) c (/ v 1000000.0) (/ (/ v 1000000.0) c)))))))))

  (with-perf perf-logger
    (lupapalvelu.perf-test/d))


  ; Instrument public fn's from namespace like this:

  (instrument-ns 'lupapalvelu.perf-test)

  ; Run like this:

  (with-perf (fn [c] (println "C:") (clojure.pprint/pprint c))
    (lupapalvelu.perf-test/d))

  (lupapalvelu.perf-test/c))
