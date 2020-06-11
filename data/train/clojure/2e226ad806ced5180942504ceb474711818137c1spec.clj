(ns invetica.test.spec
  "Useful test functions/macros for working with clojure.spec."
  (:require
   [clojure.pprint :refer [pprint]]
   [clojure.spec.test.alpha :as stest]
   ;; Do not remove the `clojure.test.check` require or Cider will break!
   ;;
   ;; See https://github.com/clojure-emacs/cider/issues/1841.
   [clojure.test.check]
   [clojure.test :refer [is]]))

(defn instrument
  "Convenience function compatible with `clojure.test/use-fixtures`, that will
  instrument a test run.

  E.g.

      (clojure.test/use-fixtures :once test.spec/instrument)"
  [f]
  (try
    (stest/instrument)
    (f)
    (finally
      (stest/unstrument))))

(defn is-well-specified
  "Checks all of the vars in namespace `ns`, and pretty prints any failures."
  [ns]
  (doseq [result (stest/check (stest/enumerate-namespace ns))]
    (is (-> result :failure nil?)
        (with-out-str
          (pprint (stest/abbrev-result result))))))
