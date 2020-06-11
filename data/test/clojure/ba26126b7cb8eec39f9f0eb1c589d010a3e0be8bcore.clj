(ns ohack.core
  (:use [overtone.live]
        [overtone.inst.piano]
        [overtone.inst.sampled-piano]
        [overtone.synth.stringed])
  (:require [overtone.inst.synth :as synth]
            [clojure.string :as s]
            [quil.core :as q]
            ))

;; run M-x cider-jack-in to get started
;;
;; once started, move your cursor to the (ns ...) block above and hit
;; C-M-x to evaluate it and boot the supercollider server.  if your
;; sampled-piano samples are not cached, overtime will attempt to
;; download them and cache them now. once you see the prompt update with
;; the Overtone logo, you are good to go.


;; use odoc() to lookup function documentation in overtone outside of
;; this you should probably use doc() for the same purpose

;; get documentation for prn
(odoc prn)

;; get documentation for synth/ping
(odoc synth/ping)

;; get documentation for odoc
(odoc odoc)


;; so `synth` contains a bunch of instrument definitions that you can
;; use already. you can try them by calling e.g.
(synth/ping)

;; some of them will fade away after a while.
(synth/rise-fall-pad)

;; some of them don't
(synth/vintage-bass)

;; in which case, stop(), i.e. overtone.live/stop(), switches off all sounds
(stop)

;; tip: C-M-x evals the expression (to the outermost surrounding
;; expression!) that your cursor is /inside/, or /before/. To evaluate
;; the expression that your cursor is /immdiately after/, use C-x-e

;; other synths to try
(comment
  (synth/daf-bass)
  (synth/buzz)
  (synth/cs80lead)
  (synth/ticker)
  (synth/pad)
  (synth/bass)
  (synth/daf-bass)
  (synth/grunge-bass)
  (synth/ks1)

  (stop)
  )

