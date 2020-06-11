;    Copyright (C) 2013-2015  Joseph Fosco. All Rights Reserved
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.

(ns transport.melody
  (:require
   [overtone.live :refer [MIDI-RANGE]]
   [transport.behavior :refer [get-behavior-action get-behavior-player-id]]
   [transport.constants :refer :all]
   [transport.dur-info :refer [get-dur-millis get-dur-beats]]
   [transport.ensemble-status :refer [get-average-density get-density-trend get-ensemble-density
                                      get-average-note-durs get-ensemble-average-pitch get-ensemble-density
                                      get-ensemble-density-ratio get-ensemble-most-common-note-durs get-pitch-trend
                                      get-pitch-trend-diff]]
   [transport.instrument :refer [get-instrument-range-hi get-instrument-range-lo]]
   [transport.melodychar :refer [get-melody-char-density get-melody-char-note-durs get-melody-char-range
                                 get-melody-char-range-lo get-melody-char-range-hi get-melody-char-pitch-smoothness
                                 get-melody-char-vol-smoothness set-melody-char-range]]
   [transport.melodyevent :refer [create-melody-event get-dur-info-for-event get-follow-note-for-event
                                  get-instrument-info-for-event get-seg-num-for-event]]
   [transport.messages :refer :all]
   [transport.message-processor :refer [register-listener]]
   [transport.pitch :refer [get-scale-degree next-pitch]]
   [transport.players :refer :all]
   [transport.random :refer [random-int weighted-choice]]
   [transport.rhythm :refer [get-dur-info-for-beats get-dur-info-for-mm-and-millis next-note-dur note-dur-to-millis]]
   [transport.volume :refer [select-volume select-volume-for-next-note]]
   [transport.util.util-constants :refer [DECREASING INCREASING]]
   [transport.util.utils :refer :all]
   )
  (:import
   transport.melodychar.MelodyChar
   )
  )

(def DENSITY-PROBS [1 2 2 3 3 7 9 10 12 17])
(def PITCH-SMOOTHNESS-PROBS [3 3 4 4 5 5 6 6 8 10])
(def VOL-SMOOTHNESS-PROBS [1 1 5 4 3 3 2 2 1 1])
(def DENSITY-BASE-CHANGE 3)

(def cur-density-probs (atom []))
(def loud-player (atom nil))        ;; player-id of loud player interrupt
(def loud-player-time (atom nil))   ;; start time of loud player interrupt

(defn melody-loud-interrupt-event
  [& {:keys [player-id time]}]
  (if (nil? @loud-player)
    (do
      (reset! loud-player player-id)
      (reset! loud-player-time time)
      (dotimes [i 12]
        (print-msg "melody-loud-interrupt-event" "**** LOUD INTERRUPT EVENT START ****" " loud-player: " @loud-player)
        )
      ))
  )

(defn init-melody
  "Set loud player vars to nil and register listener for MSG-LOUD-INTERUPT-EVENT"
  []
  (reset! loud-player nil)
  (reset! loud-player-time nil)
  (reset! cur-density-probs DENSITY-PROBS)
  (register-listener
   MSG-LOUD-INTERUPT-EVENT
   transport.melody/melody-loud-interrupt-event
   nil
   )
  true
  )

(defn reset-melody
  []
  (init-melody)
  )

(comment - old fnc
(defn get-new-density-prob-value
  [value max-change index threshold max-index density-trend]
  ;; INCREASING [10 10 10 10 10 10 10 10 10 10] -> [9 9 9 8 7 | 13 12 11 11 11]
  ;; DECREASING [10 10 10 10 10 10 10 10 10 10] -> [11 11 11 12 13 | 7 8 9 9 9]
  (let [amt (if (or (> index threshold) (= threshold max-index index))
              (if (= density-trend INCREASING)
                (max (+ (- (inc threshold) index) max-change) 1)
                (min (- (- index (inc threshold)) max-change) -1)
                )
              (if (= density-trend INCREASING)
                (min (- (- threshold index) max-change) -1)
                (max (+ (- index threshold) max-change) 1)
                )
              )
        ]
    (max (+ value amt) 0)
    )
  )
)

