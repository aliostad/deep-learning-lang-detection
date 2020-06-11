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

(ns transit.player.structures.motif
  (:require
   [transit.player.structures.base-structure :refer [create-base-structure
                                                     get-base-strength
                                                     ]]
   )
  )

(defrecord Motif [base
                  strength-fn
                  melody-fn
                  melody-event-ids
                  type  ;; FREE or METERED (METERED has mm and rhythmic values)
                  complete? ;; is this a complete motif
                  ])

(defn create-motif
  [& {:keys [melody-event-ids type complete?]} :or
   {melody-event-ids nil complete? false}]
  (Motif. (create-base-structure)
          get-strength
          get-melody-event
          melody-event-ids
          type
          complete?
          )
  )

(defn get-strength
  [motif]
  (get-base-strength (:base motif))
  )

(defn get-melody-event
  [player motif next-id]
  (create-melody-event
   :id next-id
   :note 60
   :dur-info (DurInfo. 500 nil)
   :volume 0.7
   :instrument-info (:instrument-info player)
   :player-id player-id
   :event-time nil
   )

  )
