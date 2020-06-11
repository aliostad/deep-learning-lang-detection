(ns playing-with-spec.one-fish-spec-fish
  (:require [clojure.spec :as s]
            [clojure.spec.gen :as gen] ;; required. see https://clojure.org/guides/spec#_generators
            [clojure.spec.test :as stest]
            [clojure.test.check :as test]))

; from http://gigasquidsoftware.com/blog/2016/05/29/one-fish-spec-fish/

(def fish-numbers {0 "Zero"
                   1 "One"
                   2 "Two"})

(s/def ::color #{"Red" "Blue" "Dun"})
(s/def ::fish-number (set (keys fish-numbers)))
#_(s/def ::first-line (s/cat :n1 ::fish-number :n2 ::fish-number :c1 ::color :c2 ::color))

(defn one-bigger? [{:keys [n1 n2]}]
  (= n2 (inc n1)))

#_(s/def ::first-line (s/and (s/cat :n1 ::fish-number :n2 ::fish-number :c1 ::color :c2 ::color)
                           one-bigger?
                           #(not= (:c1 %) (:c2 %))))

(comment
  ;generate single or multiple valid samples
  (gen/generate (s/gen ::first-line))
  ;=> (0 1 "Dun" "Red")

  (gen/sample (s/gen ::first-line))
  ;=>
  ((1 2 "Red" "Dun")
    (1 2 "Dun" "Red")
    (0 1 "Blue" "Dun")
    (0 1 "Red" "Blue")
    (0 1 "Blue" "Dun")
    (0 1 "Red" "Blue")
    (1 2 "Blue" "Red")
    (1 2 "Dun" "Blue")
    (0 1 "Red" "Blue")
    (1 2 "Dun" "Red")))

(comment
  ; generated and conformd values for a spec
  (distinct (s/exercise ::first-line))
  ;=>
  ([(0 1 "Blue" "Dun") {:n1 0, :n2 1, :c1 "Blue", :c2 "Dun"}]
    [(0 1 "Dun" "Blue") {:n1 0, :n2 1, :c1 "Dun", :c2 "Blue"}]
    [(0 1 "Dun" "Red") {:n1 0, :n2 1, :c1 "Dun", :c2 "Red"}]
    [(0 1 "Red" "Blue") {:n1 0, :n2 1, :c1 "Red", :c2 "Blue"}]
    [(0 1 "Blue" "Red") {:n1 0, :n2 1, :c1 "Blue", :c2 "Red"}]
    [(1 2 "Red" "Blue") {:n1 1, :n2 2, :c1 "Red", :c2 "Blue"}]))

(defn fish-number-rhymes-with-color? [{n :n2 c :c2}]
  (or
    (= [n c] [2 "Blue"])
    (= [n c] [1 "Dun"])))

(s/def ::first-line (s/and (s/cat :n1 ::fish-number :n2 ::fish-number :c1 ::color :c2 ::color)
                           one-bigger?
                           #(not= (:c1 %) (:c2 %))
                           fish-number-rhymes-with-color?))

(defn fish-line [n1 n2 c1 c2]
  (clojure.string/join " "
                       (map #(str % " fish.")
                            [(get fish-numbers n1)
                             (get fish-numbers n2)
                             c1
                             c2])))

;spec-ing an entire fn
(s/fdef fish-line
        :args ::first-line
        :ret  string?)
; :fn optional can also define relationship between args & return value

(stest/instrument `fish-line)
(comment
  ; instrument validates fn output
  (fish-line 2 1 "Red" "Blue")
  ;ExceptionInfo Call to #'playing-with-spec.one-fish-spec-fish/fish-line did not conform to spec:
  ;val: {:n1 2, :n2 1, :c1 "Red", :c2 "Blue"} fails at: [:args] predicate: one-bigger?
  ;:clojure.spec/args  (2 1 "Red" "Blue")
  ;:clojure.spec/failure  :instrument
  ;:clojure.spec.test/caller  {:file "form-init3387819448100977184.clj", :line 1, :var-scope playing-with-spec.one-fish-spec-fish/eval5022}
  ;clojure.core/ex-info (core.clj:4725)
  )

(comment
  (map #(apply fish-line %) (-> (s/gen ::first-line) (gen/sample) (distinct)))
  ("One fish. Two fish. Red fish. Blue fish."
    "Zero fish. One fish. Blue fish. Dun fish."
    "One fish. Two fish. Dun fish. Blue fish."
    "Zero fish. One fish. Red fish. Dun fish."))