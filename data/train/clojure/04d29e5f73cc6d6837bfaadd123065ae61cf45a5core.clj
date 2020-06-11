(ns clj-data-science.core
  (:gen-class)
  (:require [clojure.spec.alpha :as spec]
            [clojure.spec.test.alpha :as spec.test]
            [expound.alpha :as expound]
            [spec-provider.provider :as spec.provider]))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

;; ----- spec dev tools -----

(set! spec/*explain-out* (expound/custom-printer {:show-valid-values? true})) ; show valid values
(spec.test/instrument)

(comment (set! spec/*explain-out* spec/explain-printer) ; default
         (set! spec/*explain-out* expound/printer)      ; ...
         (set! spec/*explain-out* (expound/custom-printer {:show-valid-values? true})) ; show valid values

         (spec.test/instrument)
         (spec.test/unstrument)
         :end
         )
