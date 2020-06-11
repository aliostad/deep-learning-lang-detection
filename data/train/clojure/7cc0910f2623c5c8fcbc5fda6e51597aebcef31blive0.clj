::(use 'overtone.live)

(defn cmap
  [func list]
  (if (empty? list)
    '()
    (cons
     (func (first list))
     (cmap func (rest list)))))

(defn split-seq [s]
  "Extract a tail of same elements: [1 1 0 0 0] -> [[1 1] [0 0 0]]"
  (let [l (last s)]
    (split-with #(not= l %) s)))

(defn recombine
  ([a b] [a b])
  ([a b c] [a b c])
  ([a b c & more]
   (let [s (concat [a b c] more)
         [head tail] (split-seq s)
         recombined (map concat head tail)
         r-len (count recombined)]
     (if (empty? head)  ;; even pattern
       s
       (apply recombine (concat
                         recombined
                         (drop r-len (drop-last r-len s))))))))

(defn E [k n]
  (let [seed (concat (repeat k [1]) (repeat (- n k) [0]))]
        (flatten (apply recombine seed))))

(defn rhythm-to-beats
  ([rhythm length] (rhythm-to-beats rhythm length 0 (count rhythm)))
  ([rhythm length index rlen]
   (if (== (count rhythm) 0) []
       (if (== (first rhythm) 0)
         (rhythm-to-beats (rest rhythm) length (+ index 1) rlen)
         (cons (* (/ index rlen) length) (rhythm-to-beats (rest rhythm) length (+ index 1) rlen))))))

(defn beats-for-tick [seq tick]
  (if (= (count seq) 0)
    []
    (if (and (>= (first seq) tick) (< (first seq) (+ tick 1)))
      (cons (- (first seq) tick) (beats-for-tick (rest seq) tick))
      (beats-for-tick (rest seq) tick))))

(defn rhythm-beats-for-tick [rhythm numbeats tick]
  (beats-for-tick (rhythm-to-beats rhythm numbeats) (mod tick numbeats)))

(defn play-beats [beats clock instrument params]
  (if (not= (count beats) 0)
    (do (at (clock (+ (first beats) (clock))) (apply instrument params))
        (play-beats (rest beats) clock instrument params))))

(defn play-rhythm-for-tick [rhythm numbeats tick clock instrument params]
  (play-beats (rhythm-beats-for-tick rhythm numbeats tick) clock instrument params))

(def clk (metronome 130))

(comment
  (def chds
    [
     (chord :c4 :major)
     (chord :g4 :major)
     (chord :a4 :minor)
     (chord :f4 :minor)
     ]))

(def chds
  [
   (chord :c4 :major)
   (chord :b4 :sus4)
   (chord :g4 :major)
   (chord :a4 :minor)
   (chord :f4 :minor)
   (chord :e4 :dim)
   ])

(defn wrap-at [seq index]
  (if (not-empty seq)
    (nth seq (mod index (count seq)))
    []))

(defn cycleChds
  []
  (def chds (concat (rest chds) [(first chds)])))

(definst buzz
  [freq 440 amp 0.6 dur 1]
  (let [env (env-gen
             (envelope
              [0,1,0]
              [0.01,dur])
             :action FREE)
        saw (saw freq)]
    (* saw env amp)))

(definst hats
  [amp 1]
  (let [env (env-gen
             (envelope
              [0,0.1,0]
              [0.005, 0.05])
             :action FREE)
        noise (white-noise)]
    (* noise env amp)))

(definst kick
  [amp 1]
  (let [env (env-gen
             (envelope
              [0,1,0]
              [0.005, 0.15])
             :action FREE)
        sin (sin-osc
             (* 400 (* env env env env env)))]
    (* sin env amp)))


(defn notes-to-intervals [notes]
  (if (not-empty notes)
    (cons
     (mod (first notes) 12)
     (notes-to-intervals (rest notes)))
    []))

(defn shift-notes [notes shiftby]
  (if (not-empty notes)
    (cons
     (+ (first notes) shiftby)
     (shift-notes (rest notes) shiftby))))

(defn clip-notes [notes min max]
  (if (not-empty notes)
    (let [note (first notes)]
      (if (and (>= note min) (<= note max))
        (cons note (clip-notes (rest notes) min max))
        (clip-notes (rest notes) min max)))))

(defn notes-field-helper [notes min max]
  (if (not-empty notes)
    (let [good-notes (clip-notes notes min max)]
      (concat good-notes (notes-field-helper (shift-notes good-notes 12) min max)))))

(defn notes-field [notes min max] (clip-notes (notes-field-helper (notes-to-intervals notes) 0 max) min max))

(defn xpose-note [note floor]
  (let [lowest-note (mod note 12)]
    (letfn [(helper [n f] (if (>= n f) n (helper (+ n 12) f)))] (helper lowest-note floor))))

(defn xpose-notes [notes floor]
  (if (not-empty notes)
    (cons (xpose-note (first notes) floor) (xpose-notes (rest notes) floor))
    []))

(defn play-beat [clock tick]
  (do
    (comment
      (play-rhythm-for-tick
       (concat
        (E 3 8)
        (E 4 8)
        (E 3 8)
        (E 5 8))
       16 tick clock kick [0.15])
      (comment)
      (play-rhythm-for-tick
       (concat
        (E 13 24))
       6 tick clock hats [0.6])
      (comment)
      (play-rhythm-for-tick
       (concat
        (E 11 20))
       10 tick clock buzz [(+ (rand 3) (midi->hz (xpose-note (first (first chds)) 30))) 0.2])
      (play-rhythm-for-tick
       (concat
        (E 11 20))
       10 tick clock buzz [(+ (rand 6) (midi->hz (xpose-note (second (first chds)) 58))) 0.07])
      (play-rhythm-for-tick
       (concat
        (E 5 8))
       4
       tick
       clock
       buzz
       [(+ (rand 10) (midi->hz (wrap-at (notes-field (first chds) 70 87) tick)))
        0.17]))
    (play-rhythm-for-tick
     (concat
      (E 5 8))
     16 tick clock cycleChds [])))

(defn play
  [clock tick]
  (let
      [beat (clock)]
    (do (at (clock beat) (play-beat clock tick))
        (def tick (+ tick 1))
        (apply-by (clock (inc beat)) play [clock (+ tick 1)]))))

(play clk 0)
(stop)
