(ns zombie-run.spec-check
  (:require [clojure.test :refer :all]
            [clojure.spec.test.alpha :as stest]
            [zombie-run.game]))

(def symbols-under-test (stest/enumerate-namespace 'zombie-run.game))

(defn instrument-function-specs []
  (stest/instrument symbols-under-test))

(deftest check-specs-test
  (let [report (stest/check symbols-under-test)]
    (if (zero? (count report))
      (throw (Exception. "No spec reports found."))
      (doseq [report report]
        (let [result (get-in report [:clojure.spec.test.check/ret :result])]
          (when-not (true? result)
            (prn (:failure report)))
          (is (true? result)))))))
