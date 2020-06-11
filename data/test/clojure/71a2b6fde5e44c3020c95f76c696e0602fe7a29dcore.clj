(ns music-machine.core
  (:use clojure.java.io
        clojure.pprint
        overtone.live)
  (:require music-machine.midi
            music-machine.instruments)
  (:import [music_machine.midi Event Track Note]
           [javax.sound.midi MidiSystem Sequence ShortMessage]))


;; Standards
(def as-time-goes-by (resource "jazz/as_time_goes_by_jh.mid"))
(def take-5 (resource "jazz/take_5_jh.mid"))
(def green-onions (resource "jazz/green_onions_jh.mid"))
(def affair-in-san-miguel (resource "jazz/affair_in_san_miguel_bob_baker.mid"))
(def after-youve-gone (resource "jazz/after_youve_gone_dm.mid"))
(def aint-misbehavin (resource "jazz/aint_misbehavin_rj.mid"))


;; Playback
(defrecord TimeInfo [bpm ppqn start])

(defn play-note [note time-info instrument]
  (when instrument
    (let [note-time (music-machine.midi/tick->ms (:tick note)
                                                 (:bpm time-info)
                                                 (:ppqn time-info))
          duration (music-machine.midi/tick->ms (:duration note)
                                                (:bpm time-info)
                                                (:ppqn time-info))]
      (at (+ (:start time-info) note-time)
          (instrument :freq (midi->hz (:pitch note))
                      :volume (/ (:velocity note) 127)
                      :duration (/ duration 1000))))))

(defn play-track [track time-info instruments]
  (let [instrument-type (music-machine.instruments/track-name->instrument-type (:name track))
        instrument (get instruments instrument-type)]
    (dorun (map #(play-note % time-info instrument)
                (filter #(instance? Note %) (:events track))))))

(defn play [song]
  (let [time-info (->TimeInfo (:bpm song) (:ppqn song) (now))
        instruments {}]
    (dorun (map #(play-track % time-info music-machine.instruments/standard-instruments) (:tracks song)))))

(defn play-file [file]
  (play (music-machine.midi/song-from-file file)))

(defn track-names [song]
  (into [] (map #(:name %) (:tracks song))))

(comment
  (play-file as-time-goes-by)
  (play-file take-5)
  (play-file green-onions)
  (play-file affair-in-san-miguel) ;; TODO: has lots of instruments
  (play-file after-youve-gone) ;; TODO: numbered tracks
  (play-file aint-misbehavin)
)
