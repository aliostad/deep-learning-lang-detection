(println "--> cadejo.ui.midi.channel-editor")

(ns cadejo.ui.midi.channel-editor
  (:require [cadejo.config])
  (:require [cadejo.util.user-message :as umsg])
  (:require [cadejo.ui.midi.node-editor])
  (:require [cadejo.ui.midi.properties-panel])
  (:require [cadejo.ui.util.factory :as factory])
  (:require [cadejo.ui.util.help])
  (:require [cadejo.ui.util.lnf :as lnf])
  (:require [cadejo.ui.util.validated-text-field :as vtf])
  (:require [clojure.string])
  (:require [seesaw.core :as ss])
  (:require [seesaw.font :as ssf])
  (:import javax.swing.SwingUtilities
           java.awt.BorderLayout
           java.awt.event.WindowListener))

(def ^:private frame-size [1281 :by 661])
(def ^:private id-font (ssf/font :name :serif :size 24))

;; Generate unique performance name 
;;
(defn- gen-performance-name [chanobj iname]
  (let [current (.performance-ids chanobj)
        counter* (atom 0)
        name* (atom "")
        found* (atom false)
        chan (inc (.channel-number chanobj))
        frmt "%s-%d-%d"]
    (while (not @found*)
      (reset! name* (format frmt iname chan @counter*))
      (reset! found* (not (some (fn [q](= q (keyword @name*))) current)))
      (swap! counter* inc))
    @name*))

;; Display modal dialog for adding performance/instrument to channel
;; 
(defn- performance-options-dialog [chanobj descriptor]
  (let [chan-ed (.get-editor chanobj)
        logo (.logo descriptor :small)
        instrument-type (.instrument-name descriptor)
        iname (clojure.string/capitalize (name instrument-type))
        about (.about descriptor)
        lab-logo (ss/label :icon logo)
        lab-name (ss/label :text (format "  %s   %s" iname about))
        jb-help (factory/button "Help" :general :help "Help")
        pan-head (ss/border-panel :west lab-logo
                                  :center lab-name
                                  :east jb-help
                                  :border (factory/padding))
        spin-mainbus (ss/spinner 
                      :model (ss/spinner-model 0 :from 0 :to 8 :by 1))
        pan-mainbus (ss/vertical-panel :items [spin-mainbus]
                                       :border (factory/title "Output bus"))
        spin-voice-count (ss/spinner
                          :model (ss/spinner-model 6 :from 1 :to 32 :by 1))
        pan-voice-count (ss/vertical-panel
                         :items [spin-voice-count]
                         :border (factory/title "Voice Count"))
        bgrp (ss/button-group)
        selected-mode* (atom nil)
        mode-buttons (let [acc* (atom [])]
                       (doseq [km (.modes descriptor)]
                         (let [rb (ss/radio :text (name km) :group bgrp)]
                           (.putClientProperty rb :keymode km)
                           (swap! acc* (fn [n](conj n rb)))
                           (ss/listen rb :action 
                                      (fn [ev]
                                        (let [src (.getSource ev)
                                              keymode (.getClientProperty src :keymode)
                                              is-poly (not (= keymode :mono))]
                                          (.setEnabled spin-voice-count is-poly)
                                          (.setEnabled pan-voice-count is-poly)
                                          (reset! selected-mode* keymode))))))
                       (.doClick (last @acc*))
                       @acc*)
        pan-modes (ss/grid-panel :rows 1
                                 :items mode-buttons
                                 :border (factory/title "Key mode"))
        pan-mode-options (ss/grid-panel :rows 1
                                        :items [pan-mainbus pan-voice-count])
        pan-north (ss/vertical-panel
                   :items [pan-head pan-modes pan-mode-options])

        ;; Controllers
        cc-spinners* (atom {})
        cc-panels (let [acc* (atom [])]
                    (doseq [cc (.controllers descriptor)]
                      (let [ccd (.controller descriptor cc)
                            usage (:usage ccd)
                            default (:default ccd)
                            spin (ss/spinner
                                  :model (ss/spinner-model default :from 0
                                                           :to 127 :by 1))
                            lab (ss/label :text (format "%-3s %-16s " (name cc) usage))
                            pan (ss/border-panel :center lab :east spin)]
                        (swap! cc-spinners* (fn [n](assoc n (keyword cc) spin)))
                        (swap! acc* (fn [n](conj n pan)))))
                    @acc*)
        pan-controllers (ss/grid-panel :columns 1
                                       :items cc-panels
                                       :border (factory/title "Controllers"))

        ;; Performance name
        pname-test (fn [n]
                     (let [current-children (.performance-ids chanobj)
                           is-continuous (= -1 (.indexOf n " "))
                           no-colon (= -1 (.indexOf n ":"))]
                       (and 
                        (pos? (count n))
                        is-continuous
                        no-colon
                        (not (some (fn [q](= (keyword n) q))
                                   current-children)))))
        vtf-instrument-id (vtf/validated-text-field :validator pname-test
                                                    :value (gen-performance-name chanobj iname)
                                                    :border "Instrument ID")
        jb-add (ss/button :text "Add Instrument")
        jb-cancel (ss/button :text "Cancel")
        pan-main (ss/border-panel :north pan-north
                                  :center pan-controllers
                                  :south (.widget vtf-instrument-id :pan-main))
        dia (ss/dialog :title (format "Add %s to channel %d"
                                      iname (inc (.channel-number chanobj)))
                       :content pan-main  
                       :type :plain
                       :options [jb-add jb-cancel]
                       :default-option jb-add
                       :modal? true
                       :on-close :dispose
                       :size [400 :by 500])]
    (.putClientProperty jb-help :topic :add-instrument)
    ;(ss/listen jb-help :action cadejo.ui.util.help/help-listener)

    (ss/listen jb-cancel :action 
               (fn [_]
                 (.status! (.get-editor chanobj)
                           "Add instrument canceled")
                 (ss/return-from-dialog dia nil)))
    
    (ss/listen jb-add :action 
               (fn [_]
                 (println (format "Creating %s Performance" (.instrument-name descriptor)))
                 (.working chan-ed true)
                 (.status! chan-ed (format "Creating %s Performance" (.instrument-name descriptor)))
                 (SwingUtilities/invokeLater
                  (proxy [Runnable][]
                    (run []
                      (let [s (.parent chanobj)
                            ci (.channel-number chanobj)
                            id (.get-value vtf-instrument-id)
                            vc (int (.getValue spin-voice-count))
                            mbus (int (.getValue spin-mainbus))
                            args (let [acc* (atom [s ci (keyword id)
                                                   :voice-count vc
                                                   :main-out mbus])]
                                   (doseq [cc (keys @cc-spinners*)]
                                     (let [spin (get @cc-spinners* (keyword cc))
                                           val (int (.getValue spin))]
                                       (swap! acc* (fn [n](conj n cc)))
                                       (swap! acc* (fn [n](conj n val)))))
                                   @acc*)]
                        (if (.is-valid? vtf-instrument-id)
                          (let [kmode @selected-mode*]
                            (.create descriptor kmode args)
                            (.sync-ui! (.get-editor s))
                            (.status! chan-ed
                                      (format "Added %s %s id = %s" kmode iname id))
                            (.working chan-ed false)
                            (ss/return-from-dialog dia true))
                          (do
                            (Thread/sleep 750)
                            (.working chan-ed false)))))))))
    (ss/show! dia)))

