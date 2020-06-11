(ns serial.twelve-tone
  (:require [overtone.core :refer :all]
            [overtone.inst.sampled-piano :refer :all]
            [leipzig.live :as live]
            [leipzig.scale :as scale]
            [leipzig.chord :as chord]
            [leipzig.temperament :as temperament]
            [leipzig.melody :refer [bpm is phrase then times where with wherever]]
            [serial.sampled-violin :refer
             [sampled-pizzicato-violin
              sampled-non-vibrato-violin
              sampled-vibrato-violin]]
            [serial.sampled-cello :refer
             [sampled-pizzicato-cello
              sampled-non-vibrato-cello
              sampled-vibrato-cello]]
            [serial.harpsichord :as harpsichord]))

(overtone/connect-external-server)

(def pitch-transpose (atom 0))

(comment
  (on-event
   [:midi :note-on]
   (fn [m]
     (let [p-transpose (- (:note m) 48)]
       (println "pitch transpose by" p-transpose)
       (swap! pitch-transpose (constantly (int p-transpose)))))
   ::nanokey-pitch-transpose))

(comment
  (on-event
   [:midi :note-on]
   (fn [m]
     (let [note (:note m)]
       (sampled-piano :note note
                      :level (:velocity-f m))))
   ::nanokey-midi))

(comment
  (on-event [:midi :note-on]
            (fn [m]
              (println "note received:" m))
            ::midi-debug))

(def ranges
  {:violin (range 67 80)
   :cello (range 50 63)
   :piano (range 21 109)})

(def instruments
  {:violin {:styles [:pizzicato
                     :non-vibrato
                     :vibrato]}
   :cello  {:style [:pizzicato
                    :non-vibrato
                    :vibrato]}})

(defn mid-range
  [r]
  (let [inst-range (get ranges r (:piano ranges))
        lowest (first inst-range)
        highest (last inst-range)]
    (int (+ lowest
            (/ (- highest lowest) 2)))))

(def note-level-default 6)
(def piano-level-default 0.8)
;; (sampled-pizzicato-cello :note 59)
;; (sampled-vibrato-cello :note 59 :level 10)
(defmethod live/play-note :violin [{midi :pitch seconds :duration style :style}]
  (let [note (+ midi @pitch-transpose)]
    (println "Style: " style)
    (condp = style
      :pizzicato (sampled-pizzicato-violin :note note
                                           :level note-level-default)
      :non-vibrato (sampled-non-vibrato-violin :note note
                                               :level note-level-default)
      :vibrato (sampled-vibrato-violin :note note
                                       :level note-level-default))))
(defmethod live/play-note :cello [{midi :pitch seconds :duration style :style}]
  (let [note (+ midi @pitch-transpose)]
    (condp = style
      :pizzicato (sampled-pizzicato-cello :note note
                                          :level note-level-default)
      :non-vibrato (sampled-non-vibrato-cello :note note
                                              :level note-level-default)
      :vibrato (sampled-vibrato-cello :note note
                                      :level note-level-default))))
(defmethod live/play-note :piano [{midi :pitch seconds :duration}]
  (let [note (+ midi @pitch-transpose)]
    (sampled-piano :note note :level 0.8)))
(defmethod live/play-note :default [{midi :pitch seconds :duration}]
  (println "Ah! Don't know what instrument default is!!!"))

(defn random-rhythms
  []
  (shuffle (map #(/ % 12) (range 1 13))))

(comment (sum (random-rhythms)))

(defn split-into
  [n coll]
  (let [l-size (/ (count coll) n)]
    (partition-all l-size coll)))

(comment (split-into 5 (random-pitches)))

(def sum' (partial apply +))

(defn squash-durations
  [durations row]
  (map sum'
       (split-into (count row) durations)))

(comment (squash-durations (random-rhythms)
                           (hexachords (random-pitches))))

(defn retrograde
  [row]
  (reverse row))

(defn inversion
  [row]
  (map - row))

(def retrograde-inversion
  (comp retrograde inversion))

(defn chord-key
  [k]
  (keyword (str "k" k)))

(defn chordify
  [row]
  (zipmap (map chord-key
               (range 1 (inc (count row)))) row))

(defn hexachords
  [row]
  (map chordify (partition 6 row)))

(def transforms
  [identity retrograde inversion retrograde-inversion hexachords])

(defn serial-transforms
  [row]
  (map #(% row) (shuffle transforms)))

(defn total-serial
  [row]
  (reduce (fn [p1 p2]
            (then p2 p1))
          (map (fn [r]
                 (phrase (squash-durations (random-rhythms) r)
                         r))
               (serial-transforms row))))

(defn random-pitches
  []
  (shuffle (range 0 12)))

(defn random-tone-row
  []
  (shuffle (range 0 12)))





(def row-of-notes
  (phrase (repeat 3/3)
          (range 0 12)))

(defn play-in-range
  [r row]
  (->> row
       (where :pitch (comp (scale/from (mid-range r))
                           scale/chromatic))))

(defn play-on
  [instrument row]
  (->> row
       (where :part (is instrument))
       (play-in-range instrument)))

(defn serial-style
  [instrument row]
  (let [available (cycle (shuffle (get-in instruments [instrument :styles] [:default])))]
    (map-indexed (fn [i note]
                   (assoc note :style (nth available i)))
                 row)))

(defn in-tempo
  [bloops-per-minute row]
  (->> row
       (where :time (bpm bloops-per-minute))
       (where :duration (bpm bloops-per-minute))))

(defn total-tone-row []
  (phrase (random-rhythms)
          (shuffle (range 0 12))))

(def my-tone-row (total-tone-row))

(comment
  (in-tempo 60 my-tone-row))

(defn piano-trio
  [bpm tone-row]
  (in-tempo
   bpm
   (with
    (->> (total-serial tone-row)
         (play-on :cello)
         (serial-style :cello))
    (->> (total-serial tone-row)
         (play-on :violin)
         (serial-style :violin))
    (->> (total-serial tone-row)
         (play-on :piano)
         (serial-style :piano)))))

(def tone-row1 (random-pitches))
(comment (piano-trio 60 tone-row1))
(comment
  (live/play
   (in-tempo 60
             (play-on :piano (phrase (chord/triad)))))
  (sampled-piano :note 24 :level 1.5)
  (live/play (in-tempo 60 (play-on :piano (phrase (random-rhythms) tone-row1))))
  )
(comment (serial-transforms tone-row1))

(defn record-the-trio []
  (recording-start "~/Desktop/serial1.wav")
  (live/play (piano-trio 60 tone-row1))
  (recording-stop))

;; (sampled-piano :note 60 :level 0.8)
