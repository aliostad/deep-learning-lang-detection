;    Copyright (C) 2014-2015  Joseph Fosco. All Rights Reserved
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

(ns transport.melodyevent)

(defrecord MelodyEvent [note dur-info change-follow-info-note follow-note follow-player-id instrument-info note-event-time note-play-time player-id sc-instrument-id seg-num volume])

(defn create-melody-event
  "Used to create a MelodyEvent before the supercollider instrument id is known or instrument-plays a note"
  [& {:keys [note dur-info change-follow-info-note follow-note follow-player-id instrument-info note-event-time player-id seg-num volume]}]
  (MelodyEvent. note
                dur-info
                change-follow-info-note
                follow-note
                follow-player-id
                instrument-info
                note-event-time
                nil
                player-id
                nil
                seg-num
                volume
                )
  )

(defn get-change-follow-info-note-for-event
  [melody-event]
  (:change-follow-info-note melody-event))

(defn get-dur-info-for-event
  [melody-event]
  (:dur-info melody-event))

(defn get-follow-note-for-event
  [melody-event]
  (:follow-note melody-event))

(defn get-instrument-info-for-event
  [melody-event]
  (:instrument-info melody-event))

(defn get-note-for-event
  [melody-event]
  (:note melody-event))

(defn get-note-play-time-for-event
  [melody-event]
  (:note-play-time melody-event))

(defn get-note-event-time-for-event
  [melody-event]
  (:note-event-time melody-event))

(defn get-player-id-for-event
  [melody-event]
  (:player-id melody-event))

(defn get-seg-num-for-event
  [melody-event]
  (:seg-num melody-event))

(defn get-sc-instrument-id
  [melody-event]
  (:sc-instrument-id melody-event))

(defn get-volume-for-event
  [melody-event]
  (:volume melody-event))

(defn set-note-play-time-for-event
  [melody-event note-play-time]
  (assoc melody-event :note-play-time note-play-time))

(defn set-sc-instrument-id-and-note-play-time
  [melody-event sc-instrument-id note-play-time]
  (assoc melody-event :sc-instrument-id sc-instrument-id
                      :note-play-time note-play-time))
