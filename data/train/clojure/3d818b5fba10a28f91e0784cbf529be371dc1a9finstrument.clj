(ns clj-meetup-spec-talk.instrument
  (:require [clojure.spec :as s]
            [clojure.pprint :refer [pprint]]))

;; examples from http://clojure.org/guides/spec

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

(comment
  (clojure.repl/doc ranged-rand)

  (ranged-rand 2 0)

  (s/instrument #'ranged-rand)

  (ranged-rand 2 0)

  (s/unstrument #'ranged-rand)

  (ranged-rand 2 0)
  )

;; card game example from http://clojure.org/guides/spec

(def suit? #{:club :diamond :heart :spade})
(def rank? (into #{:jack :queen :king :ace} (range 2 11)))
(def deck (for [suit suit? rank rank?] [rank suit]))

(s/def ::card (s/tuple rank? suit?))
(s/def ::hand (s/* ::card))

(s/def ::name string?)
(s/def ::score int?)
(s/def ::player (s/keys :req [::name ::score ::hand]))

(s/def ::players (s/* ::player))
(s/def ::deck (s/* ::card))
(s/def ::game (s/keys :req [::players ::deck]))

(def kenny
  {::name "Kenny Rogers"
   ::score 100
   ::hand []})

(s/valid? ::player kenny)

(comment
  (pprint
   (s/explain-data ::game
                   {::deck deck
                    ::players [{::name "Kenny Rogers"
                                ::score 100
                                ::hand [[2 :banana]]}]}))
  )
