;    Copyright (C) 2013-2017  Joseph Fosco. All Rights Reserved
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

(ns transit.instr.instrument
  (:require
   [overtone.live :refer :all]
   ;; [transit.constants :refer :all]
;;   [transit.ensemble.player :refer [get-player-id]]
   [transit.instr.instrumentinfo :refer [create-instrument-info
                                         get-instrument-from-instrument-info
                                         get-envelope-type-from-instrument-info
                                         get-range-hi-from-instrument-info
                                         get-range-lo-from-instrument-info
                                         get-release-dur-from-instrument-info
                                         ]]
   [transit.instr.instruments.elec-instruments :refer :all]
   [transit.instr.instruments.misc-instruments :refer :all]
   [transit.instr.instruments.osc-instruments :refer :all]
   [transit.instr.instruments.pitched-perc-instruments :refer :all]
   [transit.instr.instruments.trad-instruments :refer :all]
   [transit.util.log :as log]
   [transit.util.print :refer [print-msg]]
   )
  )

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
                        {:instrument pluck-string
                         :envelope-type "NE"
                         :range-lo 37
                         :range-hi 89}
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

(defn get-gate-dur
  "player - player map
   note-duration - note duration in milliseconds"
  [player note-duration]
  (if (> note-duration 110)
    (/ (- note-duration 110) 1000.0) ; currently assumes an attack of .01 secs and decay of .1 secs
    0.001))

(defn select-random-instrument
  "Selects random instrument-info for player."
  []
  (let [inst-info (rand-nth all-instruments)
        ]
    (create-instrument-info
     :instrument (get-instrument-from-instrument-info inst-info)
     :envelope-type (get-envelope-type-from-instrument-info inst-info)
     :release-dur (get-release-dur-from-instrument-info inst-info)
     :range-hi (get-range-hi-from-instrument-info inst-info)
     :range-lo (get-range-lo-from-instrument-info inst-info))
    ))

(defn select-instrument
  [[ensemble player melody player-id]]
  (select-random-instrument)
  )

;; (defn select-instrument
;;   "Selects instrument-info for player.

;;    player - the player to get instrument for"
;;   [player]
;;   (let [instrument-list all-instruments
;;         inst-info (if (empty? instrument-list)
;;                     (do
;;                       (log/warn (log/format-msg "select-instrument" "*** INSTRUMENT LIST EMPTY *************************"))
;;                       (log/warn (log/format-msg "select-instrument"
;;                                                 "player-id: "
;;                                                 (get-player-id player)
;;                                                 ))
;;                       (rand-nth all-instruments)
;;                       )
;;                     (rand-nth instrument-list)
;;                     )
;;         ]

;;     (create-instrument-info
;;      :instrument (get-instrument-for-inst-info inst-info)
;;      :envelope-type (get-envelope-type-for-inst-info inst-info)
;;      :release-dur (get-release-dur-for-inst-info inst-info)
;;      :range-hi (get-range-hi-for-inst-info inst-info)
;;      :range-lo (get-range-lo-for-inst-info inst-info)
;;      )
;;     )
;;   )

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

(defn get-instrument-info-for-name
  [instrument-name]
  (first (filter #(= (:name (:instrument %1)) instrument-name) all-instruments))
  )
