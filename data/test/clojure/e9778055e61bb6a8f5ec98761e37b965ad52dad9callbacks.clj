(ns org.wol.minotaur.callbacks
  (:require
   [org.wol.minotaur.gui :as gui]
   [org.wol.minotaur.sequencer :as sequencer]
   [org.wol.minotaur.audio     :as audio]))

(defn play-sounds-for-step [step]
    (let [step-instructions (get @sequencer/*pattern* step)
        instrument-dispatch {0 audio/*Drum1* 1 audio/*Drum2*
                             2 audio/*Drum3* 3 audio/*Drum4*}]
    (dotimes [i 4]
      (if (nth step-instructions i)
           (do
             (println (format  "playing sound %d for step %d" i step))
             (audio/play-sound-from-atom (get instrument-dispatch i)))))))


(defmulti update-step-display (fn [step] step))
(defmethod update-step-display 0 [step]
  (play-sounds-for-step 0)
  (.setVisible (nth @gui/*step-icons* 15) false)
  (.setVisible (nth @gui/*step-icons* 0) true))



(defmethod update-step-display :default [step]
  (play-sounds-for-step step)
  (.setVisible (nth @gui/*step-icons* (- step 1)) false)
  (.setVisible (nth @gui/*step-icons* step) true))



(defn play-sequencer []
  (.start sequencer/*sequencer*))

(defn stop-sequencer []
  (.stop sequencer/*sequencer*))

(defn step-selected [e]
  (let [checkbox-tuple (map #(Integer. %) (.split (.getLabel (.getSource e)) "-"))
        state          (.getStateChange e)
        beat           (last checkbox-tuple)
        instrument     (first checkbox-tuple)
        beat-pattern   (get @sequencer/*pattern* beat)
        flag           (if (= state 2) false true)]
    (if (= state 1)
      (println (format "Step %d %d SELECTED" instrument beat))
      (println (format "Step %d %d DESELECTED" instrument beat)))
    (swap! sequencer/*pattern* merge
           { beat
            (concat (take instrument beat-pattern)
                    [flag]
                    (drop (+ 1 instrument) beat-pattern))
            })))



(comment
  (get @sequencer/*pattern* 3)
  (concat (take 2 [0 0 0 0]) [1] (drop 3 [0 0 0 0]))
  [(Integer. 44)]
  )

(defn change-tempo [e]
  (println (format "Tempo Change to %s"  (.getValue gui/*tempo-knob*) ))
  (.setTempoFactor sequencer/*sequencer* (/ (.getValue gui/*tempo-knob*) 120)))


