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

;; This fle defines an vector tst-players with 2 players (0 and 1).
;; To be used for testing.
;; Change the ns to the appropriate namespace

(ns transport.melody
  (:require
   [overtone.live :refer [metronome]]
   [transport.behavior :refer :all]
   [transport.instrument :refer [select-random-instrument]]
   [transport.melodychar :refer :all]
   )
  (:import
   transport.melodychar.MelodyChar
   transport.behavior.Behavior
   )
  )

(def tst-players
  {
   0
   {
    :behavior (Behavior. 0.2966165302092916, 3, 0, 1)
    :change-follow-info-note 0
    :cur-note-beat 0
    :function  transport.ensemble/play-melody
    :instrument-info (select-random-instrument)
    :key 0
    :melody {}
    :melody-char (MelodyChar. 9, 4, 2, 0)
    :metronome (metronome 64)
    :mm 64
    :player-id 0
    :prev-note-beat 0
    :scale :ionian
    :seg-len 19726
    :seg-start 0
    }
   1
   {
    :behavior (Behavior. 0.4798252752058973, 0, 0, nil)
    :change-follow-info-note nil
    :cur-note-beat 0
    :function transport.ensemble/play-melody
    :instrument-info(select-random-instrument)
    :key 8
    :melody {}
    :melody-char (MelodyChar. 1, 7, 2, 6)
    :metronome (metronome 94)
    :mm 94
    :player-id 1
    :prev-note-beat 0
    :scale :hindu
    :seg-len 10565
    :seg-start 0
    }
   }

)
