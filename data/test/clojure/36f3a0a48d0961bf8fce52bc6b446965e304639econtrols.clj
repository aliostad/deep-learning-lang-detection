(ns ginger.controls
  (:use [overtone.live])
  (:require [ginger.instruments]
            [monome-serial.led :as mled])
  (gen-class))

(defonce instruments ginger.instruments/load-instrument-files)

(dissoc instruments)

(def current-index (atom 0))

(defn get-instrument [index]
  (nth instruments index))

(defn switch-instrument-index [m x y]
  (when (= x 7)
    (swap! current-index inc)
    (mled/led-on m x y)
    (mled/led-off m 6 y))
  (when (= x 6)
    (swap! current-index dec)
    (mled/led-on m x y)
    (mled/led-off m 7 y)))