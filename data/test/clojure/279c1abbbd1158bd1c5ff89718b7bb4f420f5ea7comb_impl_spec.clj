(ns comb-impl-spec
  (:require [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [clojure.spec.test :as stest]))


(declare combine-two)

(s/def :combine/param (s/coll-of string? :type vector?))

(s/fdef combine-two
        :args (s/cat :f :combine/param :s :combine/param)
        :ret :combine/param
        :fn #(= (count (:ret %)) (* (count (-> % :args :f))
                                    (count (-> % :args :s)))))


(defn combine-two
  "Combine two  "
  [f s]
  ;{:pre [(s/valid? :combine/param f)]}
  (for [f1 f
        s1 s]
    (str f1 s1)))






(comment

  (max 1 2)


  (gen/sample (s/gen :combine/param) 3)

  (s/exercise :prac/in 3)
  (s/exercise-fn `combine-two 3)

  (stest/check `combine-two)

  (stest/instrument `combine-two)

  (clojure.repl/doc combine-batch)



  ;(return-count [["s"] ["1" "2"] ["a" "b" "c"] ["r" "p" "q" "o"] ] )

  (combine-two ["s" "t" "p"] ["1" "2"])
  (combine-two ["1" "2"] ["s" "t" "p"])




  (clojure.repl/doc combine-two)

  )

