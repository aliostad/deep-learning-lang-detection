(ns ircbook-viewer.data.order
  (:require [schema.core :as s]
            [cheshire.core :as j :refer :all]
            [clj-time.core :as t]
            [clj-time.coerce :as co]))


(def Order
  (let [non-neg #(>= % 0)] 
    {:account-id s/Str
     :side (s/enum :ask :bid)
     :instrument-id s/Str
     :price (s/pred #(and (decimal? %)
                          (<= % 100)
                          (non-neg %)))
     :num-shares (s/pred #(and (decimal? %)
                               (non-neg %)))
     :timestamp org.joda.time.DateTime
     :rank (s/maybe (s/pred non-neg))}))

(def sample-order
  {:account-id "modulus"
   :side :ask
   :instrument-id "trump"
   :price (bigdec 1)
   :num-shares (bigdec 1000)
   :timestamp (t/now)
   :rank nil})

(s/defn parse-order :- Order
  [[acc-id side inst-id price n-shares date rank]]
  {:account-id acc-id
     :side (if (= side "a") :ask :bid)
     :instrument-id inst-id
     :price (BigDecimal. price)
     :num-shares (BigDecimal. n-shares)
     :date (let [[y mo d h m s ns] date]
             (t/date-time y mo d h m s (/ ns 1000)))
     :rank rank})

