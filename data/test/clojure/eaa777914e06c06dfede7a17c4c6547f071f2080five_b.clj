(ns adventofcode1.five-b
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

(s/def ::pos string?)
(s/def ::chr string?)
(s/def ::poss (s/coll-of (s/keys :req-un [::pos ::chr])))

(s/fdef next-char
        :args (s/cat :text string? :idx int?)
        :ret  (s/or :miss nil? :hit ::poss))

(defn next-char
  [text idx]
  (if-let [[_ pos chr] (re-find (re-matcher #"^00000(.)(.)(.)" (mw.hash/hash-md5 (str text idx))))]
    {:pos pos :chr chr}))

(s/fdef next-chars
        :args (s/or :start (s/cat :text string?) :cont (s/cat :text string? :idx int?))
        :ret  (s/coll-of ::poss))

(defn next-chars
  ([text] (next-chars text 0))
  ([text idx]
   (->> (range idx 1000000000)
        (keep #(next-char text %)))))

(s/fdef aset-if-nil
        :args (s/cat :arr (constantly true) :idx int? :val (constantly true))
        :ret  (constantly true))

(defn aset-if-nil
  "Set value of array unless already set."
  [arr idx val]
  (if (aget arr idx)
    nil
    (aset arr idx val)))

(s/fdef organize-result
  :args (s/cat :poss ::poss)
  :ret  string?)

(defn organize-result
  [poss]
  (let [res (make-array String 8)]
    (doseq [x poss]
      (if (< (compare (:pos x) "8") 0)
        (aset-if-nil res (int (bigint (:pos x)))(:chr x))))
    (assert (every? #(not (nil? %)) (seq res)) (str "not enough values found: " + (seq res)))
    (clojure.string/join (seq res))))


(defn puzzle-five-b
  ([text] (puzzle-five-b 20 text))
  ([tries text]
   (organize-result (take tries (next-chars text)))))


;; adventofcode1.five> (clojure.string/join (take 8 (adventofcode1.five/next-chars "cxdnnyjw")))
;; "f77a0e6e"



(clojure.spec.test/instrument)

;; how to run all check functions for this namespace
;;
;; (-> (stest/enumerate-namespace 'adventofcode1.four2) stest/check)
;;
;; checked code of check, and it uses pmap already!