;; Provides buttons for available instruments
;;
(defn- add-performance-panel [chanobj]
  (let [buttons (let [acc* (atom [])]
                  (doseq [id (cadejo.config/instruments)]
                    (let [d (cadejo.config/instrument-descriptor id)
                          logo (.logo d :medium)
                          ttt (format "Add %s - %s" (.instrument-name d)(.about d))
                          jb (ss/button :icon logo)
                          lab (ss/label :text (.about d) :halign :center)
                          pan (ss/border-panel :center jb :south lab)]
                      (.putClientProperty jb :instrument-name id)
                      (.putClientProperty jb :descriptor d)
                      (.setToolTipText jb ttt)
                      (swap! acc* (fn [n](conj n pan)))
                      (ss/listen jb :action
                                 (fn [ev]
                                   (let [src (.getSource ev)
                                         descriptor (.getClientProperty src :descriptor)]
                                     (performance-options-dialog chanobj descriptor))))))
                  @acc*)
        break 6
        tbar1 (ss/toolbar :floatable? false :items (take break buttons))
        tbar2 (ss/toolbar :floatable? false :items (nthrest buttons break))
        pan-main (ss/grid-panel :rows 2 :items [tbar1 tbar2])]
    pan-main))

(defn channel-editor [chanobj]
  (let [basic-ed (cadejo.ui.midi.node-editor/basic-node-editor :channel chanobj)
        lab-id (.widget basic-ed :lab-id)
        pan-center (.widget basic-ed :pan-center)
        tbar-performance (ss/toolbar :floatable? false)
        midi-properties-panel (cadejo.ui.midi.properties-panel/midi-properties-panel)
        bgroup (ss/button-group)
      
        pan-add-performance (add-performance-panel chanobj)
        pan-cards (ss/card-panel :items [[pan-add-performance "ADD-INSTRUMENT"]
                                         [(.widget midi-properties-panel :pan-main) "MIDI"]])

        jb-add (let [b (factory/toggle "Add Instrument" :general :instrument "Add instrument" bgroup)]
                 (ss/listen b :action (fn [_](ss/show-card! pan-cards "ADD-INSTRUMENT")))
                 b)
        jb-midi (let [b (factory/toggle "MIDI" :midi :plug "Set channel MIDI properties" bgroup)]
                  (ss/listen b :action (fn [_](ss/show-card! pan-cards "MIDI")))
                  b)
        toolbar (.widget basic-ed :toolbar) ]
    (.add toolbar jb-add)
    (.add toolbar jb-midi)
    (ss/config! (.widget basic-ed :jframe) :on-close :hide)
    (ss/config! (.widget basic-ed :jframe) :title (format "Cadejo Channel %d" (inc (.channel-number chanobj))))
    (let [ced (reify cadejo.ui.midi.node-editor/NodeEditor
                (cframe! [this cf embed] (.cframe! basic-ed cf embed))

                (cframe! [this cf] (.cframe! basic-ed cf))

                (cframe [this] (.cframe basic-ed))

                (jframe [this] (.jframe basic-ed))

                (set-icon! [this ico] (.set-icon! basic-ed ico))

                (show! [this] (.show! basic-ed))

                (hide! [this] (.hide! basic-ed))

                (widgets [this] (.widgets basic-ed))

                (widget [this key]
                  (let [rs (.widget basic-ed key)]
                    (if (not rs)
                      (umsg/warning (format "ChannelEditor does not have %s widget" key))
                      rs)))

                (add-widget! [this key obj] (.add-widget! basic-ed key obj))

                (node [this] chanobj)

                (set-node! [this _] nil) ;; not implemented

                (set-path-text! [this msg] (.set-path-text! basic-ed msg))

                (working [this flag] (.working basic-ed flag))

                (status! [this msg] (.status! basic-ed msg))

                (warning! [this msg] (.warning! basic-ed msg))

                (update-path-text [this] (.update-path-text basic-ed))

                (sync-ui! [this]
                  (.removeAll tbar-performance)
                  (doseq [p (.children chanobj)]
                    (let [itype (.get-property p :instrument-type p)
                          id (.get-property p :id)
                          logo (.logo p :small)
                          jb (ss/button :icon logo)]
                      (ss/listen jb :action
                                 (fn [ev]
                                   (let [mods (.getModifiers ev)
                                         ced (.get-editor chanobj)
                                         ped (.get-editor p)
                                         pframe (.widget ped :jframe)]
                                     (cond (= mods 17) ; shift+click -> remove performance
                                           nil         ; not implemented

                                           :default    ; hide/show performance
                                           (if (.isVisible pframe)
                                             (ss/hide! pframe)
                                             (do
                                               (ss/show! pframe)
                                               (.toFront pframe)))))))
                      (.add tbar-performance jb)
                      (.revalidate (.jframe this))
                      (.sync-ui! (.get-editor p))))) )]
                
      (ss/config! lab-id 
                  :text (format "Channel %s " (inc (.channel-number chanobj)))
                  :font id-font)
      (ss/listen (.widget ced :jb-parent)
                 :action (fn [_]
                           (let [scene (.parent chanobj)
                                 sed (.get-editor scene)
                                 sframe (.jframe (.cframe sed))]
                             (ss/show! sframe)
                             (.toFront sframe))))
      (.set-parent-editor! midi-properties-panel ced)
      (.add pan-center pan-cards BorderLayout/CENTER)
      (.add pan-center tbar-performance BorderLayout/SOUTH)
                                        ;(ss/config! (.frame ced) :size frame-size)
      (ss/config! (.widget ced :jframe) :size frame-size)
      (.addWindowListener (.widget ced :jframe)
                          (proxy [WindowListener][]
                            (windowClosed [_] nil)
                            (windowClosing [_] nil)
                            (windowDeactivated [_] nil)
                            (windowIconified [_] nil)
                            (windowDeiconified [_] (.sync-ui! ced))
                            (windowActivated [_] 
                              (.sync-ui! ced))
                            (windowOpened [_] nil)))
      (.set-path-text! basic-ed (let [scene (.parent chanobj)
                                  sid (.get-property scene :id)
                                  chan (inc (.channel-number chanobj))] 
                                  (format "Root / %s / chan %s" sid chan)))
      (.set-icon! basic-ed (lnf/read-channel-icon (inc (.channel-number chanobj))))
      ;(.putClientProperty (.widget basic-ed :jb-help) :topic :channel)
      ced)))
