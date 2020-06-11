(ns specexp.spec1
  (:require
   [mw.std :refer :all]
   [clojure.tools.logging :as log]
   [clojure.spec.alpha :as s]
   [orchestra.spec.test :as stest]))

;; How to relate two separate arguments, for example a vector and an idx into the vector

(s/fdef index-in-first-half?
        :args (s/cat :args map?)
        :ret  boolean?)

(defn index-in-first-half?
  "Relating several args is easy, since we get a map with the named args.
   The names used are from s/cat."
  [args]
  (< (:ii args) (/ (inc (count (:xs args))) 2)))

(s/fdef get-only-first-half
        :args (s/and (s/cat :xs vector? :ii integer?)
                     index-in-first-half?)
        :ret some?)

(defn get-only-first-half
  "return the `ii` element of `xs`."
  [xs ii]
  (nth xs ii))

(orchestra.spec.test/instrument)
