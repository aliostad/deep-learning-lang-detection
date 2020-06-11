(ns temperaments.midiplayer
  (:use overtone.core
        temperaments.tuning
        temperaments.midifile)
  (:import [temperaments.midifile Event Note Song Controller])
  (:gen-class))

;;; ****************************************************************
;;; Playable protocol for Overtone. Assumes midifile.clj has already been
;;; loaded.

(defrecord TimeInfo [start-ms           ; start millisecs for entire track
                     msecs-per-tick     ; millisecs per tick
                     t])                ; pre-computed time for an event

(defprotocol Playable
  (play-event [this time-info inst track-volume] "Plays event."))

(extend Event
  Playable
  {:play-event
   (fn [this time-info inst track-volume]
     )})

(extend Note
  Playable
  {:play-event
   (fn [this time-info inst track-volume]
     (letfn [(duration-ms [duration-ticks] (* (:msecs-per-tick time-info) duration-ticks))
             (volume [note track-volume]
               (* track-volume
                  (/ (float (:velocity note)) 127.0)))]
       (let [id (at (:t time-info) (inst :freq (midi->freq (:midi-note this))
                                        ;:dur (duration-ms (:duration this))
                                         :amp (volume this track-volume)))]
         (at (+ (:t time-info) (duration-ms (:duration this))) (ctl id :gate 0)))))})

(extend Controller
  Playable
  {:play-event
   (fn [this time-info inst track-volume]
     )})

;;; ****************************************************************
;;; Assigning Overtone instruments to tracks

(defn song-with-instruments
  "Returns a song where each track that has a name in track-inst-map is
  assigned to the corresponding instrument."
  [song track-inst-map]
  (assoc song :tracks (map #(assoc % :instrument (get track-inst-map (:name %)))
                           (:tracks song))))

;;; ****************************************************************
;;; Playing a song

(defn abs-time-ms [start-ms msecs-per-tick ticks] (long (+ start-ms (* msecs-per-tick ticks))))

(defn play-track
  [start-ms msecs-per-tick track volume]
  (let [inst @inst-cur]
    (dorun (map #(let [ti (->TimeInfo start-ms msecs-per-tick (abs-time-ms start-ms msecs-per-tick (:tick %)))]
                   (apply-at (:t ti) #'play-event % ti inst volume nil))
                (:events track)))))

(defn play-song
  [song]
  (let [start-ms (+ (now) 50)
        track-vol (/ 1.0 (count (:tracks song)))]
    (dorun (map #(play-track start-ms (msecs-per-tick song) % track-vol) (:tracks song)))))

;;; ****************************************************************
;;; Example

(comment

(set! *print-length* 10)

(definst foo [freq 440 dur 1.0 vol 1.0]
  (* vol
     (env-gen (perc 0.15 dur) :action FREE)
     (saw freq)))

(def midi-file "/Users/jimm/Documents/Dropbox/Music/Vision Sequences/Equal Rites/At Sea.mid")
(def midi-file "/Users/jimm/Documents/Dropbox/Music/Vision Sequences/Equal Rites/Main Theme.mid")
(def midi-file "/home/dabrowsa/music/midi/Bach Midi Index/WTCBkI/Prelude3.mid")
(def song (song-from-file midi-file))

(map :name (:tracks song))

;; Create a map of track names to the single instrument "foo".
(zipmap (drop 1 (map :name (:tracks song)))
        (repeat foo))

(def swi (song-with-instruments song (zipmap (drop 1 (map :name (:tracks song)))
                                             (repeat foo))))

(play-song swi)

;; TODO write all these instruments. You know: the hard part.
(def midi-file "/Users/jimm/src/github/midilib/examples/NoFences.mid")
(def song (song-from-file midi-file))
(def track-inst-map {"Drums" drumkit
                     "Bass" bass1
                     "Bass Copy" bass2
                     "Piano & Strings" piano-and-strings
                     "Brass" brass
                     "Organ Melody" organ
                     "Piano Solo" piano
                     "Picky Guitar" picky-guitar
                     "Big Jupiter" big-jupiter
                     "Saxes" saxes})
(play-song (song-with-instruments song track-inst-map))
)
