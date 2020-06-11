(ns ironlambda.score
  "Defining, manipulating, and playing scores."
  (:require [overtone.core :as ot]))

(defmulti notation
  "Return a string representing the musical structure in the DSL format."
  type)

(defmulti midi
  "Return the MIDI pitch value of a note or pitch record."
  type)

(defmulti play
  "(play instrument metronome beat music)
  Play a 'music' on an 'instrument' when 'metronome' is at 'beat'."
  (fn [instrument metonome beat music] (type music)))

(defn pitch
  "Return a new pitch structure."
  [letter accidental octave]
  {:pre [(#{\A \B \C \D \E \F \G} (Character/toUpperCase letter))
         (contains? #{:flat nil :sharp} accidental)
         ((set (range 8)) octave)
         (not (and (= (Character/toUpperCase letter) \F) (= accidental :flat)))
         (not (and (= (Character/toUpperCase letter) \B) (= accidental :sharp)))
         (not (and (= (Character/toUpperCase letter) \C) (= accidental :flat)))
         (not (and (= (Character/toUpperCase letter) \E) (= accidental :sharp)))]}
  (with-meta {:letter (Character/toUpperCase letter) :accidental accidental :octave octave}
    {:type ::Pitch}))

(defn pitch-range
  "Return a lazy seq of all pitches for the given range of midi octaves."
  [rng]
  (for [letter [\a \b \c \d \e \f \g] acc [:flat nil :sharp] octave rng
        :when (not (or (and (= letter \f) (= acc :flat))
                       (and (= letter \b) (= acc :sharp))
                       (and (= letter \c) (= acc :flat))
                       (and (= letter \e) (= acc :sharp))))]
    (pitch letter acc octave)))

(defn apply-accidental
  "Modify a pitch structure with a numerical accidental."
  [{old-acc :accidental :as pitch} modifier]
  {:pre [#{-1 0 1} modifier]}
  (let [new-acc (cond (and (= old-acc :flat)  (pos? modifier)) nil
                      (and (= old-acc nil)    (neg? modifier)) :flat
                      (and (= old-acc nil)    (pos? modifier)) :sharp
                      (and (= old-acc :sharp) (neg? modifier)) nil
                      :else old-acc)]
    (assoc pitch :accidental new-acc)))

(defmethod notation ::Pitch
  [{:keys [letter accidental octave]}]
  (str letter (cond (= :sharp accidental) "#" (= :flat accidental) "b") octave))

(defmethod midi ::Pitch
  [pitch]
  (ot/note (notation pitch)))

(defn note
  "Return a new note structure."
  ([pitch duration]
     {:pre [(pos? duration)]}
     (with-meta {:pitch pitch :duration duration}
       {:type ::Note}))
  ([letter accidental octave duration]
     (note (pitch letter accidental octave) duration)))

(defmethod notation ::Note
  [{:keys [pitch duration]}]
  (str "(note " (notation pitch) " " duration ")"))

(defmethod midi ::Note
  [{pitch :pitch}]
  (midi pitch))

(defmethod play ::Note
  [instrument metronome beat n]
  (let [end (+ beat (:duration n))]
    (if (and n (:pitch n))
      (let [id (ot/at (metronome beat) (instrument (midi n)))]
        (ot/at (metronome end) (ot/ctl id :gate 0))))
    end))

(derive ::Note ::Playable)

(derive ::Notes ::Playable)

(defn notes
  "Return a sequence of note records from a flat argument list of pitches and durations."
  [& notes]
  (->> notes
       (reduce
        (fn [{:keys [notes cur]} x]
          (cond
           (empty? cur)
           (cond (isa? (type x) ::Pitch)    {:notes notes :cur [x]}
                 (nil? x)                   {:notes notes :cur [x]}
                 (isa? (type x) ::Playable) {:notes (conj notes x) :cur nil}
                 :else (throw (RuntimeException. (str "Unexpected value " x " of type " (type x)
                                                      " where a pitch or a playable construct was expected."))))
           (= 1 (count cur))
           (if (isa? (type x) java.lang.Number)
             {:notes notes :cur (conj cur x)}
             (throw (RuntimeException. (str "Unexpected value " x " of type " (type x)
                                            " where a numerical duration was expected."))))
           :else
           (cond (isa? (type x) ::Pitch) {:notes (conj notes (apply note cur)) :cur [x]}
                 (nil? x)                {:notes (conj notes (apply note cur)) :cur [x]}
                 (isa? (type x) ::Playable)
                 {:notes (conj notes (apply note cur) x) :cur nil}
                 :else {:notes notes :cur (conj cur x)})))
        {:notes [] :cur nil})
       ((fn [{:keys [notes cur]}]
          (with-meta (if cur (conj notes (apply note cur)) notes)
            {:type ::Notes})))))

(defmulti duration
  "Calculate the duration of a sequence of playables."
  type)

(defmethod duration :default
  [ps]
  (reduce + (map :duration ps)))

(defmethod duration ::Notes
  [notes]
  (reduce + (map duration notes)))

(defmethod duration ::Note
  [n]
  (:duration n))

(defmethod duration ::Simultaneity
  [n]
  (:duration n))

(defmethod play ::Notes
  [instrument metronome beat notes]
  (if-let [cur-note (first notes)]
    (let [next-beat (play instrument metronome beat cur-note)]
      (ot/apply-at (metronome next-beat) play instrument metronome next-beat
                   (with-meta (next notes) (meta notes)) [])))
  (+ beat (duration notes)))

(defmethod notation ::Notes
  [notes]
  (apply str "(notes"
         (concat (map (fn [{:keys [pitch duration]}] (str " " (notation pitch) " " duration)) notes)
                 [")"])))

(derive ::Simultaneity ::Playable)
(derive ::Chord ::Simultaneity)

(defn chord
  "Return a chord record containing an arbitrary number of notes. If no
  duration is specified, the chord lasts as long as the longest note."
  ([notes]
     (let [duration (apply max (map :duration notes))]
       (chord notes duration)))
  ([notes duration]
     (with-meta {:playables notes :duration duration} {:type ::Chord}))
  ([duration pitch1 pitch2 & pitches]
     (chord (map #(note % duration) (concat [pitch1 pitch2] pitches)) duration)))

(defmethod play ::Simultaneity
  [instrument metronome beat sim]
  (doseq [p (:playables sim)] (play instrument metronome beat p))
  (+ beat (:duration sim)))

(defmethod notation ::Simultaneity
  [{:keys [playables duration]}]
  (apply str "(voices " (concat (interpose " " (map notation playables)) [" " duration ")"])))

(defmethod notation ::Chord
  [{:keys [playables duration]}]
  (if (every? #(= duration (:duration %)) playables)
    (apply str "(chord " duration
           (concat (map (fn [{:keys [pitch]}] (str " " (notation pitch))) playables)
                   [")"]))
    (apply str "(chord ["
           (concat (interpose " " (map (fn [note] (notation note)) playables))
                   ["] " duration ")"]))))

(defn voices
  "Return a structure of multiple sequences of notes to be played simulaneously."
  ([vs duration]
     (with-meta {:playables vs :duration duration} {:type ::Simultaneity}))
  ([vs]
     (let [durations (map duration vs)]
       (voices vs (apply max durations)))))

(defn rel-note
  "Return a structure that represents a note relative to a scale.

  Relative notes are abstract in that they are not tied to any concrete
  scale, but only define the interval from a root note.
  Relative notes can be converted to concrete notes with the in-scale function.
  The relative-to function can be used to convert from a concrete note to a relative one."
  [interval accidental duration]
  {:pre [(not= 0 interval)
         (#{-1 0 1} accidental)
         (pos? duration)]}
  (with-meta {:interval interval :accidental accidental :duration duration}
    {:type ::RelativeNote}))

(def scale-intervals
  {:major [2 2 1 2 2 2 1]
   :minor [2 1 2 2 1 2 2]})

(def midi-pitch-map
  (apply merge-with concat
         (map (fn [p] {(midi p) [p]}) (pitch-range (range 8)))))

(defn scale
  "Return an infinite sequence of intervals for a scale, either rising or falling."
  [[key gender] falling?]
  (cycle (if falling? (reverse (scale-intervals gender)) (scale-intervals gender))))

(defn cumulative-intervals
  "Return a lazy seq of the cumulative intervals based on the input sequence of intervals."
  [intervals]
  (reductions + intervals))

(defn interval
  "Return the interval corresponding to a number of semitones on a scale.

  Intervals are 1-based, so that 0 semitones result in an interval of 1 (prime). On a major scale
  2 semitones result in an interval of 2, 4 semitones give you an interval of 3.
  If the number of semitones does not match a note of the scale, the previous matching interval is returned.
  E.g. on a major scale 1 semitone corresponds to an interval of 1."
  [[key gender] semitones]
  (let [factor (if (neg? semitones) -1 1)]
    (* factor (inc (count (take-while #(<= % (* factor semitones))
                                      (cumulative-intervals (scale [key gender] (neg? semitones)))))))))

(defn semitones
  "Return the number of semitones corresponding to an interval on a scale.

  This function is the inverse of the interval function."
  [[key gender] interval]
  (let [factor (if (neg? interval) -1 1)]
    (* factor (nth (cons 0 (cumulative-intervals (scale [scale gender] (neg? interval))))
                   (dec (* factor interval))))))

(defn resolve-enharmonic
  "Return the correct pitch for the interval in the scale."
  [[key gender] interval]
  (let [midi-val (+ (midi key) (semitones [key gender] interval))
        enharmonics (midi-pitch-map midi-val)]
    (cond
     (= 1 (count enharmonics)) (first enharmonics)
     (= (:letter (first enharmonics)) (:letter (resolve-enharmonic [key gender] (dec interval))))
     (last enharmonics)
     :else (first enharmonics))))

(defmulti into-scale
  "Return concrete notes based on a relative ones and a scale."
  (fn [scale rel] (type rel)))

(defmethod into-scale ::RelativeNote
  [[key gender] rel-note]
  (let [pitch (resolve-enharmonic [key gender] (:interval rel-note))]
    (note
     (apply-accidental pitch (:accidental rel-note))
     (:duration rel-note))))

(defmethod into-scale clojure.lang.Sequential
  [scale rel-notes]
  (apply notes (map (partial into-scale scale) rel-notes)))

(defmulti relative-to
  "Return relative notes that represents the interval between the input notes and the root of [key gender]."
  (fn [scale note] (type note)))

(defmethod relative-to ::Note
  [[key gender] note]
  (let [sts (- (midi note) (midi key))
        direction (if (neg? sts) -1 1)
        lower-bound (interval [key gender] sts)
        upper-bound (interval [key gender] (+ sts direction))
        [intv acc] (cond (= sts (semitones [key gender] lower-bound)) [lower-bound 0]
                         (= (-> note :pitch :letter)
                            (-> (resolve-enharmonic [key gender] lower-bound) :letter))
                         [lower-bound direction]
                         :else [upper-bound (* direction -1)])]
    (rel-note intv acc (:duration note))))

(defmethod relative-to ::Notes
  [scale notes]
  (map (partial relative-to scale) notes))

(defn transpose
  "Return notes corresponding to src transposed from src-key/src-gender (e.g [D4 :minor])
  to dest-key/dest-gender."
  [src-scale dest-scale src]
  (->> src
       (relative-to src-scale)
       (into-scale dest-scale)))

(comment
  (use 'ironlambda.notes)
  (use 'ironlambda.performance)

  (def c (chord 3 C4 G4))
  (piano c)

  (def soprano (notes A4 2 D4 C5 2 A4 2))

  (def alto (notes D4 1 E4 1 F4 1 G4 1 A4 1 A3 0.5 B3 0.5 C4 0.5 A3 0.5 F4 1))
  (type alto)
  (pprint soprano)
  (piano soprano)
  (piano alto)
  (piano (voices [soprano alto]))
  (notation (voices [soprano alto]))

  (def subj (notes D4 2 A4 2 F4 2 D4 2 C#4 2 D4 1 E4 1 F4 2.5 G4 0.5 F4 0.5 E4 0.5 D4 1))
  (->> subj (transpose [D4 :minor] [A4 :minor]) notation)

  ;;             "(notes A4 2 E5 2 C5 2 A4 2 Ab4 2 A4 1 B4 1 C5 2.5 D5 0.5 C5 0.5 B4 0.5 A4 1)"
  (def subj-a-min (notes A4 2 D5 2 C5 2 A4 2 G#4 2 A4 1 B4 1 C5 2.5 D5 0.5 C5 0.5 Bb4 0.5 A4 1))
  (relative-to [D4 :minor] (note C#4 2))
  (piano subj-a-min)
  (piano (notes B4 1 Bb4 1))

  (notation alto)

  (piano (chord 4 C4 E4 G4 B4))
  (notation (chord 4 C4 E4 G4 B4))

  (notation (chord [(note C4 2) (note G4 1)])))
