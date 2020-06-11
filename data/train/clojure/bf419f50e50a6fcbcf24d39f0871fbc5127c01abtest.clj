(require '[clojure.spec :as s])
(require '[clojure.spec.test :as st])

(s/def ::suit #{:club :diamond :heart :spade})
(s/explain ::suit 42)

(defn adder [x] #(+ x %))

(s/fdef adder
  :args (s/cat :xs (s/* number?) :bs bool? :ys (s/+ string?))
  :ret (s/fspec :args (s/cat :y number?)
                :ret number?)
  :fn #(= (-> % :args :x) ((:ret %) 0)))

(stest/instrument `adder)

(adder 1 false true)

(s/conform (s/cat :hi (s/+ number?)) 2)

(s/conform (s/* (s/cat :num number? :str string?)) [[2 "3"] [3 "4"]])


(s/def ::args-spec (s/and (s/cat :a (s/+ number?) :b (s/+ boolean?))
             #(> (count (:a %)) 2)))

(s/fdef a-fn
  :args ::args-spec)

(defn a-fn [m n o p q]
  m)

(st/instrument `a-fn)

(a-fn 2 3 4 false false)

(s/conform ::args-spec [2 3 true false])

(s/def ::k1 (s/map-of keyword? (s/cat :a number? :b number?)))
(s/def ::k2 (s/map-of keyword? (s/cat :c string? :d string?)))

(s/conform ::k1 {:a1 [1 2] :a2 [3 4]})

(s/def ::m1 (s/merge ::k1 ::k2))

(s/explain ::m1 {:a1 [1 2] :a2 [3 4]})
