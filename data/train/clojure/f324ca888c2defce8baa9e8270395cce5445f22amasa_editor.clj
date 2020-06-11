(ns cadejo.instruments.masa.editor.masa-editor
  (:require [cadejo.ui.instruments.instrument-editor :as ied])
  (:require [cadejo.instruments.masa.editor.drawbar-panel])
  (:require [cadejo.instruments.masa.editor.efx-panel]))

(defn masa-editor [performance]
  (let [ied (ied/instrument-editor performance)
        drawbar-ed (cadejo.instruments.masa.editor.drawbar-panel/drawbar-panel ied)
        efx-ed (cadejo.instruments.masa.editor.efx-panel/efx-panel ied)]
    (.add-sub-editor! ied "Drawbar" :general :mixer "Registration editor" drawbar-ed)
    (.add-sub-editor! ied "Efx" :general :fx "Effects editor" efx-ed)
    (.show-card-number! ied 1)
    ied))
