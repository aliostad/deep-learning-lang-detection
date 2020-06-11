;    Copyright (C) 2016  Joseph Fosco. All Rights Reserved
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

(ns synthtst.core
  (:gen-class)
  (:require
   [overtone.live :refer :all]
   [synthtst.fmnt-synth :refer :all])
  )

(defn note->hz [music-note]
  (midi->hz music-note))

(definst triangle-wave [freq 440 attack 0.01 sustain 0.1 release 0.4 vol 0.4]
  (* (env-gen (asr attack sustain release) 1 1 0 1 FREE)
     (lf-tri freq)
     vol))

(defn play-instrument [instrument music-note]
  (instrument (midi->hz music-note)))

(def my-inst triangle-wave)

(definst tri-wave3 [freq 440 attack 0.01 sustain 0.3 release 0.4 vol 0.4
                    ]
  (let [env-impulse (impulse 1)
        env-ff (toggle-ff env-impulse)
        env-gate (gate env-ff env-impulse)
        ]
    (* (env-gen (asr attack sustain release) env-gate 1 0 1 )
       (lf-tri freq)
       vol)))

(defn play-tri3 [ music-note]
  (tri-wave3 (midi->hz music-note)))


(def all-instruments [
                      (definst tri-wave4 [freq 440 gate-dur 1 attack 0.01 sustain 0.3 release 0.4 vol 0.4]
                        (let [env-gate (trig 1 gate-dur)
                              ]
                          (* (env-gen (asr attack sustain release) env-gate 1 0 1 FREE)
                             (lf-tri freq)
                             vol)))
                      ])

(defn play-instrument [music-note]
  ( (nth all-instruments 0) (midi->hz music-note))
  )

(defn play-tri4 [ music-note dur atck]
  (tri-wave4 (midi->hz music-note) dur 0.01 0.3 atck))

(def an-instrument
  (definst tri-wave4 [freq 440 gate-dur 1 attack 0.01 sustain 0.3 release 0.4 vol 0.4]
    (let [env-gate (trig 1 gate-dur)
          ]
      (* (env-gen (asr attack sustain release) env-gate 1 0 1 FREE)
         (lf-tri freq)
         vol))))

(def s-triwave4   (definst tri-wave4 [freq 440 gate-dur 1 attack 0.01 sustain 0.3 release 0.4 vol 0.4]
    (let [env-gate (trig 1 gate-dur)
          ]
      (* (env-gen (asr attack sustain release) env-gate 1 0 1 FREE)
         (lf-tri freq)
         vol))))

(def all-inst-v [s-triwave4])

(defn play-vinst [music-note]
  ( (nth all-inst-v 0) (midi->hz music-note)))

(definst tri-wav5 [freq 440 gate-dur 1 attack 0.01 sustain 0.3 release 0.4 vol 0.4]
  (let [env-gate (trig 1 gate-dur)
        ]
    (* (env-gen (asr attack sustain release) env-gate 1 0 1 FREE)
       (lf-tri freq))))

(def all-inst-s [tri-wav5])

(defn play-sinst [music-note]
  ( (nth all-inst-s 0) (midi->hz music-note)))

(definst saw-wave-sus
  [freq 440 gate-dur 0.8 attack 0.01 sustain 0.3 release 0.1 vol 0.4]
  (let [env-gate (trig 1 gate-dur)
        ]
    (* (env-gen (asr attack sustain release) env-gate 1 0 1 FREE)
       (lf-saw freq))))

(definst square-wave-sus
  [freq 440 gate-dur 0.8 attack 0.01 sustain 0.3 release 0.1 vol 0.4]
  (let [env-gate (trig 1 gate-dur)
        ]
    (* (env-gen (asr attack sustain release) env-gate 1 0 1 FREE)
       (lf-pulse freq 0.0 0.3))))

(definst sine-wave-sus
  [freq 440 gate-dur 0.8 attack 0.01 sustain 0.3 release 0.1 vol 0.4]
  (let [env-gate (trig 1 gate-dur)
        ]
    (* (env-gen (asr attack sustain release) env-gate 1 0 1 FREE)
       (sin-osc freq))))