(comment - old fnc
(defn get-new-density-prob-value
  [value max-change index threshold max-index density-trend]
  ;; INCREASING [10 10 10 10 10 10 10 10 10 10] -> [9 9 9 8 7 13 12 11 10 10]
  ;; DECREASING [10 10 10 10 10 10 10 10 10 10] -> [13 12 11 10 9 9 9 9 8 7]
  (let [amt (if (or (> index threshold) (= threshold max-index index))
              (if (= density-trend INCREASING)
                (max (+ (- (inc threshold) index) max-change) 0)
                (min (- (- max-index index) max-change) -1)
                )
              (if (= density-trend INCREASING)
                (min (- (- threshold index) max-change) -1)
                (- max-change index)
                )
              )
        ]
    (max (+ value amt) 0)
    )
  )
  )

(comment - old fnc
(defn get-new-density-prob-value
  [value max-change index threshold max-index density-trend]
  ;; INCREASING [10 10 10 10 10 10 10 10 10 10] -> [9 9 9 8 7 13 12 11 11 11]
  ;; DECREASING [10 10 10 10 10 10 10 10 10 10] -> [13 12 11 11 11 9 9 9 8 7]
  (let [amt (if (or (> index threshold) (= threshold max-index index))
              (if (= density-trend INCREASING)
                (max (+ (- (inc threshold) index) max-change) 1)
                (min (- (- max-index index) max-change) -1)
                )
              (if (= density-trend INCREASING)
                (min (- (- threshold index) max-change) -1)
                (max (- max-change index) 1)
                )
              )
        ]
    (max (+ value amt) 0)
    )
  )
  )

(defn- get-new-density-prob-value
  [value above-change below-change index threshold max-index density-trend]
  ;; Random change + or - between 1 and max-change
  (let [amt (if (= density-trend INCREASING)
              (if (>= index threshold)
                (if (> above-change 0) (inc (rand-int above-change)) 0)
                (if (> below-change 0) (* (inc (rand-int below-change)) -1) 0)
                )
              (if (>= index threshold)
                (if (> above-change 0) (* (inc (rand-int above-change)) -1) 0)
                (if (> below-change 0) (inc (rand-int below-change)) 0)
                )
              )
        ]
    (max (+ value amt) 0)
    )
  )

