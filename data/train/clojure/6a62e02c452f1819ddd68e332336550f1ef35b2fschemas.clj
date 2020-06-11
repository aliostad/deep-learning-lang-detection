(ns melos.schemas
  (:require [schema.core :as s]))

(s/defrecord Note
    [type                    :- s/Keyword
     count                   :- s/Int
     dissonance-contributor? :- s/Bool
     group                   :- s/Symbol
     instrument              :- s/Keyword
     is-rest?                :- s/Bool
     max-count               :- s/Int
     merge-left?             :- s/Bool
     merge-right?            :- s/Bool
     notation                :- s/Any
     part                    :- s/Keyword
     pitch                   :- s/Int])

(s/defrecord Chord
    [type        :- s/Keyword
     check-dissonance :- s/Bool
     duration    :- s/Num
     tempo       :- s/Int
     phrase-end? :- s/Bool
     is-rest?    :- s/Bool
     events      :- [Note]])

(def Phrase (s/both (s/pred (complement empty?))
                    [Chord]))

(def DurationVector (s/pair s/Int "Numerator" s/Int "Denominator"))

(def Duration s/Num)

(def RhythmTreeNode
  (s/conditional :event
                 {:type                   s/Keyword
                  :duration               Duration
                  :sum-of-leaves-duration Duration
                  :chord                  (s/maybe Note)
                  :children               (s/pred nil?)}
                 :children
                 {:type                   s/Keyword
                  :duration               Duration
                  :sum-of-leaves-duration Duration
                  :chord                  (s/pred nil?)
                  :children               [(s/maybe (s/recursive #'RhythmTreeNode))]}))

(def DissonanceMapping {s/Num s/Num})

(def Voice {:type s/Keyword
            :measures s/Any})

(def Staff {:type s/Keyword
            :voices [Voice]})

(def Section {:type s/Keyword
              :staves [Staff]})

(def Score {:type s/Keyword
            :sections [Section]})
