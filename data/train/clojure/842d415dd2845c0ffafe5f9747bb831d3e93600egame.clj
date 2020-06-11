(ns blackjack.game
  (:require [clojure.spec :as s]
            [clojure.pprint :as p]
            [clojure.spec.test :as stest]))

(def all  [[[::hard 4] ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 5] ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 6] ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 7] ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 8] ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 9] ::Hit ::Double ::Double ::Double ::Double ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 10] ::Double ::Double ::Double ::Double ::Double ::Double ::Double ::Double ::Hit ::Hit]
           [[::hard 11] ::Double ::Double ::Double ::Double ::Double ::Double ::Double ::Double ::Hit ::Hit]
           [[::hard 12] ::Hit ::Hit ::Stand ::Stand ::Stand ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 13] ::Stand ::Stand ::Stand ::Stand ::Stand ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 14] ::Stand ::Stand ::Stand ::Stand ::Stand ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 15] ::Stand ::Stand ::Stand ::Stand ::Stand ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 16] ::Stand ::Stand ::Stand ::Stand ::Stand ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::hard 17] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::hard 18] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::hard 19] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::hard 20] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::hard 21] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::soft 13] ::Hit ::Hit ::Hit ::Double ::Double ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::soft 14] ::Hit ::Hit ::Hit ::Double ::Double ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::soft 15] ::Hit ::Hit ::Double ::Double ::Double ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::soft 16] ::Hit ::Hit ::Double ::Double ::Double ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::soft 17] ::Hit ::Double ::Double ::Double ::Double ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::soft 18] ::Stand ::Double ::Double ::Double ::Double ::Stand ::Stand ::Hit ::Hit ::Hit]
           [[::soft 19] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::soft 20] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::soft 21] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::pair 2] ::Split ::Split ::Split ::Split ::Split ::Split ::Hit ::Hit ::Hit ::Hit]
           [[::pair 3] ::Split ::Split ::Split ::Split ::Split ::Split ::Hit ::Hit ::Hit ::Hit]
           [[::pair 4] ::Hit ::Hit ::Hit ::Split ::Split ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::pair 5] ::Double ::Double ::Double ::Double ::Double ::Double ::Double ::Double ::Hit ::Hit]
           [[::pair 6] ::Split ::Split ::Split ::Split ::Split ::Hit ::Hit ::Hit ::Hit ::Hit]
           [[::pair 7] ::Split ::Split ::Split ::Split ::Split ::Split ::Hit ::Hit ::Hit ::Hit]
           [[::pair 8] ::Split ::Split ::Split ::Split ::Split ::Split ::Split ::Split ::Hit ::Hit]
           [[::pair 9] ::Split ::Split ::Split ::Split ::Split ::Stand ::Split ::Split ::Stand ::Stand]
           [[::pair 10] ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand ::Stand]
           [[::pair 11]  ::Split ::Split ::Split ::Split ::Split ::Split ::Split ::Split ::Split ::Hit]])

(def rules-lookup (into {} (mapv (fn [full] {(first full) (into {} (map-indexed (fn [_ t] [(+ _ 2) t]) (vec (next full))))}) all)))

(s/def ::suit #{::club ::diamond ::heart ::spade})

(s/def ::ranks #{::r2 ::r3 ::r4 ::r5 ::r6 ::r7 ::r8 ::r9 ::r10 ::jack ::queen ::king ::ace})

(def rank-sum {::r2    2
               ::r3    3
               ::r4    4
               ::r5    5
               ::r6    6
               ::r7    7
               ::r8    8
               ::r9    9
               ::r10   10
               ::jack  10
               ::queen 10
               ::king  10
               ::ace   11})

(s/def ::card (s/tuple ::suit ::ranks))

(s/def ::move #{::Hit ::Stand ::Split ::Double})

(s/def ::player-hand-type #{::hard ::soft ::pair})

(s/def ::dealer-hand ::card)

(s/def ::player-hand (s/tuple ::card ::card))

(s/def ::situation (s/keys :req [::dealer-hand ::player-hand]))

(s/def ::resolved-situation (s/keys :req [::dealer-hand ::player-hand ::move]))

(defn compare-rank [card1 card2]
  (= (second card1) (second card2)))

(defn handtype [player-hand]
  (cond
    (reduce compare-rank player-hand) ::pair
    (some #{::ace} (map second player-hand)) ::soft
    :else ::hard))

(s/fdef handtype
        :args (s/cat :player-hand ::player-hand)
        :ret ::player-hand-type)

(stest/instrument `handtype)
#_(stest/check `handtype)

(defn score [card]
  (rank-sum (second card)))

(s/fdef score
        :args (s/cat :card ::card)
        :ret int?)
(stest/instrument `score)

(defn sum [player-hand]
  (apply + (map score player-hand)))

(s/fdef sum
        :args (s/cat :player-hand ::player-hand)
        :ret int?)
(stest/instrument `sum)

(defn lookup-hand [player-hand]
  (let [t (handtype player-hand)]
    [t (if (= t ::pair) (score (first player-hand)) (sum player-hand))]))

(s/fdef lookup-hand
        :args (s/cat :player-hand ::player-hand)
        :ret (s/tuple ::player-hand-type int?))
(stest/instrument `lookup-hand)

(defn correct-action [situation]
  (let [dealer (score (::dealer-hand situation))
        player (lookup-hand (::player-hand situation))]
    ((rules-lookup player) dealer)))

(s/fdef correct-action
        :args (s/cat :situation ::situation)
        :ret ::move)
(stest/instrument `correct-action)

(defn generate-random-situation []
  (rand-nth (map first (s/exercise ::situation))))
(s/fdef generate-random-situation
        :ret ::situation)
(stest/instrument `generate-random-situation)

(generate-random-situation)