;; now let's play a little melody
(let [beat-ms 250
      base-line [:D3 :A2 :A#2 :C3
                 :D3 :F3 :G3 :C4
                 :D4 :A3 :F3 :C3
                 :D3 :F2 :G2 :A#2]
      num-measures (* 1 (count base-line))
      ]
  (stop)
  (letfn [(play-it
            ;; first, define a recursive note player
            ([interval instrument values]
             (play-it (now) interval instrument values 0))
            ([time interval instrument values counter]
             ;; the counter is only used for this hack:
             ;; because vintage bass "plays" forever...
             ;; close the instrument's play envelope.
             ;; you can try commenting this out and hear
             ;; what happens.
             (when (= (mod counter 4) 0)
               (ctl instrument :gate 0))
             (if-not (empty? values)
               (let [value (first values)
                     next-time (+ time interval)]
                 (when value
                   ;; at() is basically overtone's scheduler
                   (at time (instrument value)))
                 ;; after the note plays, schedule another call at the
                 ;; later time
                 (apply-at next-time
                           play-it [next-time interval instrument (rest values) (inc counter)])))))]

    ;; baseline plays once per 4 notes
    (play-it (* 4 beat-ms)
             synth/vintage-bass
             ;; cycle the base line forever (but in reality, just for
             ;; `num-measures` times)
             (take num-measures (cycle (map note base-line))))

    (play-it beat-ms
             piano
             ;; concat the sets-of-4-note-chords into a single
             ;; seq of notes to send to play-it
             (apply concat
                    (take num-measures
                          ;; for each root note, use overtone's rand-chord
                          ;; to construct a 4-note chord that spans up to
                          ;; 24 degrees
                          (map (fn [root-note] (rand-chord root-note :major 4 24))
                               (cycle base-line)))))))



;; ok, let's get back to more basics and build up to other exciting things.
;; first, let's add a few imports.

;; playing with the guitar synth

;; Mark found this guitar-pick function
(guitar-pick (guitar) 0 0) ;; String 0 (Low E) Fret 0 (open)

;; we need a function that will play a sequence of notes; notes will
;; contain an arbitrarily long sequence of pairs of numbers denoting
;; `string-index` `fret-value`
(defn guitar-pick-note-sequence
  "play a sequence of notes [string fret] on instrument instrument
  spaced by interval milliseconds

  interval = milliseconds between each play
  noteseq = [[string-index-1 fret-index-1
              string-index-2 fret-index-2 ... ]]
  "
  [interval noteseq]
  (let [playguitar (partial guitar-pick (guitar))
        timeseq (range (now) (+ (now) (* interval (count noteseq))) interval)]
    (doseq [[string-fret-seq timeval] (map vector noteseq timeseq)]
      (doseq [[string fret] (partition 2 string-fret-seq)]
        (playguitar string fret timeval)))))

(def playguitar320
  (partial guitar-pick-note-sequence 320))  ;; 320ms delay between picked strings

(def everybody-hurts
 "
  ;; Guitar Tab for Everybody Hurts by REM
  ;;
  ;;       D                        G
  ;; E:5]--------2-----------2------------3-----------3-----[
  ;; B:4]------3---2-------3---3--------0---0-------0---0---[
  ;; G:3]----2-------2---2-------2----0-------0---0-------0-[
  ;; D:2]--0-----------0------------------------------------[
  ;; A:1]---------------------------------------------------[
  ;; E:0]---------------------------3-----------3-----------[
")

;; now we can play multiple notes at the same time
(playguitar320 [[0 3, 3 0, 4 0, 5 3]])

;; we're going to fetch the tab from
;; http://tabs.ultimate-guitar.com/t/tracy_chapman/fast_car_ver8_tab.htm
(def fast-car-html (slurp "http://tabs.ultimate-guitar.com/t/tracy_chapman/fast_car_ver8_tab.htm"))
;; ok, it's working, now save the tab
(def fast-car-tab
  (-> fast-car-html
      (.split "Tabbed by")
      second
      (.split "hammer-on")
      first))

;; let's iteratively write a simple parser for this

(defn collect-into-consecutive
  "collect indexes into sets of N consecutive indexes,
  discarding all other indexes.

  N defaults to 6 (for guitar tabs)"

  ([index-list]
   (collect-into-consecutive index-list 6))

  ([index-list required-length]
   (loop [input (sort index-list)
          ;; use a buffer to store incoming consecutive indexes
          buf []
          rtn []]
     ;; we need to add buf to rtn if buf has 6 elements
     (let [buf-full? (= required-length (count buf))
           next-rtn (if buf-full? (conj rtn buf) rtn)]
       (if (empty? input)
         next-rtn
         (let [last-val (last buf)
               cur-val (first input)]
           (recur (rest input)
                  ;; we need to send a fresh buffer if:
                  ;; it is full, OR
                  ;; the incoming value is not a consecutive index
                  ;; relative to the last value in the buffer, OR
                  ;; the buffer is empty (i.e. first iteration,
                  ;; thus last-val is nil)
                  (if (or (nil? last-val) ;; also short-circuits the subtraction
                          buf-full?
                          (not= 1 (- cur-val last-val)))
                    [cur-val]           ;; fresh buffer
                    (conj buf cur-val)) ;; add to buffer
                  next-rtn))))))
  )

;; we want a function that takes a regex and returns the position of the match...
;; turns out someone asked for the exact same thing on SO!
;; http://stackoverflow.com/questions/21191045/get-string-indices-from-the-result-of-re-seq
(defn re-seq-pos [pattern string]
  (let [m (re-matcher pattern string)]
    ((fn step []
      (when (. m find)
        (cons {:start (. m start) :end (. m end) :group (. m group)}
              (lazy-seq (step))))))))

(defn parse-guitar-tab-line
  "reads a single well-formed line from the guitar tab
  and returns a seq of seq, where each inner seq takes the form of
  [index fret-value]
  index = at what index in time the pluck should occur
  fret-value = being which fret to pluck; nil if it should be rest
  "
  [line]
  ;; filter out everything before the actual guitar line "- ..." part
  ;; note: drop-while predicate needs a char (\-), not a string ("-")!
  (let [tab-string (apply str (drop-while #(not= % \-) line))]
    ;; merge hashmaps, with tab string values taking precedence
    (into
     ;; construct a hashmap of index -> stuff to play
     ;; spanning the length of the line
     (zipmap (range (count tab-string)) (cycle [nil]))
     ;; now we will have a seq of [index value] pairs
     (map
      (fn [m] [(:start m) (Integer/parseInt (:group m))])
      (re-seq-pos #"\d+" tab-string)))))

;; extract out the parsing section from play-tab() so we can use the
;; data for visualization
(defn parse-guitar-tab [guitar-tab]
  (let [index-line-list (filter
                         ;; a tab line must contain "-"
                         (fn [[_ s]] (.contains s "-"))
                         (into {} (map-indexed vector (s/split-lines guitar-tab))))
        index-to-line (into {} index-line-list)

        ;; collect-into-consecutive will return
        ;; a seq containing sets of 6 consecutive indexes [i_{n+0} ... i_{n+5}]
        ;; which we assume map to sets of 6 lines within the tab file.
        ;; in other words we are ignoring all the intervening lines, be them
        ;; comments or dynamics or major chord labels or whatnot
        ;; NOTE keys() here acts the same as (map first index-line-list)
        ;; since index-line-list is not a hash-map
        index-group-list (collect-into-consecutive (keys index-line-list))

        ;; from the 6-line groups, get lines from the original index-line maps
        ;; and sorted by increasing line indexes.
        ;; how this works:
        ;; 1. each set of 6 indexes gets passed to the lambda function
        ;; 2. using index-to-line, select the 6 matching lines as a hash-map
        ;; 3. sort by keys to ensure increasing line index order
        ;; 4. get the vals, i.e., the lines in correct order
        ;; now, we have a seq containing sets of 6 lines
        sorted-grouped-line-set-list (map #(vals (sort (select-keys index-to-line %)))
                                          ;; these will be grouped into sets of 6 lines, with indexes
                                          (sort index-group-list))
        ]

    ;; now we apply to everything
    (apply
     concat
     (map (fn [play-map]
            (let [max-beat (apply max (keys play-map))]
              (map play-map (range max-beat))))
          (for [line-set sorted-grouped-line-set-list]
            ;; map over each line in the line-set, with string index
            (apply
             merge-with concat
             ;; note the reverse
             (for [[string-index tab-line] (map-indexed vector (reverse line-set))]
               ;; now we need to parse the tab-line...
               ;; collect each string's results into into {}
               (into {}
                     ;; create index -> []
                     ;; when no string is played, for rest
                     (map (fn [[k v]] [k (if v
                                          [string-index v]
                                          [])])
                          (parse-guitar-tab-line tab-line))))))))))

;; first, filter out all lines that don't look like guitar lines
;; use map-index because we need to keep ordering information
(defn play-tab [guitar-tab]
  (let [play! (partial guitar-pick-note-sequence 80)]
    (play!
     (parse-guitar-tab guitar-tab))))

(play-tab fast-car-tab)



;; let's now introduce quil and whip up a simple visualizater for the tab
;; make sure you've added quil to the namespace

;; convenience map for window related config entries
(def vis-conf {:width 1300
               :height 360})

;; create an atom for our visualizer's play state
(def vis-state (atom {:play-list (take 50 (parse-guitar-tab fast-car-tab))
                      :index 0}))
;; this is a beat generator. it keeps ticking by the given timing
(def metro (metronome 72))

;; gets called once, when the vis is created
(defn setup []
  (q/smooth) ;; anti aliasing
  (q/frame-rate 15))

;; the draw function gets called on every frame refresh
;; we'll do it live! modify and eval draw() and see it update
(defn draw []
  ;; set black
  (q/fill 0)
  ;; draw a black rect that fills the canvas
  (q/rect 0 0 (:width vis-conf) (:height vis-conf))

  (let [x0 10 ;; offsets
        y0 10

        n-block (count (@vis-state :play-list))
        block-width (/ (- (:width vis-conf) (* 2 x0)) n-block)
        block-height (/ (:height vis-conf) 2)
        ]

    ;; iterate through the note list
    (doseq [ith (range n-block)]

      ;; draw a bunch of boxes
      (q/stroke 40 40 0)
      (q/stroke-weight 2)
      ;; set the box color here using rgb
      ;; highlight just the box corresponding to the current index
      (apply q/fill (if (= ith (:index @vis-state))
                      [230 100 255]
                      ;; make a gradient
                      [(+ 20 (* 2 ith))]))
      (q/rect (+ x0 (* block-width ith)) y0
              block-width block-height)

      ;; dimmer
      (q/fill 100)
      (q/text (str ith)
              (+ x0 (* block-width ith))
              (+ y0 20 block-height))

      ;; for the tab text, use a lighter color
      (q/fill 220)
      (let [notes (nth (@vis-state :play-list) ith)]
        (doseq [[string-index fret-index] (partition 2 notes)]
          (q/text (str fret-index)
                  (+ x0 (* block-width ith))
                  (+ y0 40 block-height
                     (- 120 (* 20 string-index)))))))))

;; this launches the sketch
(q/defsketch mysketch
  :title "visualizer"
  :setup setup
  :draw draw
  :size (map vis-conf [:width :height]))

;; now we need a player function
(let [my-guitar (guitar) ;; want to save it so we can manipulate its gate value
      play-guitar (partial guitar-pick my-guitar) ;; from earlier
      ]
  (letfn [(vis-play []
            ;; advance the index BEFORE the notes get played.
            ;; that way it syncs properly with the playhead
            ;; we also need to modulo the increment
            ;; so it doesn't out of bounds the list
            (swap! vis-state assoc :index (mod
                                           (inc (:index @vis-state))
                                           (count (:play-list @vis-state))))
            ;; if you omit this, the guitar won't fade quickly enough
            ;; and the audio "fills up" and stutters out after a while.
            ;; (feel free to try)
            (ctl my-guitar :gate 0)
            (doseq [[string-index fret-index] (partition 2 (nth (:play-list @vis-state) (:index @vis-state)))]
              ;; use our own play-guitar function
              ;; so we get the gate reset
              (play-guitar string-index fret-index))
            )
          ;; now define a function to play by the metronome
          (play-notes [m beat-num]
            (let [next-beat (inc beat-num)]
              (at (m (+ 0 beat-num)) (vis-play))
              ;; finally the recursive part
              (apply-at (m next-beat) play-notes [m next-beat]))
            )
          ]
    ;; it will auto-play forever
    (play-notes metro (metro)))
  )

;; speed it up
(metro-bpm metro 180)

(stop)


;; let's try something different now
;; here's a quick demo of shadertone, just for fun
(require '[shadertone.tone :as t])
;; added a file in ohack/wave.glsl, which is taken directly from
;; https://github.com/overtone/shadertone/blob/master/examples
(t/start "wave.glsl" :width 1000 :height 400)

;; you can then start a window and visualize e.g.
(guitar-pick (guitar) 0 0)

;; keep it on if you want, or stop it
(t/stop)

;; you can look into the glsl file to see how it works.  the edits you
;; make to the glsl file will be updated live.  if you really want to go
;; down this route, you'll have to understand GLSL... so we'll leave it
;; at that.  if you want to learn more, https://www.shadertoy.com/ is a
;; neat place to check out

;; moving along

;; let's define a little melody
(def t-melody (let [_ nil
                    motif [:iii _ :vii- :i     :ii _ :i :vii-     :vi- _ :vi- :i      :iii _ :ii :i
                           :vii- _ :vii- :i     :ii _ :iii _     :i _ :vi- _      :vi- _ _ _
                           _ :ii _ :iv    :vi _ :v :iv    :iii _ :i :ii     :iii _ :ii :i
                           :vii- _ :vii- :i :ii _ :iii _ :i _ :vi- _ :vi- _ _ _]
                    ;; interlude [:iii _ _ _ :i _ _ _ :ii _ _ _ :vii- _ _ _
                    ;;            :i _ _ _ :vi- _ _ _ :v-# _ _ _ :vii- _ _ _
                    ;;            :iii _ _ _ :i _ _ _ :ii _ _ _ :vii- _ _ _
                    ;;            :i _ :iii _ :vi _ _ _ :v# _ _ _ _ _ _ _]
                    ]
                (interleave (concat
                             ;; deliberately shortening it here
                             motif
                             ;; motif interlude motif
                             )
                            (cycle [_]))))
(def t-alto (let [_ nil]
              [:vii _  _ _  :v# _  :vi _  :vii _ :iii+ :ii+ :vi _ :v _
               :iii _  _ _  :iii _ :vi _  :i+ _ _ _ :vii _ :vi _
               :v# :v# :iii _  :v# _ :vi _    :vii _ _ _ :i+ _ _ _
               :vi _ _ _ :iii _ _ _ :iii _ _ _     _ _ _ _
               _ _ :iv _    _ _ :vi _    :i+ _ :i+ :i+    :vii _ :vi _
               :v _   _ _ _ _   :iii _  :v _ :vi :v :iv _ :iii _
               :v# _ :iii _ :v# _ :vi _  :vii _ :v _ :i+ _ :v _
               :vi _ :iii _ :iii _ _ _   :iii _ _ _  _ _ _ _ _ _ _ _]))
(def t-bass (let [_ nil]
              (interleave [:iii-- :iii- :iii-- :iii-  :iii-- :iii- :iii-- :iii-       :vi-- :vi- :vi-- :vi- :vi-- :vi- :vi-- :vi-
                           :v#-- :v#- :v#-- :v#-  :iii-- :iii- :iii-- :iii-       :vi-- :vi- :vi-- :vi-   :vi-- :vi- :vii-- :i-
                           :ii- :ii-- _ :ii--   _ :ii-- :vi-- :iv--     :i-- :i- _ :i-          :i-- :v-- :v-- :i--
                           :vii-- :vii- _ :vii-    :iii- _ :v#- _   :vi-- :iii- :vi-- :iii-    :vi-- _ _ _]
                          (cycle [_]))))

;; define a melody player
(defn play [notes & {:keys [start-time speed instrument]
                     :or {start-time (now)
                          speed 100
                          instrument sampled-piano
                          }}]
  (when-not (empty? notes)
    (when-let [note (first notes)]
      (at start-time (instrument note)))
    (let [next-time (+ start-time speed)]
      (apply-at next-time play [(rest notes)
                                :start-time next-time
                                :speed speed
                                :instrument instrument]))))

;; you can try it if you want
(play (degrees->pitches t-melody :major :C4))


;; instead of the default piano, let's use simple waves
(definst triangle-wave [freq 440 attack 0.0001 sustain 0.1 release 0.3 vol 1.0]
  (* (env-gen (lin attack sustain release) 1 1 0 1 FREE)
     (lf-tri freq)
     vol))

(definst square-wave [freq 440 attack 0.005 sustain 0.15 release 0.3 vol 1.0]
  (* (env-gen (lin attack sustain release) 1 1 0 1 FREE)
     (square freq)
     vol))

;; now we want to try it out
;;
;; note: unlike piano and sampled-piano, which take note values,
;; wave instruments take Hz!
;; if you pass the wrong value, it will play, but will not be pleasant.
;; let's define a converter from note values to Hertz using overtone's
;; midi->hz function
(def ->hz (partial map #(and % (midi->hz %))))

;; if you still have the shadertone window open, you can check out the
;; triangular shape of triangle-wave and square shape of square-wave
(play (->hz (degrees->pitches t-melody :major :C4)) :instrument square-wave)

;; !!! moved the play block to the bottom

;; now we want to spice it up with a beat.
;; let's make a little track player and use a metronome

;; convenience fn to make a map, storing the track attributes.
;; currently we just add the :muted state
;; added instrument info
(defn gen-track [inst melody]
  {:melody melody
   :muted false
   :instrument inst})

;; here's the track state atom
;; updated to contain instruments
(def mystate (atom {:index 0
                    :track-list (let [_ nil]
                                  {:tetris-melody   (gen-track square-wave
                                                     (degrees->pitches
                                                      t-melody
                                                      :major :C5))
                                   :tetris-alto     (gen-track square-wave
                                                     (degrees->pitches
                                                      t-alto
                                                      :major :C4))
                                   :tetris-bassline (gen-track triangle-wave
                                                     (degrees->pitches
                                                      t-bass
                                                      :major :C3))

                                   ;; define some beat tracks

                                   ;; to fix the beat problem in the most lazy way
                                   ;; we will just wrap the percussion instruments in
                                   ;; a function that will throw away the incoming hz
                                   ;; value. a nicer method... is left as an exercise
                                   :beat-my-hat    (gen-track (fn [_] (my-hat))    (take 128 (cycle [1 _])))
                                   :beat-close-hat (gen-track (fn [_] (close-hat)) (take 128 (cycle [_ 1])))
                                   :beat-fs-kick   (gen-track (fn [_] (fs-kick))   (take 128 (cycle [1 _ _ _  _ _ _ _  _ _ _ _  _ _ _ _])))
                                   :beat-my-kick   (gen-track (fn [_] (my-kick))   (take 128 (cycle [_ _ _ _  _ _ _ _  1 _ _ _  _ _ _ _])))
                                   :beat-open-hat  (gen-track (fn [_] (open-hat))  (take 128 (cycle [_ _ 1 _])))
                                   :beat-snare     (gen-track (fn [_] (snare))     (take 128 (cycle [_ _ _ _  1 _ _ _])))

                                   })
                    }))

;; define some beat making instruments
(definst my-kick [freq 140 dur 0.2 width 0.1]
    (let [freq-env (* freq (env-gen (perc 0 (* 0.99 dur))))
          env (env-gen (perc 0.01 dur) 1 1 0 1 FREE)
          sqr (* (env-gen (perc 0 0.01)) (pulse (* 2 freq) width))
          src (sin-osc freq-env)
          drum (+ sqr (* env src))]
      (compander drum drum 0.2 1 0.1 0.01 0.01)))
(definst my-hat [amp 1.0 t 0.20]
  (let [env (env-gen (perc 0.001 t) 1 1 0 1 FREE)
        noise (white-noise)
        sqr (* (env-gen (perc 0.01 0.04)) (pulse 880 0.2))
        filt (bpf (+ sqr noise) 9000 0.5)]
    (* amp env filt)))

;; you can try them out with
(my-kick) ;; ... etc

;; overtone also has convenience methods to load and cache other sounds
;; directly from freesound.org. we'll use 4 nice percussion sounds
(def snare (sample (freesound-path 26903)))
(def close-hat (sample (freesound-path 802)))
(def open-hat (sample (freesound-path 26657)))
(def fs-kick (sample (freesound-path 777)))
;; it may take a while to download


;; start building the melody player
(let []
  (stop)
  ;; it's too slow, let's change the next-tick to be faster
  ((defn play-track-map [time-tick track-map]
     (let [next-tick (+ 0.25 time-tick)]
       ;; cheat a little here, by reading the track state from
       ;; the original atom
       (doseq [[track-name track-state] (@mystate :track-list)]
         (when-let [note (if (:muted track-state)
                           nil
                           (first (->hz (:melody (track-map track-name)))))]
           (at (metro time-tick)
               ;; now it plays a single note with all the instruments
               ((:instrument track-state) note))))
       ;; if there are notes left, we need to schedule play-track-map again
       (when (some (fn [[k m]] (not (empty? (:melody m)))) track-map)
         (apply-at (metro next-tick) play-track-map [next-tick
                                                     ;; we need to send in track-map
                                                     ;; where rest() is applied to each :melody value
                                                     (into {}
                                                           (map
                                                            (fn [[k m]]
                                                              [k (update-in m [:melody] rest)])
                                                            track-map))
                                                     ])))
     )
   (metro)
   ;; let's make it play forever now, by constructing a copy of mystate
   ;; where the tracks are infinite
   (into {}
         (map (fn [[k m]]
                [k (update-in m [:melody]
                              ;; also make sure they are the same length
                              ;; or else they will loop at different times!
                              ;; t-alto is (mistakenly) length 132
                              #(cycle (take 128 %)))])
              (@mystate :track-list)))
   ))

;; you can toggle each track on/off by evaluating e.g.
(swap! mystate update-in [:track-list :tetris-melody :muted] not)
(swap! mystate update-in [:track-list :tetris-alto :muted] not)
(swap! mystate update-in [:track-list :tetris-bassline :muted] not)
(swap! mystate update-in [:track-list :beat-my-hat :muted] not)

(stop)

;; let's try one more thing
(defn derive-transition-map [el-seq & {:keys [wrap-around] :or {wrap-around false}}]
  "for a given sequence, get the transition probabilities for one item
    to the next. the return value is a map looking like
    {element_1 {element_1_1 count_1_1, element_1_2 count_1_2}
     element_2 {element_2_8 count_2_8, element_2_1 count_2_1, element_2_3 ...
   if :wrap-around true is specified, the final element in el-seq
   is mapped to the first element"
  (loop [el-seq (concat el-seq [(if wrap-around (first el-seq))])
         rtn {}]
    (let [next-el (second el-seq)]
      (if (nil? next-el)
        rtn
        (recur (rest el-seq)
               (let [cur-el (first el-seq)
                     el-map (or (rtn cur-el) {})]
                 ;; each element gets mapped to a map with keys that
                 ;; are the subsequent element
                 (assoc rtn cur-el
                        ;; construct a map where keys are the next element
                        ;; and values are the times that element has shown up
                        (assoc el-map next-el (inc (el-map next-el 0))))))))))

(defn get-next-from-xns-map
  "given a transition map and a current value that is inside that map,
  probabilistically select a subsequent value. an optional default
  can be given, else nil is returned"
  ([xns-map current] (get-next-from-xns-map xns-map current nil))
  ([xns-map current default]
   (or (if-let [next-candidate-map (xns-map current)]
         ;; select the next value with probabilities based on
         ;; relative counts of the possible outcomes in the map
         (let [choice-list (seq next-candidate-map)
               cumsum (reduce + (map second choice-list))
               choice (rand-int cumsum)
               ]
           (loop [start-sum 0
                  choice-list choice-list
                  ]
             (let [[value proportion] (first choice-list)
                   cur-sum (+ start-sum proportion)]
               (if (< choice cur-sum)
                 value
                 (recur cur-sum
                        (rest choice-list))
                 )))

           )
         )
       default)))

(defn make-markov-iterator [sample-melody]
  (let [xns-map (derive-transition-map sample-melody :wrap-around true)]
    (iterate #(get-next-from-xns-map xns-map %)
             (first sample-melody))))

;; revisiting this old code...
(let [tempo 200
      bass-scale :C4
      melody-scale :C5
      majmin :major

      ;; we will iterate over this: melody, root scale, instrument
      track-list [
                  [t-bass bass-scale triangle-wave]
                  [t-alto bass-scale square-wave]
                  [t-melody melody-scale square-wave]
                  ]

      ]
  ;; stop all playback before starting a new one
  (stop)

  (doseq [[note-seq scale inst] track-list]
    (play (->hz (degrees->pitches
                 ;; we can change just this part...
                 (make-markov-iterator (remove nil? note-seq))
                 majmin scale))
          :speed tempo
          :instrument inst))

  )

;; playing notes using fixed slots for beats and rests is a bit restrictive.
;; let's make a play function that allows you to specify individual note
;; attributes (yes, i know we're kind of reinventing midi here)
;;
(let [beat-ms 100
      ;; make nbeat optional, defaulting to 1 beat
      gen-note (fn [pitch & [nbeat]]
                 {:pitch pitch
                  :duration (* (or nbeat 1) beat-ms)})
      ;; now we want play to take maps created by gen-note
      ;; instead of single pitch values
      play (fn play [mnotes & {:keys [start-time duration instrument]
                              :or {start-time (now)
                                   duration beat-ms
                                   instrument sampled-piano
                                   }}]
             (when-not (empty? mnotes)
               (let [{:keys [pitch duration]} (first mnotes)]
                 (when pitch
                   (at start-time (instrument pitch)))
                 (let [next-time (+ start-time duration)]
                   (apply-at next-time play [(rest mnotes)
                                             :start-time next-time
                                             :duration duration
                                             :instrument instrument])))))

      ;; move over that map code into a separate function
      convert-to-new-style (fn [old-melody root-key]
                             (map
                              (fn [[degree n-nil]]
                                (gen-note degree (inc n-nil)))
                              (partition 2
                                         (map (fn [part]
                                                (if (nil? (first part))
                                                  (count part)
                                                  (first part)))
                                              (partition-by nil?
                                                            (degrees->pitches old-melody
                                                                              :major root-key))))))]
  ;; test that it works
  ;; (play (map #(gen-note % (inc (rand-int 4))) (range 60 68)))

  (stop)

  ;; now let's convert the old t-melody to a duration version
  ;; (play (convert-to-new-style t-melody :C4))

  ;; we're not playing alto. the reason is because alto is on a different
  ;; time signature, and applying the same partition method to convert it
  ;; to durations doesn't actually line them up. try it and you'll hear.

  ;; (play (convert-to-new-style t-bass :C3))

  ;; let's do a final manipulation
  (play
   (let [num-play 128]
     (map
      (fn [p d]
        {:pitch p :duration d})
      (take num-play (make-markov-iterator (map :pitch (convert-to-new-style t-melody :C4))))
      (take num-play (make-markov-iterator (map :duration (convert-to-new-style t-melody :C4)))))))


  )
