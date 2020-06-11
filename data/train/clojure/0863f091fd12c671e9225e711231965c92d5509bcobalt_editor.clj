(println "-->    cobalt editor")
(ns cadejo.instruments.cobalt.editor.cobalt-editor
  (:require [cadejo.instruments.cobalt.editor.op-editor :as oped])
  (:require [cadejo.instruments.cobalt.editor.noise-editor :as ned])
  (:require [cadejo.instruments.cobalt.editor.buzz-editor :as bed])
  (:require [cadejo.instruments.cobalt.editor.filter-editor :as fed])
  (:require [cadejo.instruments.cobalt.editor.vibrato-editor :as ved])
  (:require [cadejo.instruments.cobalt.editor.efx-editor :as fxed])
  (:require [cadejo.ui.instruments.instrument-editor :as ied]))


(defn cobalt-editor [performance]
  (println "Creating cobalt editor")
  (let [ied (ied/instrument-editor performance)
        fed (do (println "-->    Filter") (fed/filter-editor ied))
        ved (do (println "-->    Vibrato & LFO") (ved/vibrato-editor ied))
        xed (do (println "-->    Effects")(fxed/efx-editor ied))]
    (doseq [op [1 2 3 4 5 6 :nse :bzz]]
      (println (format "-->    %s" (cond (= op :nse) "Noise"
                                         (= op :bzz) "Buzz"
                                         :default (format "OP%d" op))))
      (cond (= op :nse)
            (let [ed (ned/noise-editor ied)]
              (.add-sub-editor! ied "Noise" :wave :noise "Noise" ed))
            (= op :bzz)
            (let [ed (bed/buzz-editor ied)]
              (.add-sub-editor! ied "Buzz" :wave :pulse "Buzz" ed))
            :default
            (let [ed (oped/op-editor op ied)
                  name (format "OP %d" op)]
              (.add-sub-editor! ied name :wave :fm name ed))))
    (.add-sub-editor! ied "Filter" :filter :low "Filter" fed)
    (.add-sub-editor! ied "Vibrato" :wave :sine "Portamento, Vibrato, LFO1, Pitch Envelope" ved)
    (.add-sub-editor! ied "Effects" :general :fx "Effects" xed)
    ied))
