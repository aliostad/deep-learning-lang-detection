(println "--> cadejo.ui.instruments.instrument-editor")

(ns cadejo.ui.instruments.instrument-editor
  (:require [cadejo.config :as config])
  (:require [cadejo.util.path :as path])
  (:require [cadejo.ui.instruments.program-name-editor])
  (:require [cadejo.ui.instruments.subedit])
  (:require [cadejo.ui.util.factory :as factory])
  (:require [cadejo.ui.util.help])
  (:require [cadejo.ui.util.lnf :as lnf])
  (:require [cadejo.util.user-message :as umsg])
  (:use [cadejo.ui.util.overwrite-warning :only [overwrite-warning]])
  (:require [seesaw.core :as ss])
  (:require [seesaw.chooser :as ssc])
  (:import java.io.File
           java.io.FileNotFoundException
           javax.swing.JFileChooser
           javax.swing.Box))

(def all-file-filter (ssc/file-filter
                      "All Files" (constantly true)))

(defn- save-program [ied jfc dform ext program data]
  (let [file (.getSelectedFile jfc)
        filename (path/replace-extension 
                  (.getAbsolutePath file) ext) 
        pan-main (.widget ied :pan-main)
        pout (assoc (.to-map program)
               :file-type :cadejo-program
               :data-format dform)]
    (if (overwrite-warning pan-main "Program" filename)
      (try
        (spit filename (pr-str pout))
        (.status! ied (format "Saved '%s'" filename))
        filename
        (catch FileNotFoundException e
          (umsg/warning "FileNotFoundException"
                        "instrument-editor/save-program"
                        (str filename))
          (.warning! ied "Can not write file '%s'" filename)
          nil))
      (do 
        (.status! ied "Save Canceled")
        nil))))

(defn- open-program [ied jfc dform ext]
  (let [file (.getSelectedFile jfc)
        filename (path/replace-extension 
                  (.getAbsolutePath file) ext)
        rec (try
              (read-string (slurp filename))
              (catch FileNotFoundException e
                nil))]
    (if (and rec 
             (= (:file-type rec) :cadejo-program)
             (= (:data-format rec) dform))
      (dissoc rec :file-type :data-format)
      nil)))

(defprotocol InstrumentEditor

  (parent-performance
    [this])

  (parent-bank
    [this])

  (add-sub-editor!
    [this text icon-main icon-sub tooltip subed])

  (enable!
    [this flag])
  
  (show-card-number!
    [this n])

  (current-program 
    [this]
    "Returns current bank program")

  (current-data
    [this]
    "Returns current bank data")

  (program->clipboard
    [this]
    "Stores current program into clipboard")

  (clipboard->program!
    [this]
    "Sets clipboard contents as bank current program")

  (set-param!
    [this param value])

  (widgets
    [this])

  (widget
    [this key])

  (status!
    [this msg])

  (warning! 
    [this msg])

  (working
    [this flag])
  
  (init!
    [this]
    "Initialize current program")

  (random-program!
    [this]
    "Generate random program")

  (sync-ui!
    [this]))

