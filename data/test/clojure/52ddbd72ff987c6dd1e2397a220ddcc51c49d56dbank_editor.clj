(println "--> cadejo.ui.midi.bank-editor")

(ns cadejo.ui.midi.bank-editor
  (:require [cadejo.util.user-message :as umsg])
  (:require [cadejo.util.path :as path])
  (:require [cadejo.ui.midi.program-bar :as progbar])
  (:require [cadejo.ui.util.factory :as factory])
  (:require [cadejo.ui.util.help])
  (:require [cadejo.ui.util.overwrite-warning])
  (:require [cadejo.ui.util.undo-stack])
  (:require [seesaw.core :as ss])
  (:require [seesaw.chooser])
  (:import javax.swing.event.ListSelectionListener
           javax.swing.SwingUtilities))

(def ^:private program-count 128) 

(defprotocol BankEditor

  (widgets 
    [this])

  (widget
    [this key])

  (bank 
    [this])
  
  (performance
    [this])

  (push-undo-state!
    [this meg])

  (push-redo-state!
    [this msg])

  (undo! 
    [this])

  (redo! 
    [this])

  (set-parent-editor! 
    [this parent])

  (get-parent-editor
    [this])
  
  (set-program-bar! [this pbar])

  (working
    [this flag])

  (status!
    [this msg])

  (warning!
    [this msg])

  (sync-ui!
    [this])

  (instrument-editor!
    [this cfn]
    "Set instrument editor")

  (instrument-editor
    [this]
    "Return instrument editor or nil")

  (init-bank! [this])

  (save-bank-dialog [this])

  (open-bank-dialog! [this])
  
  (copy [this])

  (paste [this]))

(defn- format-program-cell [pnum programs]
  (let [prog (get programs pnum)
        name (if prog (.program-name prog) "")]
    (format "[%03d] %s" pnum name)))

(defn- create-program-list [bank]
  (let [acc* (atom [])
        programs (.programs bank)]
    (dotimes [p program-count]
      (swap! acc* (fn [n](conj n (format-program-cell p programs)))))
    @acc*))

