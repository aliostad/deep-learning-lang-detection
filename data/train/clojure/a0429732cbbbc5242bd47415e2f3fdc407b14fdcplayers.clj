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

(ns transport.players
  (:require
   [transport.behavior :refer [get-behavior-action get-behavior-player-id set-behavior-player-id]]
   [transport.constants :refer :all]
   [transport.instrumentinfo :refer [get-all-instrument-info get-range-hi-for-inst-info get-range-lo-for-inst-info]]
   [transport.melodychar :refer [get-melody-char-density get-melody-char-range-hi get-melody-char-range-lo
                                 set-melody-char-density set-melody-char-note-durs]]
   [transport.melodyevent :refer [get-follow-note-for-event get-instrument-info-for-event get-sc-instrument-id
                                  get-volume-for-event]]
   [transport.message-processor :refer [send-message register-listener]]
   [transport.messages :refer :all]
   [transport.settings :refer :all]
   [transport.util.utils :refer :all]
   )
  (:import transport.behavior.Behavior)
  )

(def ensemble (atom {}))
(def player-melodies (atom {}))

(defn get-ensemble
  []
  (map deref (vals @ensemble)))

(defn get-player-map
  [player-id]
  (deref (get @ensemble player-id)))

(declare get-player-id)
(defn get-melody-info-for-player
  [player]
  (deref (get @player-melodies (get-player-id player)))
  )

(defn get-melody-info-for-player-id
  [player-id]
  (get-melody-info-for-player (get-player-map player-id))
  )

(defn get-player-val
  "Returns the requested value for the specified player

   player - the player to return the value from
   val - string name of the value to return"
  [player val]
  (get player (keyword val))
  )

(defn get-behavior
  [player]
  (:behavior player))

(defn get-function
  [player]
  (:function player))

(defn get-change-follow-info-notes
  [player]
  (:change-follow-info-notes player))

(defn get-next-change-follow-info-note
  [player]
  (first (:change-follow-info-notes player)))

(defn get-change-follow-info
  [player]
  (:change-follow-info player))

(defn get-cur-note-beat
  [player]
  (:cur-note-beat (get-melody-info-for-player player)))

(defn get-cur-note-time
  [player]
  (:cur-note-time (get-melody-info-for-player player)))

(defn get-prev-note-time
  [player]
  (:prev-note-time (get-melody-info-for-player player)))

(declare get-last-melody-event)
(defn get-instrument-info
  "Returns instrument info if it is not nil else
     returns instrument info from last melody-event

   player - the player to return instrument info from"
  [player]
  (let [instrument-info (:instrument-info player)]
    (if (nil? instrument-info)
      (get-instrument-info-for-event (get-last-melody-event player))
      instrument-info
      )))

(defn get-key
  [player]
  (:key player))

(defn get-melody
  [player]
  (:melody (get-melody-info-for-player player)))

(defn get-melody-char
  [player]
  (:melody-char player))

(defn get-metronome
  [player]
  (:metronome player))

(defn get-mm
  [player]
  (:mm player))

(defn get-player
  [player-id]
  (get @ensemble player-id))

(defn get-player-id
  [player]
  (:player-id player))

(defn get-scale
  [player]
  (:scale player))

(defn get-seg-len
  [player]
  (:seg-len player))

(defn get-seg-num
  [player]
  (:seg-num player))

(defn get-seg-start
  [player]
  (:seg-start player))

(defn get-last-melody-event-num-for-player
  [player]
  (let [last-melody-key (reduce max 0 (keys (get-melody player)))]
    (if (= last-melody-key 0) nil last-melody-key)
    )
  )

(defn get-last-melody-note
  "Returns the last melody note played by player.
   Retunns nil if last note was a rest

  player - the player to get the melody note from"
  [player]
  (let [cur-melody (get-melody player)]
    (if (= cur-melody {})
      nil
      (:note (get cur-melody (get-last-melody-event-num-for-player player)))))
  )

