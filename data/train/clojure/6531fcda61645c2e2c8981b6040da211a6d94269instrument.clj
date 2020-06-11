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

(ns transport.instrument
  (:require
   [overtone.live :refer :all]
   [transport.behavior :refer [get-behavior-action]]
   [transport.constants :refer :all]
   [transport.ensemble-status :refer [get-ensemble-average-pitch get-pitch-trend]]
   [transport.instrumentinfo :refer :all]
   [transport.instruments.elec-instruments :refer :all]
   [transport.instruments.misc-instruments :refer :all]
   [transport.instruments.osc-instruments :refer :all]
   [transport.instruments.pitched-perc-instruments :refer :all]
   [transport.instruments.trad-instruments :refer :all]
   [transport.melodychar :refer [get-melody-char-note-durs]]
   [transport.melodyevent :refer [get-sc-instrument-id]]
   [transport.players :refer :all]
   [transport.random :refer [random-int]]
   [transport.util.util-constants :refer [DECREASING INCREASING]]
   [transport.util.utils :refer [nil-to-num print-msg]]
   ))

(def LO-RANGE 47)
(def MID-RANGE 79)
(def HI-RANGE (last MIDI-RANGE))

(def perc-env (sorted-set "AD" "NE"))
(def non-perc-env (sorted-set "ADSR" "ASR"))

(def all-instruments [
                        {:instrument bass-m1
                         :envelope-type "NE"
                         :range-lo 25
                         :range-hi 60}
                        {:instrument bassoon
                         :envelope-type "ASR"
                         :range-lo 25
                         :range-hi 84
                         :release-dur 0.1}
                        {:instrument clarinet
                         :envelope-type "ASR"
                         :range-lo 20
                         :range-hi 100
                         :release-dur 0.1}
                        {:instrument drum-m1
                         :envelope-type "AD"
                         :range-lo 50
                         :range-hi 90}
                        {:instrument organ-m1
                         :envelope-type "ADSR"
                         :range-lo 40
                         :range-hi (last MIDI-RANGE)
                         :release-dur 0.3}
                        {:instrument plink-m1
                         :envelope-type "AD"
                         :range-lo 33
                         :range-hi (last MIDI-RANGE)}
                        {:instrument reedy-organ
                         :envelope-type "ASR"
                         :range-lo 20
                         :range-hi (last MIDI-RANGE)
                         :release-dur 0.1}
                        {:instrument saw-wave-sus
                         :envelope-type "ASR"
                         :range-lo 25
                         :range-hi (last MIDI-RANGE)
                         :release-dur 0.1}
                        {:instrument sine-wave-sus
                         :envelope-type "ASR"
                         :range-lo (first MIDI-RANGE)
                         :range-hi (last MIDI-RANGE)
                         :release-dur 0.1}
                        {:instrument steel-drum
                         :envelope-type "AD"
                         :range-lo 45
                         :range-hi (last MIDI-RANGE)}
                        {:instrument tri-wave-sus
                         :envelope-type "ASR"
                         :range-lo 15
                         :range-hi (last MIDI-RANGE)
                         :release-dur 0.1}
                        ])

(defn non-perc-instruments
  [instrument-list]
  (filter #(not (contains? perc-env (:envelope-type %1))) instrument-list)
  )

(defn note->hz
  [music-note]
  (midi->hz music-note))

(defn get-instrument-range-hi
  [instrument-info]
  (:range-hi instrument-info))

(defn get-instrument-range-lo
  [instrument-info]
  (:range-lo instrument-info))

(defn get-gate-dur
  "player - player map
   note-duration - note duration in milliseconds"
  [player note-duration]
  (if (> note-duration 110)
    (/ (- note-duration 110) 1000.0) ; currently assumes an attack of .01 secs and decay of .1 secs
    0.001))

(defn select-random-instrument
  "Selects random instrument-info for player.
   Can be used the first time instrument-info is set."
  []
  (let [inst-info (rand-nth all-instruments)
        ]
    (create-instrument-info
     :instrument (get-instrument-for-inst-info inst-info)
     :envelope-type (get-envelope-type-for-inst-info inst-info)
     :release-dur (get-release-dur-for-inst-info inst-info)
     :range-hi (get-range-hi-for-inst-info inst-info)
     :range-lo (get-range-lo-for-inst-info inst-info))
    ))

(defn- get-inst-list-for-melody-char
  [melody-char]
  (if (nil? melody-char)
    all-instruments
    (if (> (get-melody-char-note-durs melody-char) 5)
      (non-perc-instruments all-instruments)
      all-instruments
      ))
  )

(defn- filter-inst-list-by-range
  [player inst-list]
  (let [behavior-action (get-behavior-action (get-behavior player))]
    (cond (= behavior-action SIMILAR-ENSEMBLE)
          (let [pitch-trend (get-pitch-trend)]
            (cond (= pitch-trend INCREASING)
                  (filter #(> (:range-hi %1) (nil-to-num (get-ensemble-average-pitch) MIDI-LO)) inst-list)
                  (= pitch-trend DECREASING)
                  (filter #(< (:range-lo %1) (nil-to-num (get-ensemble-average-pitch) MIDI-HI)) inst-list)
                  :else inst-list
                  )
            )
          :else inst-list
          )
    )
  )

(defn select-instrument
  "Selects instrument-info for player.
   Generally this should not be used if player is FOLLOWing
   another player -in that case the instrument-info should be copied
   from the player that is being FOLLOWed

   player - the player to get instrument for"
  [player melody-char & {:keys [cntrst-plyr-inst-info]}]
  ;; select instrument info from insrument-list map (selected based on melody-char)
  ;; if not CONTRASTing, select a random instrument
  ;; if CONTRASTing select an instrument other than the one CONTRAST player is using
  (let [instrument-list (if (nil? melody-char)
                          (get-inst-list-for-melody-char nil)
                          (->> melody-char (get-inst-list-for-melody-char)
                              (filter-inst-list-by-range player)
                              ))
        inst-info (if (nil? cntrst-plyr-inst-info)
                    (if (empty? instrument-list)
                      (do
                        (print-msg "select-instrument" "*** INSTRUMENT LIST EMPTY *************************")
                        (rand-nth all-instruments)
                        )
                      (rand-nth instrument-list)
                      )
                    (let [instrument-index (rand-int (count instrument-list))]
                      (if (=
                           (:name (:instrument cntrst-plyr-inst-info))
                           (:name (:instrument (nth instrument-list instrument-index))))
                        (nth instrument-list (mod (inc instrument-index) (count instrument-list)))
                        (nth instrument-list instrument-index)
                        )
                      )
                    )
        ]

    (create-instrument-info
     :instrument (get-instrument-for-inst-info inst-info)
     :envelope-type (get-envelope-type-for-inst-info inst-info)
     :release-dur (get-release-dur-for-inst-info inst-info)
     :range-hi (get-range-hi-for-inst-info inst-info)
     :range-lo (get-range-lo-for-inst-info inst-info)
     )
    )
  )

(defn has-release?
  [inst-info]
  (if (contains? non-perc-env (:envelope-type inst-info))
    true
    false)
  )

(defn play-instrument
  ""
  [instrument]
  (ctl instrument :gate 1 :action FREE)
  )
