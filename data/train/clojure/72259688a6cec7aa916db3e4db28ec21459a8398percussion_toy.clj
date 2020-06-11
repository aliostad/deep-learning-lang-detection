(ns jinput-overtone.percussion-toy
  (:use [overtone.music.rhythm :only [metronome]]
        [overtone.music.pitch :only [note degrees->pitches]]
        [overtone.midi]
        [midiutils-overtone.core]
        [jinput-overtone.core]
        [jinput-overtone.finders]
        [jinput-overtone.events]
        [jinput-overtone.handlers]
        [jinput-overtone.loop]))

(def mout (midi-out "GS"))

(defn play-note [out channel note]
  (note-on-off out channel note 100 400))

(def metro (metronome 240))

(def frere-intervals
  [[:i :_ :ii :_ :iii :_ :i :_
    :i :_ :ii :_ :iii :_ :i :_
    :iii :_ :iv :_ :v :_ :_ :_
    :iii :_ :iv :_ :v :_ :_ :_
    :v :vi :v :iv :iii :_ :i :_
    :v :vi :v :iv :iii :_ :i :_
    :i :_ :v- :_ :i :_ :_ :_
    :i :_ :v- :_ :i :_ :_ :_
    ]])

(def frere-notes
  "Map all nested intervals to midi note numbers"
  (map #(degrees->pitches % :major :C4) frere-intervals))

;; Plays the tune endlessly
(defn play-notes
  "Recursion through time over an sequence of infinite sequences of hz notes
  (or nils representing rests) to play with the pretty bell at the specific
  time indicated by the metronome"
  ([initial-beat initial-notes] (play-notes mout 0 initial-beat initial-notes))
  ([out channel initial-beat initial-notes]
   (let [last-note 64]
     (loop [note-count 1
            beat initial-beat
            notes initial-notes]
       (let [notes-to-play (remove nil? (map first notes))]
         (midi-at (metro beat)
                  (fn []
                    (dorun
                      (map #(play-note out channel %) notes-to-play)))))
       (when (< note-count last-note)
         (recur (inc note-count) (inc beat) (map rest notes)))))))

(defn tune-frere
  ([] (tune-frere mout 0 :acoustic-grand-piano ))
  ([out channel instrument]
   (program-change out channel (instrument GM))
   (play-notes out channel (metro) (map cycle frere-notes))))

(defonce xbox (find-controller "XBOX"))

(defn percuss [out instrument]
  (play-note out PERCUSSION-CHANNEL (instrument GM-PERCUSSION)))

(controller-event-handlers
  xbox
  {BUTTON0 #(when (button-pressed? (:val %)) (tune-frere mout 0 :acoustic-grand-piano ))
   BUTTON1 #(when (button-pressed? (:val %)) (tune-frere mout 1 :tubular-bells ))
   BUTTON2 #(when (button-pressed? (:val %)) (tune-frere mout 2 :trumpet ))
   BUTTON3 #(when (button-pressed? (:val %)) (tune-frere mout 3 :electric-guitar-clean ))
   BUTTON4 #(when (button-pressed? (:val %)) (percuss mout :cowbell ))
   BUTTON5 #(when (button-pressed? (:val %)) (percuss mout :open-triangle ))
   BUTTON6 #(when (button-pressed? (:val %)) (percuss mout :maracas ))
   BUTTON7 #(when (button-pressed? (:val %)) (percuss mout :tambourine ))
   X-AXIS #(println "X = " (:val %))
   HAT #(condp hat-direction? (:val %)
          HAT_N (percuss mout :open-hi-hat )
          HAT_W (percuss mout :crash-cymbal-1 )
          HAT_E (percuss mout :crash-cymbal-2 )
          HAT_S (percuss mout :pedal-hi-hat )
          nil)})
