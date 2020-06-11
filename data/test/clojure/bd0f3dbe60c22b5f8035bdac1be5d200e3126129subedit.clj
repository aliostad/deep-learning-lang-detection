(ns cadejo.ui.instruments.subedit
  (:require [seesaw.core :as ss])
  )

(defprotocol InstrumentSubEditor

  (widgets
    [this])

  (widget 
    [this key])

  (parent
    [this])

  (parent!
    [this p])

  (status! 
    [this msg])

  (warning!
    [this msg])

  (set-param! 
    [this param value])

  (init!
    [this])

  (sync-ui!
    [this]))


;; Wrap several subeditors to treat them as a single subeditor
;; editors - list of InstrumentSubEditor
;; panel - JPanel  used as main-panel of the composite editor,
;;         if nil a vertical panel is created.
;; Returns InstrumentSubEditor
;;
(defn subeditor-wrapper [editors panel]
  (let [pan-main (or panel (let [acc* (atom [])]
                             (doseq [e editors]
                               (swap! acc* (fn [q](conj q (.widget e :pan-main)))))
                             (ss/vertical-panel :items @acc*)))]
    (reify InstrumentSubEditor
      (widgets [this] {:pan-main pan-main})
      (widget [this key](get (.widgets this) key))
      (parent [this](.parent (first editors)))
      (parent! [this _] (.parent this)) ;; ignore
      (status! [this text](.status! (.parent this) text))
      (warning! [this text](.warning! (.parent this) text))
      (set-param! [this p v](.set-param! (.parent this) p v))
      (init! [this](doseq [e editors](.init! e)))
      (sync-ui! [this](doseq [e editors](.sync-ui! e))))))
        
        
