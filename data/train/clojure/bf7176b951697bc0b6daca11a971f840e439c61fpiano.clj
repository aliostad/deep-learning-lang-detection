(ns airguitar.detectors.piano
  (:require [airguitar.basic-instrument])
  (:import  [com.leapmotion.leap Controller Gesture Listener]
            [airguitar BasicInstrument])
  (:use     [airguitar.leap.utils])
  (:gen-class
    :name         airguitar.detectors.Piano
    :extends      com.leapmotion.leap.Listener
    :constructors {[airguitar.BasicInstrument] []}
    :init         init
    :state        instrument))

(def min-x -135)
(def max-x  135)

(def note-min  50)
(def note-max 100)

(defn- x-to-note [x]
  (int (+ (/ (* (- x min-x) (- note-max note-min)) (- max-x min-x)) note-min)))

(defn -init [^airguitar.BasicInstrument instrument]
  [[] instrument])

(defn -onConnect [this ^com.leapmotion.leap.Controller controller]
  (.enableGesture controller key-tap-gesture))

(defn -onFrame [this ^com.leapmotion.leap.Controller controller]
  (let [frame    (. controller frame)
        gestures (gesture-list-to-list (.gestures frame))]
    (doseq [gesture gestures]
      (let [x          (.getX (.position gesture))
            note       (x-to-note x)
            instrument (.instrument this)]
        (.play instrument note)))))
