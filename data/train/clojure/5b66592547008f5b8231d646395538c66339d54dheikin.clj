(ns model.heikin
  (:require [clojure.string :as str])
  (:gen-class))


(defrecord Instrument [symbol granularity])

(defprotocol PCandle
  (->vec [this]))

(defrecord Candle [open high low close sentiment]
  PCandle
  (->vec [this] (vec (vals this))))

(defn oanda-candle->
  [ohlc]
  (->Candle (:openMid ohlc)
            (:highMid ohlc)
            (:lowMid ohlc)
            (:closeMid ohlc)
            (if (> (:openMid ohlc)
                   (:closeMid ohlc))
              812 71)))



(defn with-indicators
  [heikins prices]
  (loop [heikins0 heikins
         prices0 prices
         acc []]
    (if (or (empty? heikins0) (empty? prices0))
      acc
      (recur (rest heikins0)
             (rest prices0)
             (conj acc
                   (let [heikin (first heikins0)
                         price (first prices0)]
                     (-> heikin
                         (assoc :lower-band (:lower-band price))
                         (assoc :upper-band (:upper-band price))
                         (assoc :ema (:ema price)))))))))
