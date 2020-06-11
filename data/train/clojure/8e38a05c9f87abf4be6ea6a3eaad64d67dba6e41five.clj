(ns adventofcode1.five
  "http://adventofcode.com/2016/day/4"
  (:require
   [clojure.spec :as s]
   [clojure.spec.gen :as gen]
   [clojure.spec.test :as stest]
   [com.gfredericks.test.chuck.generators :as gen']
   [clojure.test.check :as tc]
   [clojure.test.check.generators :as tcgen]
   [clojure.test.check.properties :as tcprop]

   [clojure.core.match :refer [match]]

   spyscope.core
   adventofcode1.spec-test-instrument-debug))


;; (second (re-find (re-matcher #"^00000(.)" (mw.hash/hash-md5 "abc3231923"))))
;; => "1"
;; else nil

(s/fdef next-char
        :args (s/cat :text string? :idx int?)
        :ret  (s/or :miss nil? :char string?))

(defn next-char
  [text idx]
  (second (re-find (re-matcher #"^00000(.)" (mw.hash/hash-md5 (str text idx))))))

(s/fdef next-chars
        :args (s/or :start (s/cat :text string?) :cont (s/cat :text string? :idx int?))
        :ret  (s/coll-of string?))

(defn next-chars-temp
  ([text] (next-chars text 0))
  ([text idx]
   (->> (range idx 10000000)
    (filter #(next-char text %)))))

(defn next-chars
  ([text] (next-chars text 0))
  ([text idx]
   (->> (range idx 10000000)
        ;; keep = filter + map
        (keep #(next-char text %)))))

(defn puzzle-five
  [text]
  (clojure.string/join (take 8 (adventofcode1.five/next-chars text))))

;; adventofcode1.five> (clojure.string/join (take 8 (adventofcode1.five/next-chars "cxdnnyjw")))
;; "f77a0e6e"



(clojure.spec.test/instrument)

;; how to run all check functions for this namespace
;;
;; (-> (stest/enumerate-namespace 'adventofcode1.four2) stest/check)
;;
;; checked code of check, and it uses pmap already!