(defn- adjust-density-probs-based-on-ensemble
  [probs & {:keys [above-change-val below-change-val threshold density-trend]
            :or {above-change-val 1 below-change-val 1}}]
  (let [;; highest index containing a non-zero value
        max-index (loop [density-probs probs ndx (dec (count probs))]
                    (cond (> (get density-probs ndx) 0) ndx
                          (= ndx 0) nil
                          :else
                          (recur (subvec density-probs 0 ndx) (dec ndx))))
        ]
    (cond (or (= density-trend INCREASING) (= density-trend DECREASING))
          (let [new-probs (mapv get-new-density-prob-value
                                probs
                                (repeat above-change-val)
                                (repeat below-change-val)
                                (range (count probs))
                                (repeat threshold)
                                (repeat max-index)
                                (repeat density-trend)
                                )
                ]
            (if (= 0 (reduce + new-probs)) '[0 0 0 0 0 0 0 0 0 1] new-probs)
            )
          :else probs
          )
    )
  )

(defn- select-melody-density
  "Returns a number from 0 to 9 to determine how continuous (dense)
   the melody will be.
   0 - discontinuous (all rests) -> 9 - continuous (few rests)"
  ([] (weighted-choice DENSITY-PROBS))
  ([player]
     (let [ensemble-density (get-ensemble-density)
           cur-density-trend (get-density-trend)
           threshold (if (= cur-density-trend INCREASING)
                       (min (inc ensemble-density) 9)
                       (max (dec ensemble-density) 0))
           ]
         (cond
          (= (get-behavior-action (get-behavior player)) SIMILAR-ENSEMBLE)
          (weighted-choice (adjust-density-probs-based-on-ensemble @cur-density-probs
                                                                   :above-change-val 5
                                                                   :below-change-val 5
                                                                   :threshold threshold
                                                                   :density-trend cur-density-trend
                                                                   :ensemble-density ensemble-density
                                                                   ))
          (= (get-behavior-action (get-behavior player)) CONTRAST-ENSEMBLE)
          (let [ens-density (int (+ (get-average-density) 0.5))]
            (weighted-choice (vec (reverse @cur-density-probs)))
            )
          :else
          (do
            (let [the-density-probs @cur-density-probs
                  high-subvec (subvec the-density-probs threshold)
                  low-subvec (subvec the-density-probs 0 threshold)
                  high-total (reduce + high-subvec)
                  low-total (reduce + low-subvec)
                  above-change-val (if (= cur-density-trend INCREASING)
                                     (if (or (= low-total 0) (= low-total (last low-subvec))) 0 DENSITY-BASE-CHANGE)
                                     (cond (= high-total 0) 0
                                           (= high-total (first high-subvec)) (max (quot high-total 2) DENSITY-BASE-CHANGE)
                                           :else (+ DENSITY-BASE-CHANGE (quot (reduce max high-subvec) 25)))
                                     )
                  below-change-val (if (= cur-density-trend INCREASING)
                                     (cond (= low-total 0) 0
                                           (= low-total (last low-subvec)) (max (quot low-total 2) DENSITY-BASE-CHANGE)
                                           :else (+ DENSITY-BASE-CHANGE (quot (reduce max low-subvec) 25)))
                                     (if (or (= high-total 0) (= high-total (first high-subvec))) 0 DENSITY-BASE-CHANGE)
                                     )
                  ]
              (if (= 0 above-change-val below-change-val)
                (weighted-choice @cur-density-probs)
                (weighted-choice (swap! cur-density-probs adjust-density-probs-based-on-ensemble
                                        :above-change-val above-change-val
                                        :below-change-val below-change-val
                                        :threshold threshold
                                        :density-trend cur-density-trend
                                        :ensemble-density ensemble-density))
                )
              ))
          )
       )
     )
  ([player cntrst-plyr cntrst-melody-char]
     (let [cntrst-density (get-melody-char-density cntrst-melody-char)
           the-density-probs @cur-density-probs
           cntrst-density-probs (cond
                                    (and (> cntrst-density 0) (< cntrst-density 9))
                                    (if (and (= (reduce + (subvec the-density-probs 0 (dec cntrst-density))) 0)
                                             (= (reduce + (subvec the-density-probs (+ cntrst-density 2))) 0)
                                             )
                                      '[1 0 0 0 0 0 0 0 0 1]
                                      (assoc the-density-probs
                                        (dec cntrst-density) 0
                                        cntrst-density 0
                                        (inc cntrst-density) 0)
                                      )
                                    (= cntrst-density 0)
                                    (if (= (reduce + (subvec the-density-probs 2)) 0)
                                      '[0 0 0 0 0 0 0 0 0 1]
                                      (assoc @cur-density-probs 0 0 1 0))
                                    :else
                                    (if (= (reduce + (subvec the-density-probs 0 8)) 0)
                                      '[1 0 0 0 0 0 0 0 0]
                                      (assoc @cur-density-probs 8 0 9 0))
                                    )
           ]
       (weighted-choice cntrst-density-probs)
       ))
  )

(defn- select-melody-note-durs
  "Returns a number from 0 to 9 to determine how dense
   the melody will be.
   0 - sparse  (few notes, all long duration) -> 9 - dense (many notes of short duration)"
  ([] (rand-int 10))
  ([player]
     (cond
      (= (get-behavior-action (get-behavior player)) SIMILAR-ENSEMBLE)
      (let [most-common-note-durs (get-ensemble-most-common-note-durs)]
        (cond (< 0 most-common-note-durs 9)
              (random-int (dec most-common-note-durs) (inc most-common-note-durs))
              (= 0 most-common-note-durs)
              (random-int 0 2)
              :else
              (random-int 7 9)
              )
        )
      (= (get-behavior-action (get-behavior player)) CONTRAST-ENSEMBLE)
      (let [ens-note-durs (round-number (get-average-note-durs))]
        (rem (+ (round-number (get-average-note-durs)) 5 ) 10)
        )
      :else (rand-int 10))
     )
  ([player cntrst-plyr cntrst-melody-char]
     (let [cntrst-note-durs (get-melody-char-note-durs cntrst-melody-char)]
       (rem (+ (get-melody-char-note-durs cntrst-melody-char) 5) 10)
       ))
  )

(defn- select-melody-range
  "Returns a list that is the lo note and the hi note of
   the melody's range."
  ([lo-range hi-range]
     (let [range-lo (random-int lo-range hi-range)]
       (list range-lo (random-int range-lo hi-range))))
  ([player]
     (if (= (get-behavior-action (get-behavior player)) SIMILAR-ENSEMBLE)
       (let [instrument-hi (get-instrument-range-hi (get-instrument-info player))
             instrument-lo (get-instrument-range-lo (get-instrument-info player))
             ]
         (cond (= (get-pitch-trend) INCREASING)
               (do
                 (print-msg "select-melody-range" "selecting INCREASING Range")
                 (list (max (min (int (+ (nil-to-num (get-ensemble-average-pitch) MIDI-LO)
                                         (max (- (int (get-pitch-trend-diff)) 12)) 0))
                                 instrument-hi)
                            instrument-lo)
                       instrument-hi
                       )
                 )
               (= (get-pitch-trend) DECREASING)
               (do
                 (print-msg "select-melody-range" "selecting DECREASING Range")
                 (list instrument-lo
                       (max (min (int (+ (nil-to-num (get-ensemble-average-pitch) MIDI-LO)
                                         (+ (int (get-pitch-trend-diff)) 12)))
                                 instrument-hi)
                            instrument-lo)
                       )
                 )
               :else
               (list (max (max (int (- (nil-to-num (get-ensemble-average-pitch) MIDI-LO) 36)) MIDI-LO)
                          (get-instrument-range-lo (get-instrument-info player)))
                     (min (min (int (+ (nil-to-num (get-ensemble-average-pitch) MIDI-HI) 36)) MIDI-HI)
                          (get-instrument-range-hi (get-instrument-info player)))
                     )
               ))
       (list (get-instrument-range-lo (get-instrument-info player))
             (get-instrument-range-hi (get-instrument-info player))
             )
       )
     )
  ([player cntrst-plyr cntrst-melody-char]
     ;; if CONTRASTing player has narrow range
     ;;   use as wide a range as possible
     ;;   else use a range no wider than an octave
     (let [cntrst-range (get-melody-char-range cntrst-melody-char)
           cntrst-hi (second cntrst-range)
           cntrst-lo (first cntrst-range)
           ]
       (if (< (- cntrst-hi cntrst-lo) 13)
         (list (get-instrument-range-lo (get-instrument-info player))
               (get-instrument-range-hi (get-instrument-info player))
               )
         (let [player-lo (get-instrument-range-lo (get-instrument-info player))
               player-hi (get-instrument-range-hi (get-instrument-info player))
               range-in-semitones (rand-int 13)
               melody-range-lo (cond
                                (or (> player-lo cntrst-hi) (< player-hi cntrst-lo))
                                player-lo
                                (<= (+  cntrst-hi range-in-semitones) player-hi)
                                (min (inc cntrst-hi) (second MIDI-RANGE))
                                (<= (+  player-lo range-in-semitones) cntrst-lo)
                                player-lo
                                (< player-lo cntrst-lo)
                                player-lo
                                :else
                                (max (- player-hi range-in-semitones) 0)
                                )
               ]
           (list melody-range-lo (min player-hi (+ melody-range-lo range-in-semitones))))
         )
       ))
  )

(defn adjust-melody-char-range
  "Returns new :melody-char for player that has the range adjusted
   to be within the range of the player's instrument"
  [melody-char inst-info]
  (set-melody-char-range melody-char (list (max (get-instrument-range-lo inst-info)
                                                (min (get-melody-char-range-lo melody-char)
                                                     (get-instrument-range-hi inst-info)
                                                     )
                                                )
                                           (min (get-instrument-range-hi inst-info)
                                                (max
                                                 (get-melody-char-range-hi melody-char)
                                                 (get-instrument-range-lo inst-info))
                                                )
                                           ))
  )

(defn- select-melody-pitch-smoothness
  "Returns a number from 0 to 9 to determine how smooth (stepwise)
   the melody will be (steps vs skips).
   0 - mostly steps -> 9 - mostly skips (wide skips)"
  ([] (weighted-choice PITCH-SMOOTHNESS-PROBS))
  ([player]
     (weighted-choice PITCH-SMOOTHNESS-PROBS)
     )
  ([player cntrst-plyr cntrst-melody-char]
     (let [cntrst-smoothness (get-melody-char-pitch-smoothness cntrst-melody-char)]
       (cond
        (and (> cntrst-smoothness 0) (< cntrst-smoothness 8))
        (let [smoothness (rand-int 7)]
          (if (> smoothness (dec cntrst-smoothness)) smoothness (+ smoothness 3)))
        (< cntrst-smoothness 3)
        (random-int 0 1)
        :else
        (random-int 8 9)
        )))
  )

(defn- select-melody-vol-smoothness
  "Returns a number from 0 to 9 to determine how smooth the volume
   will be note to note (same volume level vs large changes in volume level).
   0 - same volume -> 9 - large volume changes"
  ([] (weighted-choice VOL-SMOOTHNESS-PROBS))
  ([player]
     (weighted-choice VOL-SMOOTHNESS-PROBS)
     )
  ([player cntrst-plyr cntrst-melody-char]
     (let [cntrst-smoothness (get-melody-char-vol-smoothness cntrst-melody-char)]
       (cond
        (and (> cntrst-smoothness 1) (< cntrst-smoothness 8))
        (let [smoothness (rand-int 7)]
          (if (> smoothness (dec cntrst-smoothness)) smoothness (+ smoothness 3)))
        (< cntrst-smoothness 3)
        (random-int 0 1)
        :else
        (random-int 8 9)
        )))
  )

(defn select-random-melody-characteristics
  [lo-range hi-range]
  (MelodyChar. (select-melody-density)
               (select-melody-note-durs)
               (select-melody-range lo-range hi-range)
               (select-melody-pitch-smoothness)
               (select-melody-vol-smoothness)
               )
  )

(defn select-melody-characteristics
  [player]
  (let [cntrst-plyr (if (= (get-behavior-action (get-behavior player)) CONTRAST-PLAYER)
                      (get-player-map (get-behavior-player-id (get-behavior player)))
                      nil)
        ]
    (if (= cntrst-plyr nil)
      (MelodyChar. (select-melody-density player)
                   (select-melody-note-durs player)
                   (select-melody-range player)
                   (select-melody-pitch-smoothness player)
                   (select-melody-vol-smoothness player)
                   )
      (do (let [cntrst-melody-char (get-melody-char cntrst-plyr)]
            (MelodyChar. (select-melody-density player cntrst-plyr cntrst-melody-char)
                         (select-melody-note-durs player cntrst-plyr cntrst-melody-char)
                         (select-melody-range player cntrst-plyr cntrst-melody-char)
                         (select-melody-pitch-smoothness player)
                         (select-melody-vol-smoothness player)
                         )
            )))
    )
  )

(defn- get-loud-event-prob
  [note-time]
  (let [time-diff (- note-time @loud-player-time)
        rest-prob (- 1 (* time-diff 0.00001))
        ]
    (if (<= rest-prob 0)
      (do
        (print-msg "get-loud-event-prob" "***** LOUD EVENT DONE  LOUD EVENT DONE  LOUD EVENT DONE  LOUD EVENT DONE *****")
        (reset! loud-player nil)
        (reset! loud-player-time nil)
        0
        )
      rest-prob
      )
    )
  )

(defn- loud-rest?
  "Should player rest because of loud interrupt
   Returns true for rest false to not rest

   player - player checking if it should rest
   note-time - the time (in millis) that the player is supposed to play"
  [player note-time]
  (let [loud-event-prob (if (or (nil? @loud-player) (= @loud-player (get-player-id player)))
                          0
                          (get-loud-event-prob note-time))]
    (if (> loud-event-prob (rand)) true false)
   )
  )

(defn note-or-rest?
  "Determines whether to play a note or rest.
   Returne true for note, false for rest

   player - the player to determine note or rest for"
  [player note-time]
  (if (loud-rest? player note-time) false     ;; rest because of loud interruption
      (let [play-note-prob (rand-int 10)
            density-trend (get-density-trend)
            player-density (get-melody-char-density (get-melody-char player))
            adjusted-density-char (cond
                                   (= (get-behavior-action (get-behavior player)) SIMILAR-ENSEMBLE)
                                   (cond (= density-trend INCREASING) (min (inc player-density) 9)
                                         (= density-trend DECREASING) (max (dec player-density) 0)
                                         :else player-density
                                         )
                                   (= (get-behavior-action (get-behavior player)) CONTRAST-ENSEMBLE)
                                   (cond (= density-trend INCREASING) (max (dec player-density) 0)
                                         (= density-trend DECREASING) (min (inc player-density) 9)
                                         :else player-density
                                         )
                            :else player-density)
            ]
        (if (> player-density play-note-prob)
          true
          (if (not= 9 play-note-prob)                          ;; if play-note-prob not 9
            false                                                ;; rest
            (if (and                                           ;; else
                 (not= {} (get-melody player))                   ;; if melody not empty
                 (= 0                                            ;; and last pitch is root
                    (get-scale-degree
                     player
                     (or (get-last-melody-note player) 0)))      ;; or rest
                 (< (rand) 0.8))                                 ;; possibly rest
              false
              true)))
        )
      )
  )

(defn get-melody-event
  [player-id melody-event-no]
  (get (get-melody (get-player-map player-id)) melody-event-no))

(defn- compute-sync-time
  "Returns the time of a downbeat. The time returned completes any fractional
   part of the current beat and adds 1.  So, if the current beat is 1.5, this
   function will return the time for beat 3

   mm - the mm for beat
   beat - the beat to be measured
   time - the time beat occured beat"
  [mm beat time]
  (let [fractional-beat (if (not= (int beat) beat)
                          (- 1 (- beat (int beat)))
                          0)]
    (+ time (note-dur-to-millis mm (+ 1 fractional-beat)))
    )
  )

(defn- sync-beat-follow
  [player follow-player event-time]
  (let [follow-player-mm (get-mm follow-player)
        follow-player-beat (get-cur-note-beat follow-player)
        follow-player-time (get-cur-note-time follow-player)
        follow-player-last-melody-event (get-last-melody-event follow-player)
        last-seg-num (get-seg-num-for-event follow-player-last-melody-event)
        new-dur-info (if (or (= follow-player-beat nil) (= follow-player-beat 0))
                       ;; current info for FOLLOW player is for next segment
                       ;;  which means FOLLOW player is either syncing (nil) or resting before starting segment
                       ;;  so, sync time = cur-note-beat time + 1 beat
                       (do
                         ;; use if below in case this is the first note and follow-player has not played a note yet
                         (get-dur-info-for-mm-and-millis follow-player-mm
                                                         (+ (if (> follow-player-time 0)
                                                              (- follow-player-time event-time)
                                                              0)
                                                            (note-dur-to-millis follow-player-mm 1)))
                         )
                       (do
                         (get-dur-info-for-mm-and-millis
                          (get-mm player)
                          (- (compute-sync-time follow-player-mm follow-player-beat follow-player-time) event-time))
                         )
                       )
        ]
    (create-melody-event
     :note nil
     :change-follow-info-note nil
     :dur-info new-dur-info
     :follow-note 0
     :follow-player-id (get-player-id follow-player)
     :instrument-info (get-instrument-info follow-player)
     :note-event-time event-time
     :player-id (get-player-id player)
     :seg-num (get-seg-num player)
     :volume 0
     )
    )
  )

(defn next-melody-follow
  [player event-time sync-beat-player-id]
  (let [follow-player-id (get-behavior-player-id (get-behavior player))
        follow-player (get-player-map follow-player-id)
        follow-player-last-event-num (get-last-melody-event-num-for-player follow-player)
        last-follow-event-num (get-follow-note-for-event (get-last-melody-event player))
        player-seg-num (get-seg-num player)
        ]
    (cond
     (not (nil? sync-beat-player-id))
     (sync-beat-follow player follow-player event-time)
     (or (= 0 last-follow-event-num)
         (not= player-seg-num (get-seg-num-for-event (get-last-melody-event player)))
         )
      ;; first time or new segment, rest 3 beats
      (do
        (create-melody-event
         :note nil
         :change-follow-info-note (get-next-change-follow-info-note player)
         :dur-info (get-dur-info-for-beats follow-player 3)
         :follow-note (if (nil? follow-player-last-event-num)
                        0
                        (dec follow-player-last-event-num))
         :follow-player-id follow-player-id
         ;; if follow-player has not played a note yet, get follow-player instrument-info
         ;; otherwise get instrument-info from last follow-player-event
         :instrument-info (if (nil? follow-player-last-event-num)
                            (get-instrument-info (get-player-map follow-player-id))
                            (get-instrument-info-for-event
                             (get-melody-event follow-player-id follow-player-last-event-num)))
         :note-event-time event-time
         :player-id (get-player-id player)
         :seg-num player-seg-num
         :volume 0  ;; 0 volume for rest
         ))
      :else
      ;; play FOLLOWer melody event after last-melody event
      ;; if FOLLOWing player has exceeded the length of it's melody buffer,
      ;; just play the oldest melody event that exists
      (let [
            event-num-to-play (max (inc last-follow-event-num) (inc (- follow-player-last-event-num SAVED-MELODY-LEN)))
            next-melody-event (get-melody-event follow-player-id event-num-to-play)
            ]
        (if (nil? next-melody-event)
          ;; unless
          ;; FOLLOWer ahead of FOLLOWed
          ;; then throw exception - should never happen
          (do
            (binding [*out* *err*]
                     (println "*************** FOLLOWER AHEAD OF FOLLOWED ***************")
                     (print-player player)
                     (print-player-num follow-player-id)
                     (dotimes [i 7]
                       (println "*************** END FOLLOWER AHEAD OF FOLLOWED END ***************"))
                     )
            (throw (Throwable. "FOLLOWER AHEAD OF FOLLOWED"))
            )
          (assoc next-melody-event
            :change-follow-info-note (get-next-change-follow-info-note player)
            :follow-note event-num-to-play
            :follow-player-id follow-player-id
            :note-event-time event-time
            :player-id (get-player-id player)
            :seg-num player-seg-num))
        )))
  )

(defn- next-melody-for-player
  [player event-time sync-beat-player-id new-seg?]

  (if sync-beat-player-id
    (sync-beat-follow player (get-player-map sync-beat-player-id) event-time)
    (let [next-note-or-rest (if (note-or-rest? player event-time) (next-pitch player) nil)]
      (create-melody-event
       :note next-note-or-rest
       :change-follow-info-note nil
       :dur-info (next-note-dur player next-note-or-rest)
       :follow-note nil
       :follow-player-id nil
       :instrument-info (get-instrument-info player)
       :note-event-time event-time
       :player-id (get-player-id player)
       :seg-num (get-seg-num player)
       :volume (select-volume-for-next-note player new-seg? event-time next-note-or-rest)
       )))
  )

(defn next-melody
  "Returns the next note information as a map for player

    player - the player map"
  [player event-time sync-beat-player-id new-seg?]
  (if (nil? player) (print-msg "next-melody" "PLAYER IS NIL!!!!!!!!"))
  (cond
   (= (get-behavior-action (get-behavior player)) FOLLOW-PLAYER) (next-melody-follow player event-time
                                                                                     sync-beat-player-id)
   ;; else pick next melody note based only on players settings
   ;;  do not reference other players or ensemble
   :else (next-melody-for-player player event-time sync-beat-player-id new-seg?))
  )
