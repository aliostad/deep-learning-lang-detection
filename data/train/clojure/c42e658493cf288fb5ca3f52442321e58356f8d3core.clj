(ns lndclj-spec.core
  (:require [clojure.spec :as s]
            [clojure.spec.test :as stest]
            [clojure.spec.gen :as gen]))

(s/def ::str  (s/and string?
                     #(>= (count %) 5)
                     #(<= (count %) 10)
                     (partial re-matches #"^[a-z]{5,10}$")))

(s/def ::str2 (s/every char?))

(s/valid? ::str2 "testing")

(s/fdef str-identity
        :args (s/cat :word ::str)
        :ret ::str)

(defn str-identity
  [word]
  ;{:pre [(s/valid? ::str word)]}
  word)

(stest/instrument 'lndclj-spec.core/str-identity)
(stest/instrument `str-identity)

(gen/generate (s/gen ::str))

(gen/generate (s/gen (s/coll-of number? :min-count 100 :max-count 200 :distinct true)))

(apply str (gen/generate (s/gen (s/coll-of (s/and char? #(re-matches #"[a-z]" (str %))) :min-count 100 :max-count 200))))


(str-identity "test")


(defn string-spec [regex]
  (reify
    s/Spec
    (conform* [_ x] (if (re-matches regex x) x :clojure.spec/invalid))
    (unform* [_ x] x)
    (explain* [_ path via in x] [{:path path :pred `() :val x :via via :in in}])
    (gen* [_ overrides path rmap] "here is a string")
    (with-gen* [_ gfn] "another string")
    (describe* [_] "A Regular Expresion")))

(s/def ::new-string (string-spec #"^[a-z]*$"))

(s/explain ::new-string "ab1")
(s/explain ::str "ab1")

















(s/fdef clojure.core/inc
        :args (s/cat :x number?)
        :return boolean?)

(s/fdef clojure.core/declare
        :args (s/cat :names (s/* simple-symbol?))
        :ret any?)

(defn ranged-rand
  "Returns random int in range start <= rand < end"
  [start end]
  (+ start (long (rand (- end start)))))

(s/fdef ranged-rand
        :args (s/and (s/cat :start int? :end int?)
                     #(< (:start %) (:end %)))
        :ret int?
        :fn (s/and #(>= (:ret %) (-> % :args :start))
                   #(< (:ret %) (-> % :args :end))))

(ranged-rand 10.5 123)


