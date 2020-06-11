(ns metapp.specs.Pricing
  (:require
    [clojure.spec :as s]
    [clojure.spec.test :as st]))


(s/def ::PriceValue (s/and float? pos?))
(s/def ::Price
  (s/keys :req
          [::type
           ::instrument
           ::time
           ::status
           ::tradeable
           ::bids
           ::asks
           ::asks
           ::closeoutBid
           ::closeoutAsk
           ]))
(s/def ::PriceBucket
  (s/keys :req
          [::price
           ::liquidity]))

(s/def ::PriceStatus #{"tradeable" "non-tradeable" "invalid"})
(s/def ::UnitsAvailable
  (s/keys :req
          [::default
           ::reduceFirst
           ::reduceOnly
           ::openOnly]))
(s/def ::PricingHeartbeat
  (s/keys :req
          [::type
           ::time]))
