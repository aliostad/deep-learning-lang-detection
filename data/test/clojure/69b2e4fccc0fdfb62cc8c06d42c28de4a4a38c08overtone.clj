(ns
    ^{:doc "for interoperability with overtone - grants the ability to play lines"
       :author "Kyle Hipke"}
    music-theory.westergaardian-theory.overtone
  (:use music-theory.westergaardian-theory.note)
  (:use music-theory.westergaardian-theory.line)
	(:use music-theory.westergaardian-theory.semitone)
  (:require [overtone.core :as overtone]))


(defn- play-line-recurse
  "Private method to implement play-line"
  [target-line beat-number metro play-midi-note note-index]
  (overtone/at (metro beat-number) (play-midi-note (note-midi (:note (line-note-at target-line note-index)))))
  ;recur but only evaluate when it's time to play the note, so it responds to changing metronome
  (when (< note-index (line-note-count target-line))
    (let [next-beat (+ (:dur (line-note-at target-line note-index)) beat-number)]
      (overtone/apply-by (metro next-beat)
                         #'play-line-recurse target-line next-beat metro play-midi-note (inc note-index) [])))
  )

(defn play-line
  "Plays the line, starting playback at the specified
  beat number of the passed metronome (metro).If
  you change the metronome tempo during playback, the line playback will change accordingly.
  Beat-number is a number representing the number of beats from the start of the metronome
  that playback should begin at. So a beat-number of 50 means start playing the line
  on the 50th beat of the metronome (50.25 would mean play at a quarter from the start
  of the 50th beat). play-midi-note is a function which will be invoked and passed
  the midi note value of the note to play when it comes time. you should use
  that to play the sound using a ugen. If you have a ugen that accepts
  midi or frequency, you can use play-midi-ugen or play-freq-ugen.
	metro is an overtone metronome function (so something like (metronome 100)),
  that will be used to determine when to play the notes.
  "
  [target-line beat-number metro play-midi-note]
  (play-line-recurse target-line beat-number metro play-midi-note 0))

(defn play-midi-ugen
  "For use with play-line. Given a ugen that uses midi notes to tell it what pitch to play as
  the first argument,
  returns a function that will cause that instrument to play
  when passed a midi note. Passes args as the remaining arguments to the instrument"
  [instrument & args]
  (fn
    [midi-note]
    (apply instrument midi-note args)))

(defn play-freq-ugen
  "For use with play-line. Given a ugen that uses a frequency value to
  tell it what pitch to play as its first argument, returns a function that will
  cause it to play a passed midi note.
  Passes args as the remaining arguments to the instrument."
  [instrument & args]
  (fn
    [midi-note]
    (apply instrument (overtone/midi->hz midi-note) args)
    ))
