(ns bigmouth.test-runner
  (:require  [clojure.test :as t]
             [clojure.spec.test.alpha :refer [instrument unstrument]]
             [eftest.runner :as eftest]
             [eftest.report.pretty :as pretty]
             [eftest.report.progress :as progress]))

(defn run-tests [& {:keys [reporter] :or {reporter :progress}}]
  (let [reporter (case (keyword reporter)
                   :progress progress/report
                   :pretty pretty/report
                   :core.test t/report)]
    (instrument)
    (try
      (eftest/run-tests (eftest/find-tests "test") {:report reporter})
      (finally
        (unstrument)))))

(defn -main [& [reporter]]
  (let [reporter (or reporter :progress)]
    (run-tests :reporter reporter))
  (shutdown-agents))
