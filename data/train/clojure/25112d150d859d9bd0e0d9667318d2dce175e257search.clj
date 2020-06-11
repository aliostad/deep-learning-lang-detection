(ns thompson.search
  (:require [thompson.util :as tutil]))


(declare accepts?)
(declare nfa-accepts?)
(declare dfa-accepts?)
(declare search)


(defmulti accepts?
  (fn [fsa _] (:graph-type fsa)))

(defmethod accepts? :NFA [nfa stream]
  (nfa-accepts? nfa stream))

(defmethod accepts? :DFA [dfa stream]
  (dfa-accepts? dfa stream))

(defn nfa-accepts? [nfa stream]
  (loop [queue (list [(:start nfa) stream])
         transition (:transition nfa)]
    (if (empty? queue)
      false
      (let [[cur-state cur-stream] (peek queue)
            queue (pop queue)]
        (if (empty? cur-stream)
          (or (tutil/final? cur-state)
              (recur (into queue
                           (map #(vector %1 cur-stream)
                                (get-in transition [cur-state :null])))
                     transition))
          (recur (-> queue
                     (into (map #(vector %1 cur-stream)
                                (get-in transition [cur-state :null])))
                     ;(into (map #(vector %1 (rest cur-stream))
                     ;           (get-in transition [cur-state :any])))
                     (into (map #(vector %1 (rest cur-stream))
                                (get-in transition [cur-state (first cur-stream)]))))
                 transition))))))

(defn dfa-accepts? [dfa stream]
  (loop [cur-state (:start dfa)
         cur-stream stream]
    (if (empty? cur-stream)
      (tutil/final? cur-state)
      (let [token (first cur-stream)
            next-state (get-in (:transition dfa) [cur-state token])
            next-stream (rest cur-stream)]
        (if (not (nil? next-state))
          (recur next-state next-stream)
          false)))))

(comment
  (defn search [dfa string]
    :TODO))