(defn get-last-melody-event
  [player]
  (let [player-melody (get-melody player)]
    (if (= player-melody {}) nil (get player-melody (get-last-melody-event-num-for-player player)))
    )
  )

(defn get-melody-event-num
  "Returns the players melody event for melody-event-num (a number).
   Returns nil if the key does not exist for the player."
  [player melody-event-num]
  (get (get-melody player) melody-event-num)
  )

(defn get-player-id-for-melody
  [melody]
  (:player-id melody))

(defn set-first-note
  "Called the first time a note is played for a plyer to set up
   the seg-start-time and the function

   seg-start-time - time to set :seg-start to
   function - function to be used for subsequent notes"
  [player seg-start-time function]
  (assoc player :function function :seg-start seg-start-time)
  )

(defn get-similar-info-from-player
  "follow-player - the player to get the following info from"
  [follow-player]
  {
   :key (get-key follow-player)
   :melody-char (get-melody-char follow-player)
   :metronome (get-metronome follow-player)
   :mm (get-mm follow-player)
   :scale (get-scale follow-player)
   }
  )

(defn get-following-info-from-player
  "follow-player - the player to get the following info from"
  [follow-player]
  (assoc (get-similar-info-from-player follow-player)
    :instrument-info (get-instrument-info follow-player)
    )
  )

(defn  send-msg-new-player-info
  [change-player-id originator-player-id melody-no]
  (send-message MSG-PLAYER-NEW-FOLLOW-INFO
                :change-player-id change-player-id
                :originator-player-id  originator-player-id
                :melody-no melody-no
                :follow-info (get-following-info-from-player (get-player-map change-player-id)))
  (send-message MSG-PLAYER-NEW-SIMILAR-INFO
                :change-player-id change-player-id
                :originator-player-id  originator-player-id)
  (send-message MSG-PLAYER-NEW-CONTRAST-INFO
                :change-player-id change-player-id
                :originator-player-id  originator-player-id)
  )

(defn set-melody-char
  [player new-melody-char]
  (assoc player :melody-char new-melody-char)
  )

(defn set-mm
  [player new-mm]
  (assoc player :mm new-mm)
  )

(defn set-density
  [player new-density]
  (set-melody-char player (set-melody-char-density (get-melody-char player) new-density))
  )

(defn set-note-durs
  [player new-note-durs]
  (set-melody-char player (set-melody-char-note-durs (get-melody-char player) new-note-durs))
  )

