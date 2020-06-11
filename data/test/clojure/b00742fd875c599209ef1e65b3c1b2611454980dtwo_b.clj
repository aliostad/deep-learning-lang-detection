(ns adventofcode1.two-b
  "http://adventofcode.com/2016/day/2"
  (:require
   [clojure.spec :as s]
   [clojure.spec.gen :as gen]
   [clojure.spec.test :as stest]

   [clojure.core.match :refer [match]]

   spyscope.core
   adventofcode1.spec-test-instrument-debug
   )
  )

(s/def ::key #{:1 :2 :3 :4 :5 :6 :7 :8 :9 :A :B :C :D})

(def up
  {                :1 nil,
           :2 nil, :3 :1,  :4 nil,
   :5 nil, :6 :2,  :7 :3 , :8 :4 , :9 nil,
           :A :6 , :B :7 , :C :8,
                   :D :B
   })

(def down
  {                :1 :3 ,
           :2 :6 , :3 :7,  :4 :8 ,
   :5 nil, :6 :A,  :7 :B , :8 :C , :9 nil,
           :A nil, :B :D , :C nil
                   :D nil
   })

(def left
  {                :1 nil,
           :2 nil, :3 :2,  :4 :3 ,
   :5 nil, :6 :5,  :7 :6 , :8 :7 , :9 :8 ,
           :A nil, :B :A , :C :B,
                   :D nil
   })

(def right
  {                :1 nil,
           :2 :3 , :3 :4,  :4 nil,
   :5 :6 , :6 :7,  :7 :8 , :8 :9 , :9 nil,
           :A :B , :B :C , :C nil,
                   :D nil
   })

(s/def ::move #{\U \D \L \R})

(s/fdef move-or-ignore
        :args (s/cat :current ::key :move ::move)
        :ret ::key)

(defn move-or-ignore
  "Move if possible, otherwise stay at key"
  [current move]
  (or (current (match move
                 \U up
                 \D down
                 \R right
                 \L left))
      ;; if nil above, stay at same key
      current))

(s/fdef row-2
        :args (s/cat :current ::key :moves (s/coll-of ::move))
        :ret ::key)

(defn row-2
  [current moves]
  (if (empty? moves) current
      (recur (move-or-ignore current (first moves))
             (rest moves))))


(s/fdef row
        :args (s/cat :current ::key :moves string?)
        :ret ::key)

(defn row
  "Find the value for one row of moves"
  [current moves]
  ;; problem found with (stest/check `row) and (stest/check `rows)
  ;; use vec to turn nil into [], so that row-2 knows it will get a collection
  (row-2 current (vec (seq moves))))

(s/fdef rows
        :args (s/or :base (s/cat :list-of-moves (s/coll-of string?))
                    :rec  (s/cat :answer (s/coll-of ::key) :current ::key :list-of-moves (s/coll-of string?)))
        :ret (s/coll-of ::key))

(defn rows
  "Start at button 5 and process moves row by row."
  ([list-of-moves](rows [] :5 list-of-moves))
  ([answer current list-of-moves]
   (if (empty? list-of-moves) answer
       (let [new-current (row current (first list-of-moves))]
         (recur (conj answer new-current) new-current (rest list-of-moves))))))


(clojure.spec.test/instrument)
