;    Copyright (C) 2013-2014  Joseph Fosco. All Rights Reserved
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

(ns transport.test-info
  (:require
   [overtone.live :refer :all]
   [transport.behavior :refer :all]
   [transport.ensemble :refer [play-melody]]
   [transport.instruments.osc-instruments :refer :all]
   [transport.message-processor :refer [restart-message-processor start-message-processor]]
   [transport.players :refer :all]
   [transport.random :refer [random-int]]
   [transport.rhythm :refer [select-metronome]]
   [transport.schedule :refer [sched-event restart-scheduler start-scheduler]]
   [transport.settings :refer :all]
   [overtone.live :refer [metronome]]
   )
  (:import transport.behavior.Behavior)
  )

(def tst-player {:key 3 :scale [0 2 4 5 7 9 11] :instrument-info {:range-hi 90 :range-lo 62} :melody [{:note 70} { :note 72} {:note 74}] :melody-char {:smoothness 0} :mm 60  :behavior (Behavior. 0.5 FOLLOW-PLAYER IGNORE 2)})

(defn lstnr [& {:keys [old new]}] (println "lstnr: " old new))

(def all-instruments [
                      {:instrument tri-wave-sus :envelope-type "ASR"}
                      {:instrument saw-wave-sus :envelope-type "ASR"}
                      {:instrument sine-wave-sus :envelope-type "ASR"}
                      ])

(defn select-range
  []
  (let [lo (random-int (first MIDI-RANGE) (last MIDI-RANGE))
        hi (if (= lo (last MIDI-RANGE)) (last MIDI-RANGE) (random-int lo (last MIDI-RANGE)))]
    (list lo hi)
    ))

(defn select-instrument
  []
  (let [inst-range (select-range)
        inst-info (nth all-instruments (random-int 0 (- (count all-instruments) 1)))
        ]
    {:instrument (:instrument inst-info)
     :envelope-type (:envelope-type inst-info)
     :range-hi (last inst-range)
     :range-lo (first inst-range)}
    ))

(defn test-loop
  []
  (let [tst-players
        {
         1
         {
          :behavior (Behavior. 0.2966165302092916, 3, 0, 3)
          :cur-note-beat 0
          :function  transport.ensemble/play-melody
          :instrument-info (select-instrument)
          :key 0
          :melody {}
          :melody-char {:continuity 9, :density 4, :range 2, :smoothness 0}
          :metronome (metronome 64)
          :mm 64
          :player-id 1
          :prev-note-beat 0
          :scale [0 2 4 5 7 9 11]
          :seg-len 19726
          :seg-start 0
          }

         2
         {
          :behavior (Behavior. 0.4798252752058973, 3, 0, 1)
          :cur-note-beat 0
          :function transport.ensemble/play-melody
          :instrument-info(select-instrument)
          :key 8
          :melody {}
          :melody-char {:continuity 1, :density 7, :range 2, :smoothness 6}
          :metronome (metronome 94)
          :mm 94
          :player-id 2
          :prev-note-beat 0
          :scale [0 2 4 5 7 9 11]
          :seg-len 10565
          :seg-start 0
          }

         3
         {
          :behavior (Behavior. 0.7334685676866797, 3, 0, 2)
          :cur-note-beat 0
          :function transport.ensemble/play-melody
          :instrument-info (select-instrument)
          :key 0
          :melody {}
          :melody-char {:continuity 9, :density 7, :range 4, :smoothness 5}
          :metronome (metronome 115)
          :mm 115
          :player-id 3
          :prev-note-beat 0
          :scale [0 2 4 5 7 9 11]
          :seg-len 16310
          :seg-start 0
          }
         }]

    (restart-message-processor :reset-listeners true)
    (restart-scheduler)

    (reset-players)
    (send PLAYERS conj tst-players)
    (await PLAYERS)

    (dorun (map sched-event (repeat 0) (map get-function (get-players)) (map get-player-id (get-players))))
    (start-scheduler)
    (start-message-processor)


    )


  )