(defn- set-new-follow-info
  [player melody-no change-player-id follow-info]
  (if (= change-player-id (get-player-id (:behavior player)))
    (if (not (some #{melody-no} (get-change-follow-info-notes player)))

      (assoc player
        :change-follow-info-notes (conj (get-change-follow-info-notes player) melody-no)
        :change-follow-info (conj (get-change-follow-info player) follow-info)
        )
      ;; If melody-num already exists in change-follow-info-notes
      ;; replace melody-num's current follow-info in :change-follow-info
      ;; with the new follow-info
      (let [melody-num-index (first (keep-indexed #(if (= %2 melody-no) %1 nil) (get-change-follow-info-notes player)))]
        (print-msg "set-new-follow-info" "*********** REPLACING FOLLOW-INFO ***************")
        (print-msg "set-new-follow-info" "player-id: " (get-player-id player) " melody-no: " melody-no " change-follow-info-notes: " (get-change-follow-info-notes player))
        (print-msg "set-new-follow-info" " melody-num-index: " melody-num-index " count-info: " (count (get-change-follow-info player)))
        (assoc player
          :change-follow-info (assoc (get-change-follow-info player) melody-num-index follow-info)
          )))
    )
  )

(defn new-follow-info-for-player
  [& {:keys [change-player-id follow-player-id originator-player-id melody-no follow-info]}]
  (if (not= originator-player-id follow-player-id)
      (swap! (get-player follow-player-id) set-new-follow-info melody-no change-player-id follow-info)
    )
  )

(defn set-new-contrast-info
  [cur-contrasting-player change-player-id originator-player-id new-contrasting-info-map]
  (if (and (= change-player-id (get-player-id (:behavior cur-contrasting-player)))
           (not= originator-player-id (get-player-id cur-contrasting-player)))
    (merge cur-contrasting-player new-contrasting-info-map)
    cur-contrasting-player)
  )

(defn replace-similar-info
  [cur-to-player from-player-id originator-player-id new-similar-info]
  (let [to-player-id (get-player-id cur-to-player)]
    (if (and (= from-player-id (get-player-id (get-behavior cur-to-player)))
             (not= originator-player-id to-player-id))
      (merge cur-to-player new-similar-info)
      )
    cur-to-player)
  )

(declare print-player)
(defn update-player-follow-info
  [to-player from-player]
  (let [to-player-id (get-player-id to-player)
        from-player-id (get-behavior-player-id (get-behavior to-player))
        cur-change-follow-info-note (get-next-change-follow-info-note to-player)
        last-follow-note (get-follow-note-for-event (get-last-melody-event to-player))
        ]
    (if (and (not (nil? from-player-id))
             (not (nil? last-follow-note))
             (not (nil? cur-change-follow-info-note))
             (>= (inc last-follow-note) cur-change-follow-info-note)
             (> (count (get-change-follow-info to-player)) 0)
             (= from-player-id (get-player-id from-player))
             )
      (assoc (merge to-player
                    (get (get-change-follow-info to-player) 0)
                    )
        :change-follow-info-notes (subvec (get-change-follow-info-notes to-player) 1)
        :change-follow-info (subvec (get-change-follow-info to-player) 1)
        )
      (do
        (binding [*out* *err*]
          (print-msg "update-player-and-follow-info" "COPY FOLLOW-INFO ERROR   COPY FOLLOW-INFO ERROR   COPY FOLLOW-INFO ERROR   ")
          (print-player to-player)
          (print-player from-player)
          (print-msg "update-player-follow-info" "from-player-id:   " (get-player-id from-player))
          (print-msg "update-player-follow-info" "to-player-id:     " to-player-id)
          (print-msg "update-player-follow-info" "last-follow-note: " last-follow-note)
          (print-msg "update-player-follow-info" "cur-change-follow-info-note: " cur-change-follow-info-note)
          )
        (throw (Throwable. "COPY FOLLOW-INFO ERROR"))
        )
      )
    )
  )

(defn print-player-melody
  [melody & {:keys [prnt-full-inst-info]
             :or {prnt-full-inst-info false}}]
  (let [sorted-keys (sort (keys melody))]
    (println (format "%-20s" "  :melody "))
    (doseq [melody-key sorted-keys]
      (println (format "%-29s" (str "  " melody-key "-" (dissoc (get melody melody-key) :instrument-info))))
      (if prnt-full-inst-info
        (do
          (println (format
                    "%-29s"
                    (str "  " melody-key "-"
                         ":instrument-info:" (get-all-instrument-info (get (get melody melody-key) :instrument-info))
                         )
                    ))
          )
        (println (format
                  "%-29s"
                  (str "  " melody-key "-"
                       ":instrument-name:" (:name (:instrument (:instrument-info (get melody melody-key))))
                       " range-lo: " (:range-lo (:instrument-info (get melody melody-key)))
                       " range-hi: " (:range-hi (:instrument-info (get melody melody-key))) ))))
      )
    )
  )

(defn print-player
  "Pretty Print a player map

  player - the player map to print"
  [player & {:keys [prnt-full-inst-info]
             :or {prnt-full-inst-info false}}]
  (let [sorted-keys (sort (keys player))]
    (println "player: " (get-player-id player) "current time: " (System/currentTimeMillis))
    (doseq [player-key sorted-keys]
      (cond
       (and (= player-key :instrument-info) (= prnt-full-inst-info false))
       (do
         (println (format "%-29s" (str "  " player-key " :name")) "-" (:name (:instrument (:instrument-info player))))
         (println (format "%-29s" (str "  " player-key " :range-lo")) "-" (:range-lo (:instrument-info player)))
         (println (format "%-29s" (str "  " player-key " :range-hi")) "-" (:range-hi (:instrument-info player))))

        (= player-key :melody)
        (print-player-melody (:melody player) :prnt-full-inst-info prnt-full-inst-info)

       :else
        (println (format "%-20s" (str "  " player-key)) "-" (get player player-key)))
      )
    (println "end player: " (get-player-id player) "current time: " (System/currentTimeMillis))
    (prn)
    )
  )

(defn print-melody
  "Pretty Print a player-melodies map

  melody - the player map to print"
  [melody & {:keys [prnt-full-inst-info]
             :or {prnt-full-inst-info false}}]
  (let [sorted-keys (sort (keys melody))]
    (println "player: " (get-player-id-for-melody melody) "current time: " (System/currentTimeMillis))
    (doseq [melody-key sorted-keys]
      (cond
        (= melody-key :melody)
        (print-player-melody (:melody melody) :prnt-full-inst-info prnt-full-inst-info)

       :else
        (println (format "%-20s" (str "  " melody-key)) "-" (get melody melody-key)))
      )
    (println "end melody: " (get-player-id-for-melody melody) "current time: " (System/currentTimeMillis))
    (prn)
    )
  )

(defn print-player-long
  "Pretty Print a player map with all instrument-info

  player - the player map to print"
  [player]
  (print-player player :prnt-full-inst-info true)
  )

(defn print-player-action
  [player-atom]
  (let [plyr-action (get-behavior-action (get-behavior @player-atom))]
    (print (format "%-2s" (get-player-id @player-atom)) " - ")
    (cond (= plyr-action IGNORE-ALL) (println "IGNORE-ALL")
          (= plyr-action CONTRAST-PLAYER) (println "CONTRAST-PLAYER")
          (= plyr-action SIMILAR-PLAYER) (println "SIMILAR-PLAYER")
          (= plyr-action FOLLOW-PLAYER) (println "FOLLOW-PLAYER")
          (= plyr-action SIMILAR-ENSEMBLE) (println "SIMILAR-ENSEMBLE")
          (= plyr-action CONTRAST-ENSEMBLE) (println "CONTRAST-ENSEMBLE")
          :else
          (println "player-action:" plyr-action "*** DOES NOT MATCH ***" "behavior:" (get-behavior @player-atom))
          )
    )
  )

(defn print-player-num
  [player-id]
  (print-player (get-player-map player-id))
  )

(defn print-melody-for-player-id
  [player-id]
  (print-melody (get-melody-info-for-player-id player-id))
  )

(defn print-all-actions
  []
  (dorun
   (map print-player-action (vals @ensemble)))
  )

(defn print-player-density
  [player-atom]
  (println (format "%-2s" (get-player-id @player-atom))
           " - "
           (get-melody-char-density (get-melody-char @player-atom)))
  )

(defn print-all-densities
  []
  (dorun
   (map print-player-density (vals @ensemble)))
  )

(defn print-playing-volume
  [player-atom]
  (let [vol (get-volume-for-event (get-last-melody-event @player-atom))]
    (if (> vol 0)
      (println (format "%-2s" (get-player-id @player-atom))
               " - "
               vol
               )))
  )

(defn print-all-playing-volumes
  []
  (dorun
   (map print-playing-volume (vals @ensemble)))
  )

(defn print-all-players
  []
  (dorun (map print-player (get-ensemble)))
)


;; --------------------------------------------------------------------------------------

(defn get-player-with-mm
  "Returns player-id for the player with requested mm.
   Does not return requesting-player id.
   Returns nil if no other players match mm"
  [requesting-player mm]
  (let [requesting-player-id (get-player-id requesting-player)]
    (loop [player-id-to-check 0]
      (cond (= player-id-to-check @number-of-players)
            nil
            (and (= mm (get-mm (get-player-map player-id-to-check))) (not= player-id-to-check requesting-player-id))
            player-id-to-check
            :else (recur (inc player-id-to-check))
        )
      )
    )
  )

(defn rand-player-id-excluding-player
  "Select a random player-id not including the
   player-id of player

   player - player to exclude from possible player-ids"
  [player & {:keys [all-players]
             :or {all-players (map deref (vals @ensemble))}}]
  (if (> (count all-players) 1)
    (get-player-id (rand-nth (remove #(= % player) all-players)))
    nil
    ))

(defn select-and-set-behavior-player-id
  "If :behavior :action is not IGNORE-ALL, SIMILAR-ENSEMBLE or CONTRAST-ENSEMBLE
   returns a :behavior map with :player-id selected from map of players
   passed in as all-players.
   if :behavior is IGNORE-ALL returns the current :behavior map

   player - the player to set :behavior :player-id"
  [player & {:keys [all-players]}]
  (let [player-action (get-behavior-action (get-behavior player))]
    (if (and (not= player-action SIMILAR-ENSEMBLE)
             (not= player-action CONTRAST-ENSEMBLE)
             (not= player-action IGNORE-ALL))
      (let [player-id (rand-player-id-excluding-player player :all-players all-players)]
        (set-behavior-player-id (get-behavior player) player-id)
        )
      (get-behavior player)
      )))

(defn new-contrast-info-for-player
  [& {:keys [change-player-id contrast-player-id originator-player-id contrasting-info]}]
  (swap! (get-player contrast-player-id)
        set-new-contrast-info
        change-player-id
        originator-player-id
        contrasting-info
        )
  (if (not= change-player-id originator-player-id)
    (send-msg-new-player-info change-player-id
                              originator-player-id
                              (get-last-melody-event-num-for-player (get-player-map change-player-id)))
    )
  )

(defn new-similar-info-for-player
  [& {:keys [change-player-id follow-player-id originator-player-id similar-info]}]
  (swap! (get-player follow-player-id)
         replace-similar-info
         change-player-id
         originator-player-id
         similar-info
         )
  (if (not= change-player-id originator-player-id)
    (send-msg-new-player-info change-player-id
                              originator-player-id
                              (get-last-melody-event-num-for-player (get-player-map change-player-id)))
    )

  )

(defn adjust-melody-char-for-instrument
  [melody-char instrument-info]
  (let [new-melody-lo (if (<=
                           (get-range-lo-for-inst-info instrument-info)
                           (get-melody-char-range-lo melody-char)
                           (get-range-hi-for-inst-info instrument-info)
                           )
                        (get-melody-char-range-lo melody-char)
                        (get-range-lo-for-inst-info instrument-info)
                        )
        new-melody-hi (if (> (get-range-hi-for-inst-info instrument-info)
                             (get-melody-char-range-hi melody-char)
                             new-melody-lo
                             )
                        (get-melody-char-range-hi melody-char)
                        (get-range-hi-for-inst-info instrument-info)
                        )

        new-melody-char (assoc melody-char
                          :range (list new-melody-lo new-melody-hi))
        ]
    new-melody-char
    )
     )

(defn player-copy-new-similar-info
  [& {:keys [change-player-id follow-player-id originator-player-id]}]
  (let [to-player (get-player-map follow-player-id)]
    (if (= change-player-id (get-behavior-player-id (get-behavior to-player)))
      (let [similar-player-info (get-similar-info-from-player (get-player-map change-player-id))
            similar-melody-char (adjust-melody-char-for-instrument
                                    (get-melody-char similar-player-info)
                                    (get-instrument-info to-player))
           new-similar-info (assoc similar-player-info :melody-char similar-melody-char)
            ]
        (new-similar-info-for-player
         :change-player-id change-player-id
         :follow-player-id follow-player-id
         :originator-player-id originator-player-id
         :similar-info new-similar-info
         )
        )
      ))
  )

(defn clear-ensemble
  "used by send or send-off to clear ensemble atom"
  [cur-players]
  {}
  )

(defn clear-player-melodies
  "used by send or send-off to clear player-melodies atom"
  [cur-melodies]
  {}
  )
