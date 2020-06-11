(ns mini-occ.test-with-specs
  (:require [mini-occ.core :as m]
            [clojure.test :as test]
            [clojure.spec.test :as stest]))

(defn activate-specs []
  (stest/instrument 
    (filter (comp #{'mini-occ.core} symbol namespace)
            (stest/instrumentable-syms))))

(println "Activated specs:\n" (activate-specs))
(println "To prove specs are actually enabled, here is a bad call to (unparse-prop nil)")
(println
  (try (m/unparse-prop nil)
       (catch Throwable e e)))

(prn "The above lines should show a spec error from a bad call to (unparse-prop nil)")

(test/run-tests 'mini-occ.core)
