(ns metapp.specs.Instrument
  (:require
    [clojure.spec :as s]
    [clojure.spec.test :as st]
    [metapp.specs.Pricing :only [::PriceValue]]))

(s/def ::CandlestickGranularity #{"S5" "S10" "S15" "S30"
                                  "M1" "M2" "M4" "M5" "M10" "M15" "M30"
                                  "H1" "H2" "H3" "H4" "H6" "H8" "H12"
                                  "D" "W" "M"})
(s/def ::o ::PriceValue)
(s/def ::l ::PriceValue)
(s/def ::h ::PriceValue)
(s/def ::c ::PriceValue)
(s/def ::bid ::CandlestickData)
(s/def ::ask ::CandlestickData)
(s/def ::mid ::CandlestickData)
(s/def ::CandlestickData (s/keys :req [::o ::h ::l ::c]))

(s/def ::Candlestick
  (s/keys :req
          [::time
           ::mid
           ::volume
           ::complete]
          :opt
          [::bid
           ::ask]))
