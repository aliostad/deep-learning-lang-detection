(ns airguitar.instruments.drums
  (:use [airguitar.basic-instrument]
        [overtone.live])
  (:gen-class
    :name       airguitar.instruments.Drums
    :implements [airguitar.BasicInstrument]))

(def kick      (freesound 2086))
(def snare     (freesound 26903))
(def clap      (freesound 147597))
(def closed-hh (freesound 802))
(def open-hh   (freesound 26657))
(def cowbell   (freesound 9780))

(defn -play [this ^long note]
  (println note)
  (condp > note
    58  (kick)
    66  (snare)
    74  (clap)
    82  (closed-hh)
    90  (open-hh)
    (cowbell)))
