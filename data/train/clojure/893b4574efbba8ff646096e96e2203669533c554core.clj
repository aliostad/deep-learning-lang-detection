(ns ginger.core
  (:use overtone.live)
  (:require [monome-serial.core :as mcore]
            [monome-serial.led :as mled]
            [monome-serial.event-handlers :as mevent]
            [overtone.core :as overtone]
            [ginger.controls :as controls])
  (gen-class))

(defonce m (mcore/connect "/dev/ttyUSB0"))

;; TODO Seems uneeded.
;;      Learning clojure woo!
(dissoc controls/instruments)

(defn play-note [m x y]
  (mled/led-on m x y)
  ((controls/get-instrument (deref controls/current-index)) :note (+ (+ (* x 1) (* y 8)) 10)))

(defn kill-note [m x y]
  (mled/led-off m x y)
  (stop))

(defn delegate-on-press [m x y]
  (when (> y 0)
    (play-note m x y))
  (when (= y 0)
    (controls/switch-instrument-index m x y)))

(defn delegate-on-release [m x y]
  (when (> y 0)
    (kill-note m x y)))

(mevent/on-press m (fn [x y] (delegate-on-press m x y)) "*")
(mevent/on-release m (fn [x y] (delegate-on-release m x y)) "*")

(bass)
(kill bass)