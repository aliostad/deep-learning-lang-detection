(ns markovmusic.player
	(:use [overtone.live]))

(defn play-fixed-length-notes
  "Plays a sequence of notes with given instrument and start time."
  [inst time sep notes]
  (let [note (first notes)]
    (when note
      (at time (inst note)))

    (let [next-time (+ time sep)]
      (apply-at next-time play-fixed-length-notes [inst next-time sep (rest notes)]))))

(defn to-pitch
  [note scale root]
  (let [{de :value du :duration} note]
  {:freq (first (degrees->pitches [de] scale root)) :duration du}))

(defn play-duration-notes
  "Plays a sequence of notes, each with specified duration."
  ([inst time notes]
   (let [note (first notes)]
     (when (note :freq)
       (at time (inst (note :freq))))
     (let [next-time (+ time (note :duration))]
       (apply-at next-time play-duration-notes [inst next-time (rest notes)]))))

  ([inst time notes scale root]
   (play-duration-notes inst time (map #(to-pitch % scale root) notes))))

(def play play-duration-notes)
