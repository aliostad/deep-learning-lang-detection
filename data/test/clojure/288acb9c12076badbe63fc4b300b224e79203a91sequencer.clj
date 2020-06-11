(ns theremotion.sequencer
  (:require [overtone.live :refer :all]))

(def bar (atom {}))

(defn add-line! [line]
  (swap! bar #(merge-with concat % line))
  true)

(defn player
  [metro tick]
  (dorun
    (for [k (keys @bar)]
      (let [beat (Math/floor k)
            offset (- k beat)]
        (if (== 0 (mod (- tick beat) 4))
          (let [instruments (@bar k)]
            (dorun
              (for [instrument instruments]
                (at (metro (+ offset tick)) (instrument))))))))))

(defn run-sequencer
  [m]
  (let [beat (m)]
    (player m beat)
    (apply-by (m (inc beat))  #'run-sequencer [m])))