(defn instrument-editor [performance]
  (let [itype (.get-property performance :instrument-type)
        parent-editor (.get-editor performance)
        id (.get-property performance :id)
        descriptor (config/instrument-descriptor itype)
        clipboard* (.clipboard descriptor)
        current-directory* (atom (config/config-path))
        bank (.bank performance)
        file-extension (format "%s_program"
                               (.toLowerCase (name (.data-format bank))))
        program-file-filter (ssc/file-filter
                             (format "%s Program File" (name itype))
                             (fn [f]
                               (path/has-extension? (.getAbsolutePath f)
                                                    file-extension)))
        ;; North toolbar
        ;;
        jb-init (factory/button "Init" :general :reset "Initialize program")
        jb-dice (factory/button "Random" :general :dice "Create random program")
        jb-copy (factory/button "Copy" :general :copy "Copy program data to clipboard")
        jb-paste (factory/button "Paste" :general :paste "Paste clipboard data to program")
        jb-open (factory/button "Open" :general :open "Open program file")
        jb-save (factory/button "Save" :general :save "Save program file")
        jb-help (factory/button "Help" :general :help "Program editor help")
        pan-north (ss/toolbar :floatable? false
                              :items [jb-init jb-dice
                                      :separator jb-open jb-save
                                      :separator jb-copy jb-paste
                                      :separator jb-help :separator
                                      (Box/createHorizontalStrut 32)]
                              :border (factory/padding))
       
        sub-editors* (atom [])
        card-buttons* (atom [])
        pan-cards (ss/card-panel
                   :border (factory/padding))
        group-cards (ss/button-group)
        current-card* (atom nil)

        ;; Main panel
        pan-main (ss/border-panel :north pan-north
                                  :center pan-cards
                                  )
        jframe (ss/frame :title (format "%s Editor" (name id))
                         :content pan-main
                         :on-close :hide
                         :size [1050 :by 650]
                         :icon (.logo descriptor :tiny))
        widget-map {:jb-help jb-help
                    :pan-main pan-main
                    :pan-cards pan-cards
                    :jframe jframe}
        ied (reify InstrumentEditor
              
              (parent-performance [this] performance)
              
              (parent-bank [this]
                (.bank performance))

              (add-sub-editor! [this text icon-main icon-sub tooltip subed]
                (swap! sub-editors* (fn [n](conj n subed)))
                (reset! current-card* subed)
                (let [tb (factory/toggle text icon-main icon-sub tooltip group-cards)]
                  (swap! card-buttons* (fn [q](conj q tb)))
                  (.putClientProperty tb :id text)
                  (.putClientProperty tb :editor subed)
                  (.add pan-north tb)
                  (.add pan-cards (.widget subed :pan-main) text)
                  (.parent! subed this)
                  (ss/listen tb :action
                             (fn [ev]
                               (let [src (.getSource ev)
                                     id (.getClientProperty src :id)
                                     ed (.getClientProperty src :editor)]
                                 (ss/show-card! pan-cards id)
                                 (reset! current-card* ed)
                                 (.sync-ui! ed))))))

              (enable! [this flag]
                (if flag
                  (doseq [b @card-buttons*]
                    (.setVisible b true))
                  (do 
                    (doseq [b @card-buttons*]
                      (.setVisible b false))
                    (.show-card-number! this 0)))
                (.revalidate jframe))
              
              (show-card-number! [this n]
                (let [tb (nth @card-buttons* n)
                      id (.getClientProperty tb :id)]
                  (ss/show-card! pan-cards id)
                  (ss/config! tb :selected? true)
                  (.sync-ui! (.getClientProperty tb :editor))))

              (current-program [this]
                (.current-program bank))

              (current-data [this]
                (.current-data bank))

              (program->clipboard [this]
                (let [prog (.current-program this)]
                  (reset! clipboard* prog)
                  (.setEnabled jb-paste true)
                  (.status! this "Program copied to clipboard")))
              
              (clipboard->program! [this]
                (let [prog @clipboard*]
                  (if prog
                    (do
                      (.current-program! bank prog)
                      (.sync-ui! this)
                      (.status! this "Program pasted from clipboard"))
                    (.warning! this "Clipboard empty"))))

              (set-param! [this param value]
                (.status! this (format "[%-16s] --> %s" param value))
                (.set-param! bank param value))

              (widgets [this] widget-map)

              (widget [this key]
                (or (get widget-map key)
                    (umsg/warning (format "InstrumentEditor does not have %s widget" key))))

              (status! [this msg]
                (.status! parent-editor msg))

              (warning! [this msg]
                (.warning! parent-editor msg))

              (working [this flag]
                (.working parent-editor flag))
    
              (init! [this]
                (let [prog (.clone (.initial-program descriptor))
                      bank (.parent-bank this)]
                  (.current-program! bank prog)
                  (.sync-ui! this)
                  (.status! this "Initialized program")))

              (random-program! [this]
                (let [prog (.random-program descriptor)
                      bank (.parent-bank this)
                      pp (.pp-hook bank)]
                  (if prog
                    (do
                      (.current-program! bank prog)
                      (.modified! bank true)
                      (if (and pp (config/enable-pp))
                        (println (pp -1 "Random" (.data prog) "")))
                      (.sync-ui! this)
                      (.status! this "Random Program")))))

              (sync-ui! [this]
                (let [prog (.current-program bank)
                      data (and prog (.data prog))
                      bnk (.bank performance)
                      progressive (.progressive-count bnk)]
                  (if progressive
                    (.enable! this false)
                    (do
                      (.enable! this true)
                      (if data
                        (.sync-ui! @current-card*))))))
                
              ) ;; end ied

        data-editor (cadejo.ui.instruments.program-name-editor/program-name-editor ied)]

    (.add-sub-editor! ied "Common" :edit :text "Edit program data" data-editor)
 
    (ss/listen jb-init :action (fn [_](.init! ied)))

    (ss/listen jb-dice :action (fn [_](.random-program! ied)))

    (ss/listen jb-copy :action 
               (fn [_](.program->clipboard ied)))

    (ss/listen jb-paste :action
               (fn [_](.clipboard->program! ied)))

    (ss/listen jb-open :action
               (fn [_]
                 (let [jfc (JFileChooser. @current-directory*)]
                   (.setDialogTitle jfc (format "Open %s Program"
                                                (name itype)))
                   (.addChoosableFileFilter jfc all-file-filter)
                   (.addChoosableFileFilter jfc program-file-filter)
                   (let [rs (.showOpenDialog jfc (.widget ied :pan-main))]
                     (cond (= rs JFileChooser/CANCEL_OPTION)
                           (.status! ied "Open Canceled")
                           
                           (= rs JFileChooser/APPROVE_OPTION)
                           (let [prog (open-program ied jfc itype
                                                    file-extension)]
                             (if prog
                               (do 
                                 (.current-program! bank (:name prog)(:remarks prog)(:data prog))
                                 (.sync-ui! ied)
                                 (.pp ied)
                                 (.status! ied (format "Opened %s"
                                                       (name (:name prog)))))
                               (do
                                 (umsg/warning
                                  "Can not read '%s' as %s program file"
                                  (.getSelectedFile jfc) itype)
                                 (.warning! ied
                                            "Can not read program file"))))
                           
                           :default ;; should never see this
                           (do
                             (umsg/warning "InstrumentEditor jb-save action"
                                           "default cond executed")
                             (.warning! ied "Unknown open error")))) )))

    (ss/listen jb-save :action
               (fn [_]
                 (let [pname (ss/config (.widget data-editor :txt-name) :text)
                       default-file (path/append-extension pname
                                                           file-extension)
                       jfc (JFileChooser. @current-directory*)]
                   (.setDialogTitle jfc (format "Save %s Program"
                                                (name itype)))
                   (.addChoosableFileFilter jfc all-file-filter)
                   (.addChoosableFileFilter jfc program-file-filter)
                   (.setSelectedFile jfc (File. default-file))
                   (let [rs (.showSaveDialog jfc (.widget ied :pan-main))]
                     (cond (= rs JFileChooser/CANCEL_OPTION)
                           (.status! ied "Save Canceled")
    
                           (= rs JFileChooser/APPROVE_OPTION)
                           (let [rs (save-program ied jfc itype file-extension
                                                  (.current-program bank)
                                                  (.current-data bank))]
                             (if rs
                               (reset! current-directory*
                                       (apply path/join 
                                              (butlast (path/split rs))))))
                          
                           :default ;; Should only see this on error
                           (do
                             (umsg/warning "InstrumentEditor jb-save action"
                                           "default cond executed")
                             (.warning! ied "Unknown save error")))))))
    (.putClientProperty jb-help :topic (.help-topic descriptor))
    ;(ss/listen jb-help :action cadejo.ui.util.help/help-listener)
    ied))
                
                      
