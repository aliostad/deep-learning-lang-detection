(println "--> cadejo.ui.midi.performance-editor")

(ns cadejo.ui.midi.performance-editor
  (:require [cadejo.config :as config])
  (:require [cadejo.util.user-message :as umsg])
  (:require [cadejo.ui.midi.bank-editor])
  (:require [cadejo.ui.midi.cc-properties-panel])
  (:require [cadejo.ui.midi.node-editor])
  (:require [cadejo.ui.midi.properties-panel])
  (:require [cadejo.ui.util.factory :as factory])
  (:require [cadejo.ui.util.lnf :as lnf])
  (:require [seesaw.core :as ss])
  (:import java.awt.BorderLayout
           java.awt.event.WindowListener
           javax.swing.SwingUtilities))

(def frame-size [1280 :by 587])

(defn performance-editor [performance]
  (let [descriptor (.get-property performance :descriptor)
        basic-ed (let [bed (cadejo.ui.midi.node-editor/basic-node-editor :performance performance)
                       logo (.logo descriptor :small)
                       iname (.instrument-name descriptor)
                       id (.get-property performance :id)]
                   (.set-icon! bed logo)
                   (ss/config! (.widget bed :jframe) :title (name id))
                   (ss/config! (.widget bed :lab-id) :text (name id))
                   bed)
        instrument-editor* (atom nil) ;; editor created only if needed
        toolbar (.widget basic-ed :toolbar)
        bank (.bank performance)
        bank-ed (let [bed (cadejo.ui.midi.bank-editor/bank-editor bank)]
                  (.editor! bank bed)
                  bed)
        program-bar (.widget bank-ed :program-bar)
        properties-panel (cadejo.ui.midi.properties-panel/midi-properties-panel)
        card-buttons* (atom [])
        card-group (ss/button-group)
        pan-cards (ss/card-panel :items [[(.widget properties-panel :pan-main) "MIDI"]])
        pan-split (ss/left-right-split
                   (.widget bank-ed :pan-main)
                   pan-cards)
        pan-center (let [panc (.widget basic-ed :pan-center)]
                     (.add panc pan-split)
                     panc)
        
        available-controllers (.controllers descriptor)
        cced* (atom nil)]
    
    (let [b (factory/button "Transmit" :midi :transmit "Transmit current program")]
      (.add toolbar b)
      (ss/listen b :action (fn [_]
                             (let [slot (.current-slot bank)]
                               (if slot 
                                 (do
                                   (.program-change bank {:data1 slot})
                                   ))))))
    (let [b (factory/toggle "MIDI" :midi :plug "Display MIDI properties" card-group)]
      (.putClientProperty b :card "MIDI")
      (swap! card-buttons* (fn [n](conj n b)))
      (.add toolbar b))
    ;; Add CTRL properties panels
    (let [cced (cadejo.ui.midi.cc-properties-panel/cc-properties-panel descriptor)
          card-id "CTRL"
          jb (factory/toggle card-id :midi :ctrl "Display MIDI controller properties" card-group)]
      (reset! cced* cced)
      (.putClientProperty jb :card card-id)
      (.add pan-cards (.widget cced :pan-main) card-id)
      (swap! card-buttons* (fn [q](conj q jb)))
      (.add toolbar jb))
    (let [b (factory/toggle "Edit" :edit nil "Edit current program" card-group)]
      (.putClientProperty b :card "EDIT")
      (ss/listen b :action (fn [_]
                             (if (not @instrument-editor*)
                               (do (.working basic-ed true)
                                   (.status! basic-ed "Creating editor")
                                   (SwingUtilities/invokeLater
                                    (proxy [Runnable][]
                                      (run []
                                        (let [ied (.create-editor descriptor performance)]
                                          (reset! instrument-editor* ied)
                                          (.instrument-editor! bank-ed ied)
                                          (.add pan-cards (.widget ied :pan-main) "EDIT"))
                                        (.working basic-ed false)
                                        (.status! basic-ed "")
                                        (ss/show-card! pan-cards "EDIT")))))
                               (try
                                 (ss/show-card! pan-cards "EDIT")
                                 (.sync-ui! @instrument-editor*)
                                 (catch NullPointerException ex
                                   (.warning! basic-ed "Editor not defined"))))))
      (.add toolbar b))
    (ss/config! (.widget basic-ed :jframe) :on-close :hide)
    (let [ped (reify cadejo.ui.midi.node-editor/NodeEditor

                (cframe! [this  cf embed] (.cframe! basic-ed cf embed))

                (cframe! [this cf] (.cframe! basic-ed cf))

                (cframe [this] (.cframe basic-ed))

                (jframe [this] (.jframe basic-ed))

                (set-icon! [this ico] (.set-icon! basic-ed ico))

                (show! [this] (.show! basic-ed))

                (hide! [this] (.hide! basic-ed))
                
                (widgets [this] (.widgets basic-ed))

                (widget [this key]
                  (or (.widget basic-ed key)
                      (umsg/warning (format "PerformanceEditor does not have %s widget" key))))

                (add-widget! [this key obj] (.add-widget! basic-ed key obj))
                
                (node [this] (.node basic-ed))
                
                (working [this flag] (.working basic-ed flag))

                (status! [this msg] (.status! basic-ed msg))
                 
                 (warning! [this msg] (.warning! basic-ed msg))

                 (set-path-text! [this msg] (.set-path-text! basic-ed msg))

                 (update-path-text [this] (.update-path-text basic-ed))
                 
                 (sync-ui! [this]
                   (.sync-ui! bank-ed)
                   (.sync-ui! properties-panel)
                   ((:syncfn program-bar))
                   (.sync-ui! @cced*)) )]
      (.set-parent-editor! properties-panel ped)
      (.set-parent-editor! bank-ed ped)
      (.put-property! performance :bank-editor bank-ed)
      (.set-parent-editor! @cced* ped)
      (ss/config! (.jframe ped) :size frame-size)
      (ss/listen (.widget ped :jb-parent)
                 :action (fn [_]
                           (let [chanobj (.parent performance)
                                 ced (.get-editor chanobj)
                                 jframe (.widget ced :jframe)]
                             (ss/show! jframe)
                             (.toFront jframe))))
      (.addWindowListener (.widget ped :jframe)
                          (proxy [WindowListener][]
                            (windowClosed [_] nil)
                            (windowClosing [_] nil)
                            (windowDeactivated [_] nil)
                            (windowIconified [_] nil)
                            (windowDeiconified [_] (.sync-ui! ped))
                            (windowActivated [_] 
                              (.sync-ui! ped))
                            (windowOpened [_] nil)))
      (.set-path-text! basic-ed (let [scene (.get-scene performance)
                                  chanobj (.parent performance)
                                  sid (.get-property scene :id)
                                  chan (inc (.channel-number chanobj))
                                  pid (.get-property performance :id)]
                              (format "Root / %s / chan %s / %s"
                                      sid chan (name pid))))
      (doseq [b @card-buttons*]
        (ss/listen b :action (fn [ev]
                               (let [src (.getSource ev)
                                     card-id (.getClientProperty src :card)]
                                 (ss/show-card! pan-cards card-id)
                                 (.revalidate pan-cards)))))
      (.add (.widget basic-ed :pan-center)(:pan-main program-bar) BorderLayout/SOUTH)
      (.putClientProperty (.widget basic-ed :jb-help) :topic :performance)
      ped))) 
