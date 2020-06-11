(ns org.wol.kraken-client.sequencer
  (:require
   [wol-utils.core                :as wol-utils])
  (:use
   [clj-etl-utils.lang-utils :only [raise]]))

(def *pattern* (atom {0 [false false false false] 1 [false false false false] 2 [false false false false] 3 [false false false false]
                      4 [false false false false] 5 [false false false false] 6 [false false false false] 7 [false false false false]
                      8 [false false false false] 9 [false false false false] 10  [false false false false] 11 [false false false false]
                      12 [false false false false] 13 [false false false false] 14 [false false false false] 15 [false false false false]}))

(defn step-selected [step instrument checked]
  (let [beat-pattern              (get @*pattern* step)]
    (wol-utils/wol-info "Setting step(%s), instrument(%s) to %s" step instrument checked)
    (swap! *pattern* merge
           { step
            (vec (concat (take instrument beat-pattern)
                         [checked]
                         (drop (+ 1 instrument) beat-pattern)))
            })))

