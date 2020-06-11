;    Copyright (C) 2017  Joseph Fosco. All Rights Reserved
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

(ns transit.player.player-play-note
  (:require
   [overtone.live :refer [apply-at ctl midi->hz]]
   [transit.instr.instrumentinfo :refer [get-release-millis-from-instrument-info
                                         get-instrument-from-instrument-info]]
   [transit.instr.sc-instrument :refer [stop-instrument]]
   [transit.config.config :refer [get-setting]]
   [transit.ensemble.ensemble :refer [get-ensemble
                                      get-melody
                                      get-player
                                      update-player-and-melody]]
   [transit.melody.dur-info :refer [get-dur-millis-from-dur-info]]
   [transit.melody.melody-event :refer [get-dur-info-from-melody-event
                                        get-dur-millis-from-melody-event
                                        get-event-time-from-melody-event
                                        get-instrument-info-from-melody-event
                                        get-note-from-melody-event
                                        get-note-off-from-melody-event
                                        get-player-id-from-melody-event
                                        get-sc-instrument-id-from-melody-event
                                        get-volume-from-melody-event
                                        set-play-info]]
   [transit.player.player :refer [get-next-melody-event]]
   [transit.player.player-methods :refer [NEW-MELODY NEXT-METHOD]]
   [transit.util.random :refer [weighted-choice]]
   [transit.util.util :refer [remove-element-from-vector]]
   )
  )

(def METHOD-PROCESS-MILLIS 12)

(defn get-player-method
  [player ndx]
  (:method ((:methods player) ndx))
  )

(defn is-playing?
 "Returns:
   true - if player is playing now
   false - if player is not playing now
 "
 [player]
  )

(defn select-method
  " Returns the ndx into player-methods of the method to run "
  [player]
  (weighted-choice (mapv :weight (:methods player)))
  )

(defn run-player-method
  " Selects and executes one of the player :methods
    Returns player after executing method with the selected
      method removed from :methods
  "
  [[ensemble player melody player-id :as method_context]]
  (let [method-ndx (select-method player)]
    ;; remove the method that will be run from player :methods
    ((get-player-method player method-ndx)
     [ensemble
      (assoc player
             :methods (remove-element-from-vector (:methods player)  method-ndx))
      melody
      player-id
      ])
     )
  )

(defn check-prior-event-note-off
   " if the prior note was not turned off and
       either this note is a rest or
         this note has a different instrument than the prior note
     then
       turn off the prior note"
  [prior-melody-event cur-melody-event]
  (when (and (false? (get-note-off-from-melody-event prior-melody-event))
             (or (not (nil? (get-note-from-melody-event cur-melody-event)))
                 (not=
                  (get-sc-instrument-id-from-melody-event prior-melody-event)
                  (get-sc-instrument-id-from-melody-event cur-melody-event)
                  )
                 )
             )
    (stop-instrument (get-sc-instrument-id-from-melody-event prior-melody-event))
    )
  )

(defn stop-running-methods?
  [event-time [ens player melody player-id rtn-map]]
  (or (= 0 (count (:methods player)))
      (>= (System/currentTimeMillis) (- event-time 10))
      )
  )

(defn play-note-prior-instrument
  [prior-melody-event melody-event]
  (let [inst-id (get-sc-instrument-id-from-melody-event prior-melody-event)]
    (ctl inst-id
         :freq (midi->hz (get-note-from-melody-event melody-event))
         :vol (* (get-volume-from-melody-event melody-event)
                 (get-setting :volume-adjust))
         )
    inst-id
    )
  )

(defn play-note-new-instrument
  [melody-event]
  ((get-instrument-from-instrument-info
    (get-instrument-info-from-melody-event melody-event))
   (midi->hz (get-note-from-melody-event melody-event))
   (* (get-volume-from-melody-event melody-event) (get-setting :volume-adjust)))
  )

(declare play-next-note)
(defn sched-next-note
  [melody-event]
  (let [next-time (- (+ (get-event-time-from-melody-event melody-event)
                        (get-dur-millis-from-melody-event melody-event)
                        ) METHOD-PROCESS-MILLIS)]
    (apply-at next-time
              play-next-note
              [(get-player-id-from-melody-event melody-event) next-time]
     ))
  )

(defn play-melody-event
  [prior-melody-event melody-event event-time]
  (let [cur-inst-id
        (cond (nil? (get-note-from-melody-event melody-event))
              nil
              (not (false? (get-note-off-from-melody-event prior-melody-event)))
              (play-note-new-instrument melody-event)
              :else
              (play-note-prior-instrument prior-melody-event melody-event)
              )
        full-melody-event (set-play-info melody-event
                                         cur-inst-id
                                         event-time
                                         (System/currentTimeMillis)
                                         )

        ]
    ;; schedule note-off for melody-event
    (when (get-note-off-from-melody-event full-melody-event)
      (apply-at (+ event-time
                   (- (get-dur-millis-from-dur-info
                       (get-dur-info-from-melody-event melody-event))
                      (get-release-millis-from-instrument-info
                       (get-instrument-info-from-melody-event melody-event))
                      ))
                stop-instrument
                [cur-inst-id]
                )
      )
    full-melody-event
    )
  )

(defn play-next-note
  [player-id sched-time]
  (let [event-time (+ sched-time METHOD-PROCESS-MILLIS)
        ensemble (get-ensemble)
        player (get-player ensemble player-id)
        melody (get-melody ensemble player-id)
        method-context [ensemble player melody player-id {:status NEXT-METHOD}]
        [_ new-player melody player-id rtn-map]
        (first (filter (partial stop-running-methods? event-time)
                       (iterate run-player-method method-context)))
        next-melody-event (play-melody-event (last melody)
                                             (get-next-melody-event
                                              new-player
                                              melody
                                              player-id)
                                             event-time)
        upd-melody (assoc melody (count melody) next-melody-event)
        ]
    (check-prior-event-note-off (last melody) next-melody-event)
    (sched-next-note next-melody-event)
    (update-player-and-melody new-player upd-melody player-id)
    (println (- (System/currentTimeMillis) event-time))
    )
 )
