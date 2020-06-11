(ns overtone-tseq-evolution.tseq
  (:use [overtone.live]
        [overtone-tseq-evolution.util]))

;; Mapping of sequences

(defn map-event-periodic
  "Maps a function on a time-event back into the period"
  [f g period [t e]]
  [(mod (f t) period) (g e)])

(defn map-seq-periodic
  "Maps a function on a t-sequence back into the period"
  [f g period seq]
  (let [lazyseq (iterate (fn [v] (map (fn [[a b]] [(inc a) b]) v)) seq)
        theparts (take period lazyseq)
        newseq (reduce into theparts)]
    (sort-by first
             (map #(map-event-periodic f g period %1) newseq))))

(defn map-seq-periodic-scalar
  "Like map-seq-periodic but assumes that g is a scalar function"
  [f g period seq]
  (map-seq-periodic f #(map g %1) period seq))

(defn map-seq-periodic-linear
  "Apply a scalar function to first and a linear transformation to rest"
  [f m period seq]
  (map-seq-periodic
   f #(matrix-mult m %1) period seq))

(defn apply-piecewise
  "Apply functions p piecewise to x. May be thought of as t-part input
  to map-seq-periodic"
  [x p]
  ((nth (first (filter #(<= x (first %1)) p)) 1) x))

(defn reverse-seq
  "Reverse a seq"
  [seq p]
  (sort (map #(mod (- %1) p) seq)))

(defn reverse-time
  "Reverse a t-seq by its t-part"
  [seq p]
  (sort-by first (map #(identity [(mod (- (first %1)) p) (second %1)]) seq)))

(defn reverse-time-indep
  "Reverse the t-part of a seq independently of the sound part"
  [seq p]
  (let [t-seq (map first seq)
        v-seq (map second seq)
        t-rev (reverse-seq t-seq p)]
    (map #(identity [(nth t-rev %1) (nth v-seq %1)]) (range (count t-seq)))))

(defn sequential-transforms
  "Apply a sequence of transforms to a t-sequence"
  [t seq]
  (apply into ((apply juxt t) seq)))

;; Play t-sequences

(defn play-inst-seq-loop
  "Play a t-seq with some instrument over a period"
  [nome period instrument seq]
  (let [beat (nome)
        tick (metro-tick nome)]
    (doseq [[t e] seq]
      (at (+ (* tick t) (nome beat)) (apply instrument e)))
    (apply-by (nome (+ beat period))
              play-inst-seq-loop nome period instrument seq [])))

(defn play-inst-seqs-loop
  "Play a collection of instrument/t-seq pairs"
  [nome period seqs]
  (doseq [[seq instrument] seqs]
    (play-inst-seq-loop nome period instrument seq)))
