(ns cochlea.sounds
  ^{:author "Alex Seewald"
    :doc "Provides... 1) an atom 'opts' which encapsulates state, e.g. instrument type and practice-mode (chords or scales or ...) which the main function modifies via the GUI. 2) an atom 'cache' which stores previous interaction information that the replay button uses. 3) a variadic 'play' function which does the appropriate sound effects, based on state "}
  (:use [overtone.live]
        [environ.core :only [env]]
        [cochlea.instruments]))
(def opts
  "The settings. Intervals will be played simultaneously iff simultaneous-intervals is true.
  Chords will be played with random inversions iff allow-inversions is true.
  The unit of tempo is beats per minute.
  Inversion method may be :shifty or :random.
  "
  (atom
  {:tempo (:tempo env)
   :level (:default-difficulty env)
   :pitch (:pitch env)
   :instrument (get instruments 0)
   :practice-mode (:default-mode env)
   :simultaneous-intervals (:simultaneous-intervals env)
   :allow-inversions false}))
(def cache
  (atom
   {:prev-sound nil
    :prev-mode nil
    }))
(defn cache-sound
  "Stores the most recent sound for use by the replay button."
  [prev-sound prev-mode]
  (swap! cache assoc :prev-sound prev-sound)
  (swap! cache assoc :prev-mode prev-mode))
(defn set-volume
  "The purpose of this is to avoid duplicate loading of overtone.live in core.clj. Is there a more idiomatic
   way to do this sort of thing?"
  [val]
  (volume (/ val 100.0)))
(def levels [:select :extended :all])
(def choices
  {:scales (let [s0 [:major :dorian :phrygian :lydian :mixolydian :minor :locrian]
                 s1 (concat s0 [:major-pentatonic :minor-pentatonic :whole-tone :harmonic-minor :neapolitan-major :harmonic-major :diminished :augmented])
                 s2 (keys SCALE)]
                 (zipmap levels [s0 s1 s2]))
   :intervals (let [i0 [:i :ii :iii :iv :v :vi :vii]
                    i1 (concat i0 [:viii :ix :x :xi :xii :xiii])
                    i2 (concat i1 [:xiv :xv :xvi :xvii])]
                 (zipmap levels [i0 i1 i2]))
   :chords (let [c0 [:major :minor :major7 :dom7 :minor7]
                 c1 (concat c0 [:sus2 :sus4 :6 :m6])
                 c2 (keys CHORD) ]
                 (zipmap levels [c0 c1 c2]))})
; I should convert this from using 'at' to using 'after-delay', so that it can use the sampled instruments.
(defn mseq
  "An effect-ful function which plays the notes in the argument list evenly spaced in time
  at a tempo according to the state of the @opts atom."
  [mvec]
  (let [met (metronome (@opts :tempo))
        inst (@opts :instrument)]
    (map-indexed (fn [i note] (after-delay (- (met i) (met 0)) #(inst note)))
                  mvec)))
(defn effect-scale
  [s] (doall [(mseq (scale (@opts :pitch) s))
              (cache-sound s :scales)]))
(defn play-scale
  ([]          (effect-scale (rand-nth (get-in choices [:scales (@opts :level)]))))
  ([the-scale] (effect-scale the-scale)))

(defn effect-interval
  [i]
  (let [root (note (@opts :pitch))
        other (+ (note (@opts :pitch)) i)]
    (doall [ (if (@opts :simultaneous-intervals)
               (map (@opts :instrument) [root other])
               (mseq [root other]))
             (cache-sound i :intervals)])))
(defn play-interval
  ([]             (effect-interval (degree->interval (rand-nth (get-in choices [:intervals (@opts :level)])) (rand-nth [:major :minor]))))
  ([the-interval] (effect-interval the-interval)))
(defn effect-chord
  [chrd] (doall [ (map (@opts :instrument) (chord (@opts :pitch) chrd))
                  (cache-sound  chrd :chords)]))
(defn- maybe-invert [chrd]
  (let [shift-amount (if (:allow-inversions @opts)
                         (rand-nth (range (count chord)))
                         0)]
    (invert-chord chrd shift-amount)))
(defn play-chord
  ([]          (effect-chord (maybe-invert (rand-nth (get-in choices [:chords (@opts :level)])))))
  ([the-chord] (effect-chord (maybe-invert the-chord))))

(defn play
    ([] (case (@opts :practice-mode)
              :scales (play-scale)
              :intervals (play-interval)
              :chords (play-chord)
              (print (format "play error, invalid :practice-mode value %s" (@opts :practice-mode)))))
    ([mode sound]
     (println (format "replaying %s %s" (str mode) (str sound)))
     (case mode
                   :scales (play-scale sound)
                   :intervals (play-interval sound)
                   :chords (play-chord sound)
                   (print (format "play error, invalid :practice-mode value %s" (@opts :practice-mode))))))
