;; algo_editor.clj
;;     op_editor.clj
;;         op-amp-panel
;;         op-feedback-panel
;;         op-freq-panel
;;         op-keyscale-panel
;;         op-observer
;;         op-selection-panel
;;         envelope-panel
;;     lfo_editor.clj
;;         lfo-panel
;;         op-selection-panel
;;     pitch_editor.clj
;;         pitch-panel
;;         vibrato-panel
;;         envelope-panel
;;         op-selection-panel
;;     efx_editor.clj
;;         delay-panel
;;         reverb-panel
;;         amp-panel
;;         op-selection-panel

(ns cadejo.instruments.algo.editor.algo-editor
  (:require [cadejo.ui.instruments.instrument-editor :as ied])
  (:require [cadejo.instruments.algo.editor.op-editor :as oped])
  (:require [cadejo.instruments.algo.editor.lfo-editor :as lfoed])
  (:require [cadejo.instruments.algo.editor.pitch-editor :as ped])
  (:require [cadejo.instruments.algo.editor.efx-editor :as efxed]))

(defn algo-editor [performance]
  (println "--> Creating ALGO editor...")
  (let [ied (ied/instrument-editor performance)
        op1 (oped/op-editor 1 ied)
        op2 (oped/op-editor 2 ied)
        op3 (oped/op-editor 3 ied)
        op4 (oped/op-editor 4 ied)
        op5 (oped/op-editor 5 ied)
        op6 (oped/op-editor 6 ied)
        op7 (oped/op-editor 7 ied)
        op8 (oped/op-editor 8 ied)
        lfo (lfoed/lfo-editor ied)
        ped (ped/pitch-editor ied)
        efx (efxed/efx-editor ied)]
    (.add-sub-editor! ied "OP 1" :wave :fm "Op 1 Editor" op1)
    (.add-sub-editor! ied "OP 2" :wave :fm "Op 2 Editor" op2)
    (.add-sub-editor! ied "OP 3" :wave :fm "Op 3 Editor" op3)
    (.add-sub-editor! ied "OP 4" :wave :fm "Op 4 Editor" op4)
    (.add-sub-editor! ied "OP 5" :wave :fm "Op 5 Editor" op5)
    (.add-sub-editor! ied "OP 6" :wave :fm "Op 6 Editor" op6)
    (.add-sub-editor! ied "OP 7" :wave :fm "Op 7 Editor" op7)
    (.add-sub-editor! ied "OP 8" :wave :fm "Op 8 Editor" op8)
    (.add-sub-editor! ied "LFO" :wave :sine "LFO Editor" lfo)
    (.add-sub-editor! ied "Pitch" :general :linear "Pitch Editor" ped)
    (.add-sub-editor! ied "Effects" :general :fx "Effects editor" efx)
    (.show-card-number! ied 1)
    (.sync-ui! ied)
    ied))
