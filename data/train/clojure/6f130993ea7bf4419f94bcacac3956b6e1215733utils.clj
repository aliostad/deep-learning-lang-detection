(ns ppi-query.test.utils
  (:require [clojure.test :as t]
            [clojure.pprint :as pprint]
            [clojure.spec.alpha :as s]
            [clojure.spec.test.alpha :as stest]
            [clojure.template :as temp]
            [clojure.test.check.generators :as gen]
            [io.aviso.exception :refer :all]
            [aprint.core :refer :all]))

(defmacro are-spec [spec & {:keys [valid invalid]}]
  "Assert that the given data samples conforms to the given clojure spec."
  (let [value-sym (gensym "value")]
    `(do
      (when ~valid
        (temp/do-template [~value-sym]
          (t/is
           ; Value should conform to spec
           (s/valid? ~spec ~value-sym)
           ; If not: explain why it doesn't conform
           (->> (s/explain-data ~spec ~value-sym)
                (:clojure.spec.alpha/problems)
                (aprint) ; pretty print with colors!
                (with-out-str)
                (str "\nNot conforming:\n")))
          ~@valid))
      (when ~invalid
        (temp/do-template [~value-sym]
          (t/is
           ; Value should conform to spec
           (not (s/valid? ~spec ~value-sym))
           ; If not: explain how it conforms
           (->> (s/conform ~spec ~value-sym)
                (aprint) ; pretty print with colors!
                (with-out-str)
                (str "\nConforming:\n")))
          ~@invalid)))))

(def trace-i (atom 0))
(defn trace [x]
  (println "trace" @trace-i x)
  (swap! trace-i inc)
  x)

(defn xml-gen [& {:keys [tag attrs content]}]
  "Creates an xml node generator.
   Example: (gen/sample (xml-gen :tag :a :content (gen/tuple gen/int)))
            => ({:tag :a, :content [9], :attrs nil}, ...)"
  (let [to-gen #(if (gen/generator? %) % (gen/return %))]
    (gen/hash-map :tag (to-gen tag)
                  :attrs (to-gen attrs)
                  :content (to-gen content))))

;;; Utility functions combining clojure.spec.alpha test check and clojure test
;;; inspired by:
;;; https://gist.github.com/Risto-Stevcev/dc628109abd840c7553de1c5d7d55608

(defn summarize-result [abbr-result]
  (str
    "\n"
    "[ " (:sym abbr-result) " ]"
    "\n"
    (let [failure (:failure abbr-result)]
      (if (-> failure :clojure.spec.alpha/failure)
        ; Pretty print spec problems
        (->> failure
             (aprint)
             (with-out-str)
             (apply str))
        ; Pretty print exception
        (->> failure
             (format-exception)
             (apply str))))))

;; Utility functions to integrate clojure.spec.test/check with clojure.test
(defn summarize-results' [results]
  "Generate summary of spec test check results"
  (->> results
       (map (comp summarize-result stest/abbrev-result))
       (apply str)))

(defn succeed? [results]
  "Check if the clojure.spec.alpha check test results are successful"
  (every? (comp nil? :failure) results))

; Limit number of generative tests for now
; TODO: find a way to keep 100 tests in cache and only re-run them on
;       modification of functions and specs (implies also re-run
;       on modification of functions and specs depended on)
(def num-tests 1)

(defn check'
  "Combine clojure.test/is and clojure.spec.test/check"
  ([sfn] (check' sfn {}))
  ([sfn opts]
   (stest/instrument sfn)
   (let [xopts (assoc opts :clojure.spec.test.check/opts
                           {:num-tests num-tests}) ; restrict number of tests
         results (stest/check sfn xopts)
         results-successful? (succeed? results)]
     (t/is results-successful?
           (when-not results-successful?
             (summarize-results' results))))))

(def count-is (fn [cnt seq] (t/is (= cnt (count seq)))))

(defmacro deftest* [name & body]
  "Same as deftest but with clojure.spec.test instrument and unstrument
   called before and after"
  `(t/deftest ~name
    (stest/instrument)
    ~@body
    (stest/unstrument)))

(defn instrument-stub-return [fn ret-spec ret-gen]
  "Stub a function by providing a generator for its return spec"
  (stest/instrument fn
    {:stub #{fn}
     :spec {fn (s/fspec :args any? :ret (s/with-gen ret-spec ret-gen))}}))