(defn bank-editor [bnk]
  (let [parent* (atom nil)
        enabled* (atom true)
        file-extension (.toLowerCase (name (.data-format bnk)))
        instrument-editor* (atom nil)
        enable-list-selection-listener* (atom true)
        undo-stack (cadejo.ui.util.undo-stack/undo-stack "Undo")
        redo-stack (cadejo.ui.util.undo-stack/undo-stack "Redo")
        lab-filename (ss/label :text "Bank File : "
                               :border (factory/bevel))
        pan-info (ss/grid-panel :rows 1
                                :items [lab-filename])
        pan-south (ss/border-panel)
        lst-programs (ss/listbox :model (create-program-list bnk))
        pan-center (ss/horizontal-panel :items [(ss/scrollable lst-programs)]
                                        :border (factory/padding))
        pan-main (let [pm (ss/border-panel ;:north tbar1
                           :center pan-center
                           :south pan-south)]
                   (ss/config! pm :size [180 :by 300])
                   pm)
        file-extension (.toLowerCase (name (.data-format bnk)))

        file-filter (seesaw.chooser/file-filter
                     (format "%s Bank" file-extension)
                     (fn [f] 
                       (path/has-extension? (.getAbsolutePath f) file-extension)))
        program-bar* (atom nil)
        widget-map {:lab-filename lab-filename
                    :list-programs lst-programs
                    :pan-main pan-main}
        bank-ed (reify BankEditor
                  
                  (widgets [this] widget-map)

                  (widget [this key]
                    (cond (= key :program-bar) @program-bar*
                          :default
                          (or (get widget-map key)
                              (umsg/warning (format "BankEditor does not have %s widget" key)))))

                  (set-parent-editor! [this ed]
                    (reset! parent* ed))

                  (get-parent-editor [this]
                    @parent*)
                  
                  (set-program-bar! [this pbar]
                    (reset! program-bar* pbar))

                  (bank [this] bnk)

                  (performance [this]
                    (.get-parent-performance bnk))

                  (push-undo-state! [this action]
                    (.push-state! undo-stack [action (.clone bnk)]))

                  (push-redo-state! [this action]
                    (.push-state! redo-stack [action (.clone bnk)]))

                  (undo! [this]
                    (let [src (.pop-state! undo-stack)]
                      (if src
                        (do (.push-redo-state! this  (first src))
                            (.copy-state! bnk (second src))
                            (.sync-ui! this)
                            (.status! this (format "Undo %s" (first src))))
                        (.warning! this "Nothing to Undo"))))

                  (redo! [this]
                    (let [src (.pop-state! redo-stack)]
                      (if src
                        (do (.push-undo-state! this (first src))
                            (.copy-state! bnk (second src))
                            (.sync-ui! this)
                            (.status! this (format "Redo %s" (first src))))
                        (.warning! this "Nothing to Redo"))))
                  
                  (working [this flag]
                    (and @parent*
                         (.working @parent* flag)))

                  (status! [this msg]
                    (if @parent*
                      (.status! @parent* msg)
                      (umsg/message (format "BankEditor status %s"msg))))

                  (warning! [this msg]
                    (if @parent*
                      (.warning! @parent* msg)
                      (umsg/warning (format "BankEditor %s" msg))))

                  (sync-ui! [this]
                    (if @enabled*
                      (let [plst (.widget this :list-programs)
                            pnum (or (.current-slot bnk) 0)]
                        (reset! enable-list-selection-listener* false)
                        (ss/config! plst :model (create-program-list bnk))
                        (.setSelectedIndex plst pnum)
                        ;; ISSUE: automatic scrolling causes substance 
                        ;; UiThreadingViolationException
                        ;; (try
                        ;;   (.ensureIndexIsVisible plst pnum)
                        ;;   (catch Exception ex
                        ;;     (umsg/warning "Caught exception BankEditor.sync-ui!"
                        ;;                   "ensureIndexIsVisible")))
                        ((:syncfn @program-bar*))
                        (if @instrument-editor*
                          (.sync-ui! @instrument-editor*))
                        (reset! enable-list-selection-listener* true))))

                  (instrument-editor! [this ied]
                    (reset! instrument-editor* ied))

                  (instrument-editor [this]
                    (or @instrument-editor*
                        (do (.warning! this "Instrument editor not defined")
                            nil))) 

                  (init-bank! [this]
                    (.push-undo-state! this "Initialize Bank")
                    (.init! bnk)
                    (if @instrument-editor* (.init! @instrument-editor*))
                    (.sync-ui! this)
                    (.status! this "Initialized Bank"))

                  (save-bank-dialog [this]
                    (let [cancel (fn [& _] (.status! this "Bank Save Canceled"))
                          success (fn [_ f]
                                   (let [abs (path/append-extension (.getAbsolutePath f) file-extension)]
                                     (if (cadejo.ui.util.overwrite-warning/overwrite-warning pan-main "Bank" abs)
                                       (if (.write-bank bnk abs)
                                         (do 
                                           (ss/config! lab-filename :text (format "Bank File : '%s's" abs))
                                           (.status! this (format "Bank Saved to '%s'" abs)))
                                         (.warning! this (format "Can not save bank to '%s'" abs)))
                                       (cancel))))
                          dia (seesaw.chooser/choose-file
                               :type (format "Save %s Bank" (name (.data-format bnk)))
                               :multi? false
                               :selection-mode :files-only
                               :filters [file-filter]
                               :remember-directory? true
                               :success-fn success
                               :cancel-fn cancel)]))
                  
                  (open-bank-dialog! [this]
                    (let [cancel (fn [& _](.status! this "Bank Read Canceled"))
                          success (fn [_ f]
                                    (let [abs (.getAbsolutePath f)]
                                      (.push-undo-state! this "Open Bank")
                                      (if (.read-bank! bnk abs)
                                        (do
                                          (ss/config! lab-filename :text (format "Bank File : '%s'" abs))
                                          (.sync-ui! this)
                                          (.status! this (format "Read Bank File '%s'" abs)))
                                        (.warning! this (format "Can not open '%s' as %s bank"
                                                                abs (.data-format bnk))))))
                          default-file (ss/config lab-filename :text)
                          dia (seesaw.chooser/choose-file
                               :type (format "Open %s Bank" file-extension)
                               :dir default-file
                               :multi? false
                               :selection-mode :files-only
                               :filters [file-filter]
                               :remember-directory? true
                               :success-fn success
                               :cancel-fn cancel)]))
                  ) ;; end bank-ed

        create-instrument-editor (fn []
                                   (println ";; Creating instrument editor ...")
                                   (.working bank-ed true)
                                   (SwingUtilities/invokeLater
                                    (proxy [Runnable][]
                                      (run []
                                        (let [performance (.node @parent*)
                                              itype (.get-property performance :instrument-type)
                                              descriptor (.get-property performance :descriptor)
                                              ied (.create-editor descriptor performance)]
                                          (reset! instrument-editor* ied)
                                          (try
                                            (ss/show! (.widget ied :jframe))
                                            (catch NullPointerException ex
                                              (.warning! bank-ed "Instrument Editor not defined")))
                                          (.working bank-ed false))))))]
    (reset! program-bar* (progbar/program-bar bank-ed))
    (ss/config! pan-south :south pan-info)
    (.addListSelectionListener 
     lst-programs
     (proxy [ListSelectionListener][]
       (valueChanged [_]
         (cond
          (.getValueIsAdjusting lst-programs) ; do nothing
          nil

          @enable-list-selection-listener* ;; program-change
          (let [slot (.getSelectedIndex lst-programs)
                prg (.progressive-count bnk)]
            (if (and prg (pos? prg))
              (.recall-progressive bnk slot)
              (.recall bnk slot))
            ((:syncfn @program-bar*)))
         
          :default                      ; do nothing
          nil)))) 
                               
   
    (.sync-ui! bank-ed)
    bank-ed))
