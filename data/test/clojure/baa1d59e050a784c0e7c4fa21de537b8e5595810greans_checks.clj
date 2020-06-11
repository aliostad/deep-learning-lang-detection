(ns org.nfrac.xotarium.greans-checks
  (:require [org.nfrac.xotarium.grn.greans :as grn]
            [clojure.spec.test :as stest]
            [clojure.test.check.clojure-test :as ctcc]
            [clojure.test :as t
             :refer (is deftest testing run-tests)]))

(alter-var-root #'ctcc/*report-shrinking* (constantly true))
(alter-var-root #'ctcc/*report-trials* (constantly ctcc/trial-report-periodic))

(alias 'stc 'clojure.spec.test.check)
(def opts {::stc/opts {:num-tests 50}})

(def instr-syms
  (concat
   (stest/enumerate-namespace 'org.nfrac.xotarium.grn.greans)
   ))

(deftest greans-fns-test
  (stest/instrument instr-syms)
  (-> `[grn/genome-switch-io
        grn/mutate-elements
        grn/mutate-structure
        grn/crossover]
      (stest/check opts)
      (stest/summarize-results))
  (stest/unstrument))
