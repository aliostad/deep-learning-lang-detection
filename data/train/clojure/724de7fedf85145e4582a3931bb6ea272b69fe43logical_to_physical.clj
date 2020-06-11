(ns composition-kit.music-lib.logical-to-physical
  (:require [composition-kit.music-lib.midi-util :as midi])
  (:require [composition-kit.music-lib.tempo :as tempo])
  (:require [composition-kit.events.physical-sequence :as ps])
  (:require [composition-kit.events.transport-window :as tw])
  (:require [composition-kit.music-lib.logical-sequence :as ls])
  (:require [composition-kit.music-lib.logical-item :as i])
  (:require [composition-kit.music-lib.tonal-theory :as th])
  (:require [composition-kit.music-lib.samples :as samp])
  )

;; Here we project through the clock and the instrument to a set of actual midi functions which will play the music
;; to the midi ports specified at the time and volumen needed, including the various control and pitch commands.

(defn ^:private schedulable-item [item]
  (let [instrument (i/item-instrument item)
        clock      (i/item-clock item)
        _          (when (nil? clock) 
                     (throw (ex-info "Item with nil clock can't be scheduled"
                                     {:item item})))
        _          (when (nil? instrument) 
                     (throw (ex-info "Item with nil instrument can't be scheduled"
                                     {:item item})))]
    true))

(defn schedule-logical-on-physical
  [in-seq in-pattern & opt-arr]
  ;; This is basically a massive reduce statement on a big switch based on item type which then
  ;; does the magic. There's no real way to make this anything other than it is as far as I can see.
  (let [opts (apply hash-map opt-arr)
        beat-zero (get opts :beat-zero 0)
        beat-end  (get opts :beat-end -1)
        beat-clk  (get opts :beat-clock nil)

        samples (get opts :samples [])
        ;; for now make the assumptino that the clip is always longer than the underlying sequence
        clip-players (map (fn [config] (samp/clip-player (:file config) (:zero-point config)) ) samples)

        
        pattern  (->> in-pattern
                      (drop-while #(< (i/item-beat %) beat-zero))
                      (take-while #(or (neg? beat-end) (< (i/item-beat %) beat-end)))
                      )
        
        reduce-seq
        (reduce (fn [pseq item]
                  (case (i/item-type item)
                    :composition-kit.music-lib.logical-item/notes-with-duration
                    (let [_          (schedulable-item item)
                          payload    (i/item-payload item)
                          instrument (:port (i/item-instrument item))
                          clock      (i/item-clock item)
                          t0         (tempo/beats-to-time clock beat-zero)
                          
                          notecont (:notes payload)
                          notes    (if (coll? notecont) notecont [ notecont ] )
                          resolved-notes (map th/note-by-name notes)
                          hold-for (:hold-for payload)
                          lev      (i/note-dynamics-to-7-bit-volume item)
                          start-time (* 1000 (- (tempo/beats-to-time clock (i/item-beat item)) t0))
                          end-time   (* 1000 (- (tempo/beats-to-time clock (+ hold-for (i/item-beat item))) t0))
                          ons      (reduce
                                    (fn [s e]
                                      (ps/add-to-sequence
                                       s
                                       ;;(partial println "NOTE ON" e)
                                       (midi/send-note-on
                                        (:receiver instrument)
                                        (:channel instrument)
                                        (:midinote e)
                                        lev)
                                       start-time))
                                    pseq
                                    resolved-notes
                                    )
                          
                          offs     (reduce
                                    (fn [s e]
                                      (ps/add-to-sequence
                                       s
                                       ;;(partial println "NOTE Off" e)
                                       (midi/send-note-off
                                        (:receiver instrument)
                                        (:channel instrument)
                                        (:midinote e))
                                       end-time)
                                      )
                                    ons
                                    resolved-notes)
                          ]
                      offs
                      )
                    
                    :composition-kit.music-lib.logical-item/control-event
                    (let [_          (schedulable-item item)
                          payload    (i/item-payload item)
                          clock      (i/item-clock item)
                          t0         (tempo/beats-to-time clock beat-zero)
                          instrument (:port (i/item-instrument item))
                          
                          start-time (* 1000 (- (tempo/beats-to-time clock (i/item-beat item)) t0))]
                      (ps/add-to-sequence
                       pseq
                       (midi/send-control-change
                        (:receiver instrument)
                        (:channel instrument)
                        (:control payload)
                        (:value payload))
                       start-time
                       ))

                    :composition-kit.music-lib.logical-item/pitch-bend-event
                    (let [_          (schedulable-item item)
                          payload    (i/item-payload item)
                          clock      (i/item-clock item)
                          t0         (tempo/beats-to-time clock beat-zero)
                          instrument (:port (i/item-instrument item))
                          
                          start-time (* 1000 (- (tempo/beats-to-time clock (i/item-beat item)) t0))
                          v  (:value payload)
                          msb (int (/ v 127))
                          lsb (mod v 127)
                          ]
                      (ps/add-to-sequence
                       pseq
                       (midi/send-pitch-bend
                        (:receiver instrument)
                        (:channel instrument)
                        lsb
                        msb)
                       start-time
                       ))
                    
                    :composition-kit.music-lib.logical-item/rest-with-duration
                    pseq
                    )
                  )
                in-seq
                pattern)

        result
        (if-not (nil? beat-clk)
          (let [len  (ls/beat-length pattern)
                overs 4
                ]
            (reduce (fn [pseq iii]
                      (let [iib (float (/ iii overs))
                            ii (int iib)
                            i (+ beat-zero ii)
                            ib (+ beat-zero iib)
                            t0         (tempo/beats-to-time beat-clk beat-zero)
                            start-time (* 1000 (- (tempo/beats-to-time beat-clk ib) t0))
                            ]
                        (ps/add-to-sequence
                         pseq
                         (fn [ttt] 
                           (when-let [t-w (tw/agent-transport-window)]
                             ((:assoc t-w) :beat i)
                             ((:assoc t-w) :pct (float (* 100 (/ (- ib beat-zero) len))))
                             ((:assoc t-w) :pbeat (float (- iib ii)))
                             ))
                         start-time
                         )) 
                      )
                    reduce-seq
                    (range (* overs (inc len))))
            
            )
          reduce-seq)

        _ (when (and  (pos? (count clip-players)) (nil? beat-clk))
            (throw (ex-info "A beat clock is required for samples" {}))
            )
        fresult (reduce
                 ;; AD CLIP STARTERS
                 (fn [pseq cp]
                   (-> pseq 
                       (ps/add-to-sequence
                        (fn [ttt]
                          (when-let [t-w (tw/agent-transport-window)]
                            ((:on-stop t-w) (:stop-and-close cp))
                            )
                          ((:start-at cp) (* (tempo/beats-to-time beat-clk beat-zero) 1000000))
                          )
                        0
                        )
                       (ps/add-to-sequence
                        (fn [ttt]
                          ((:position cp) (* (+ 0.5  (tempo/beats-to-time beat-clk beat-zero)) 1000000))
                          )
                        500
                        )

                       )
                   )
                 result
                 clip-players
                 )
        ]

    fresult 
    )
  )

(defn create-and-schedule [pattern]
  "A utility for when you want just one sequence schedulable"
  (-> (ps/new-sequence)
      (schedule-logical-on-physical pattern)))



