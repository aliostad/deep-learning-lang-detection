(ns org.wol.kraken.sequencer
  (:require [clj-etl-utils.log   :as log])
  (:import [javax.sound.midi MidiSystem Sequence Receiver MidiEvent ShortMessage Sequencer
            Sequencer$SyncMode ControllerEventListener]))

(def *pattern* (atom {0 [false false false false] 1 [false false false false] 2 [false false false false] 3 [false false false false]
                      4 [false false false false] 5 [false false false false] 6 [false false false false] 7 [false false false false]
                      8 [false false false false] 9 [false false false false] 10  [false false false false] 11 [false false false false]
                      12 [false false false false] 13 [false false false false] 14 [false false false false] 15 [false false false false]}))

(def *sequencer* (atom nil))
(def *sequence* (Sequence. Sequence/PPQ 960))
(def *track* (.createTrack *sequence*))
(def *midi-receive-spp-fn* (atom nil))

(defmulti midi-receive (fn [message timestamp] (.getStatus message)))
(defmethod midi-receive ShortMessage/SONG_POSITION_POINTER [message timestamp]
  (@*midi-receive-spp-fn* (.getData2 message)))

(defmethod midi-receive :default [message timestamp]
  (comment (println "status byte:" (.getStatus message))))

(def midi-receive-handler (proxy [Receiver] []
                            (send [message timestamp]
                                  (midi-receive message timestamp)
                                  )))

(def *note-on* (doto (ShortMessage.) (.setMessage ShortMessage/NOTE_ON 0 60 93)))
(def *note-off* (doto (ShortMessage.) (.setMessage ShortMessage/NOTE_OFF 0 60 93)))

(defn add-spp-events []
  (doseq [beats (take 17 (iterate inc 0))]
    (.add *track* (MidiEvent. (doto (ShortMessage.)
                                (.setMessage ShortMessage/SONG_POSITION_POINTER 0 beats))
                              (* beats 240)))))

(defn clear-pattern []
  (doseq [step (keys @*pattern*)]
    (swap! *pattern*
           merge
           {step
            (vec (map (fn [i] false) (get @*pattern* step))) })))


(defn add-note-on-events []
  (doseq [ticks (take 16 (iterate #(+ 240 %) 0))]
    (.add *track* (MidiEvent. *note-on* ticks))))

(defn add-note-off-events []
  (doseq [ticks (take 17 (iterate #(+ 240 %) 240))]
    (.add *track* (MidiEvent. *note-off* ticks))))

(defn clear-spp-events []
  (doseq [event-num (reverse (range (.size *track*)))]
    (.remove *track* (.get *track* event-num))))

(defn initialize-pattern []
  (clear-spp-events)
  (add-spp-events)
  (add-note-on-events)
  (add-note-off-events))

(defn loop-bar []
  (doto @*sequencer*
    (.setLoopStartPoint 0)
    (.setLoopEndPoint 3840)
    (.setLoopCount Sequencer/LOOP_CONTINUOUSLY)))


(defn init-sequencer [midi-receive-spp-fn]
  (reset! *sequencer* (MidiSystem/getSequencer))
  (.setSequence @*sequencer* *sequence*)
  (.setReceiver (first (.getTransmitters @*sequencer*)) midi-receive-handler)
  (clear-spp-events)
  (add-spp-events)
  (clear-pattern)
  (loop-bar)
  (reset! *midi-receive-spp-fn* midi-receive-spp-fn)
  (.setTempoInBPM @*sequencer* 120)
  (.open @*sequencer*))


(defn step-selected [step instrument checked]
  (let [beat-pattern              (get @*pattern* step)]
    (log/infof "Setting step(%s), instrument(%s) to %s" step instrument checked)
    (swap! *pattern* merge
           { step
            (vec (concat (take instrument beat-pattern)
                         [checked]
                         (drop (+ 1 instrument) beat-pattern)))
            })))

(defn int->binary-list [dividend]
  (loop [dividend dividend
         pattern []]
    (if (not (zero?  (int (/ dividend 2))))
      (recur (int (/ dividend 2))
             (cons   (= (rem dividend 2) 1) pattern ))
      (conj pattern (= (rem dividend 2) 1)))))

(defn lpad-binary-list [binary-list bits]
  (loop [binary-list binary-list
         lpad-count  (- bits (count binary-list))]
    (if (> lpad-count 0)
      (recur (cons false binary-list)
             (dec lpad-count))
      binary-list)))

(comment

  (.open @*sequencer*)
  (.start @*sequencer*)
  (.stop @*sequencer*)
  (.setTickPosition @*sequencer* 0 )
  (.getTickPosition @*sequencer*)
  (.size *track*)
  (clear-pattern)
  (loop-bar)
  (map #(.getTick  (.get *track* %1)) (range (.size *track*) ))
  (map #(.getMessage  (.get *track* %1)) (range (.size *track*) ))
  (map #(last  ( .getMessage  (.getMessage  (.get *track* %1)))) (range (.size *track*) ))

  (.remove *track*(.get *track* (- (.size *track*) 1)))
  (.isRunning @*sequencer*))
