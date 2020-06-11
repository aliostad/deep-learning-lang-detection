(println "-->    alias editor")

(ns cadejo.instruments.alias.editor.alias-editor
  (:require [cadejo.ui.instruments.instrument-editor :as ied])
  (:require [cadejo.instruments.alias.editor.osc-editor :as osced])
  (:require [cadejo.instruments.alias.editor.noise-editor :as noiseed])
  (:require [cadejo.instruments.alias.editor.filter-editor :as filter])
  (:require [cadejo.instruments.alias.editor.efx-editor :as efxed])
  (:require [cadejo.instruments.alias.editor.mixer-editor :as mixer])
  (:require [cadejo.instruments.alias.editor.matrix-editor :as matrixed])
  (:require [cadejo.instruments.alias.editor.lf-editor :as lfoed])
  (:require [cadejo.instruments.alias.editor.step-editor :as steped])
  (:require [cadejo.instruments.alias.editor.envelope-editor :as enved])
  (:require [seesaw.core :as ss]))


(defn alias-editor [performance]
  (let [ied (ied/instrument-editor performance)
        osc1 (osced/osc-editor 1 ied)
        osc2 (osced/osc-editor 2 ied)
        osc3 (osced/osc-editor 3 ied)
        nse (noiseed/noise-editor ied)
        filter (filter/filter-editor ied)
        efx (efxed/efx-editor ied)
        mixer (mixer/mixer-editor ied)
        matrix (matrixed/matrix-editor ied)
        lf (lfoed/lf-editor ied)
        steped (steped/step-editor ied)
        enved (enved/env-editor ied)]
    (.add-sub-editor! ied "Osc 1" :wave :sawpos "Oscillator 1" osc1)
    (.add-sub-editor! ied "Osc 2" :wave :pulse "Oscillator 2" osc2)
    (.add-sub-editor! ied "Osc 3" :wave :fm "Oscillator 3" osc3)
    (.add-sub-editor! ied "Noise" :wave :noise "Noise/Ring Modulator" nse)
    (.add-sub-editor! ied "Filter" :filter :band "Filters" filter)
    (.add-sub-editor! ied "LFO" :wave :sine "LFO" lf)
    (.add-sub-editor! ied "Step" :wave :step "Steppers" steped)
    (.add-sub-editor! ied "Env" :env :adsr "Envelopes" enved)
    (.add-sub-editor! ied "Matrix" :general :matrix "Matrix" matrix)
    (.add-sub-editor! ied "Effects" :general :fx "Effects" efx)
    (.add-sub-editor! ied "Mixer" :general :mixer "Mixer" mixer)
    ied))


