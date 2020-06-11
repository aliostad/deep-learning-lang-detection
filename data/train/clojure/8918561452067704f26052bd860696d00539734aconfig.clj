(ns cadejo.config
  (:require [cadejo.util.user-message :as umsg])
  (:require [cadejo.util.col :as ucol])
  (:require [cadejo.util.path :as path])
  (:require [cadejo.util.midi])
  (:import org.pushingpixels.substance.api.SubstanceLookAndFeel))

(def ^:private +VERSION+ "0.4.1")

(def ^:private available-skins (map str (keys (SubstanceLookAndFeel/getAllSkins))))

(def splash-frame* (atom nil))


(defprotocol CadejoConfig

  (version 
    [this]
    "Returns Cadejo version as string")
  
  (channel-count 
    [this]
    "Returns number of MIDI channels (16)")
  
  (midi-input-ports 
    [this]
    "Returns list of available MIDI input ports
    Note that (at least for the moment, 2014.08.15) MIDI ports are extracted
    from the JVM which is not Jack aware")

  (midi-input-port
    [this n]
    "Return the nth MIDI input device")

  (load-gui 
    [this]
    "Returns Boolean indicating if GUI components are to be used.")

  (load-gui!
    [this flag]
    "Sets flag indicating whether GUI components are to be use are not.")

  (initial-skin 
    [this]
    "Return string, the name of initial-skin.")

  (initial-skin!
    [this skin-name]
    "Set initial-skin
     skin-name - string")

  (current-skin
    [this]
    "Used internally")

  (current-skin!
    [this skin-name]
    "Used internally")

  (displaybar-style! [this sty])

  (displaybar-style [this])

  (enable-pp
    [this]
    "Return flag, if true pretty-printer hook is executed on MIDI program 
     change")

  (enable-pp!
    [this flag]
    "Enable/disable pretty-printer hook on MIDI program change")

  (maximum-undo-count 
    [this]
    "Returns maximum depth of undo/redo operations")

  (maximum-undo-count!
    [this n]
    "Sets maximum depth of undo/redo operations")

  (warn-on-exit
    [this])

  (warn-on-exit!
    [this flag])

  (warn-on-file-overwrite
    [this]
    "Returns Boolean indicating that a warning is to be displayed whenever 
    a file is about to be overwritten")

  (warn-on-file-overwrite!
    [this flag]
    "Sets overwrite warning status")

  (warn-on-unsaved-data
    [this])

  (warn-on-unsaved-data!
    [this flag])

  (enable-tooltips
    [this]
    "Returns flag indicating that GUI tooltips are to be used.
     Tooltips are automatically enabled if button text is disabled.")

  (enable-tooltips!
    [this flag])

  (enable-button-text
    [this]
    "Returns flag indicating if button text is enabled.
     Button text is automatically enabled if icons are disabled.")

  (enable-button-text!
    [this flag])

  (enable-button-icons
    [this]
    "Returns flag indicating if button icons are enabled.")

  (enable-button-icons!
    [this flag])

  (config-path 
    [this]
    "Returns file-system path to Cadejo configuration directory.
     The default directory is $home/.cadejo")

  (config-path!
    [this path]
    "Change path to configuration directory.")

  (add-instrument! 
    [this descriptor]
    "Adds InstrumentDescriptor to the list of available instruments.")

  (instruments
    [this]
    "Returns list of available instruments")

  (instrument-descriptor 
    [this iname]
    "Return specific InstrumentDescriptor for iname
    If no such descriptor exist display warning and return nil")

  (create-instrument 
    [this iname mode args]
    "Create instance of instrument and link it into a Cadejo process tree.")
  )


(defn cadejo-config []
  (let [input-ports* (atom [])
        load-gui* (atom false)
        initial-skin* (atom "Dust")
        current-skin* (atom "Dust")
        enable-pp* (atom true)
        max-undo-count* (atom 10)
        exit-warn* (atom true)
        overwrite-warn* (atom true)
        unsaved-warn* (atom true)
        displaybar-style* (atom nil)
        enable-tooltips* (atom true)
        enable-button-text* (atom true)
        enable-button-icons* (atom false)
        config-path* (atom nil)
        instruments* (atom nil)
        cnfig (reify CadejoConfig
                
                (version [this] +VERSION+)

                (channel-count [this] 16)

                (midi-input-ports [this]
                  (cadejo.util.midi/transmitters))

                (midi-input-port [this n]
                  (let [tlst (.midi-input-ports this)]
                    (if (< n (count tlst))
                      (nth tlst n)
                      (umsg/warning "CadejoConfig.midi-input-port"
                                    (format "IndexdOutOfBounds %s" n)))))

                (load-gui [this] @load-gui*)

                (load-gui! [this flag]
                  (reset! load-gui* flag))

                (initial-skin [this] @initial-skin*)

                (initial-skin! [this skin-name]
                  (reset! current-skin* skin-name)
                  (reset! initial-skin* skin-name))
                
                (current-skin [this] @current-skin*)

                (current-skin! [this skin-name]
                  (reset! current-skin* skin-name))

                (displaybar-style! [this sty]
                  (let [s (if (ucol/member? sty [nil :matrix :sixteen :twilight :basic])
                            sty
                            (umsg/warning (format "Invalid config displaybar-style %s  Using default." sty)))]
                    (reset! displaybar-style* s)))

                (displaybar-style [this]
                  @displaybar-style*)

                (enable-pp [this] @enable-pp*)

                (enable-pp! [this flag]
                  (reset! enable-pp* flag))

                (maximum-undo-count [this]
                  @max-undo-count*)

                (maximum-undo-count! [this n]
                  (reset! max-undo-count* (int n)))
                
                (warn-on-exit [this]
                  @exit-warn*)

                (warn-on-exit! [this flag]
                  (reset! exit-warn* flag))

                (warn-on-file-overwrite [this]
                  @overwrite-warn*)

                (warn-on-file-overwrite! [this flag]
                  (reset! overwrite-warn* flag))

                (warn-on-unsaved-data [this]
                  @unsaved-warn*)

                (warn-on-unsaved-data! [this flag]
                  (reset! unsaved-warn* flag))

                (enable-tooltips [this]
                  (or @enable-tooltips*
                      (not (.enable-button-text this))))

                (enable-tooltips! [this flag]
                  (reset! enable-tooltips* flag))
                
                (enable-button-text [this]
                  (or @enable-button-text*
                      (not (.enable-button-icons this))))

                (enable-button-text! [this flag]
                  (reset! enable-button-text* flag))

                (enable-button-icons [this]
                  @enable-button-icons*)

                (enable-button-icons! [this flag]
                  (reset! enable-button-icons* flag))

                (config-path[this]
                  @config-path*)

                (config-path! [this p]
                  (reset! config-path* p))
         
                (add-instrument! [this descriptor]
                  (swap! instruments* (fn [n](assoc n
                                               (keyword (.instrument-name descriptor))
                                               descriptor))))
                (instruments [this]
                  (keys @instruments*))

                (instrument-descriptor [this iname]
                  (let [key (keyword iname)]
                    (or (get @instruments* key)
                        (umsg/warning (format "Instrument %s not defined" iname)))))

                (create-instrument [this iname mode args]
                  (let [ides (.instrument-descriptor this iname)]
                    (if ides
                      (let [s (first args)
                            sed (and (.load-gui this)(.get-editor s))]
                        (.create ides mode args)
                        (if sed (.sync-ui! sed))
                        s)))) )]


    (.config-path! cnfig (let [p (System/getProperties)
                               h (.getProperty p "user.home")]
                           (path/join h "cadejoConfig")))
    cnfig))



                
(def ^:private current-config* (atom (cadejo-config)))

(defn set-config! [this cnfg]
  (reset! current-config* cnfg))

(defn cadejo-version []
  (.version @current-config*))

(defn channel-count [] 
  (.channel-count @current-config*))

(defn midi-input-ports []
  (.midi-input-ports @current-config*))

(defn midi-input-port [n]
  (.midi-input-port @current-config* n))

(defn load-gui []
  (.load-gui @current-config*))

(defn load-gui! [flag]
  (.load-gui! @current-config* flag))

(defn initial-skin []
  (.initial-skin @current-config*))

(defn initial-skin! [skin-name]
  (.initial-skin! @current-config* skin-name))

(defn current-skin []
  (.current-skin @current-config*))

(defn current-skin! [skin-name]
  (.current-skin! @current-config* skin-name))

(defn displaybar-style! [sty] 
  (.displaybar-style! @current-config* sty))

(defn displaybar-style [] 
  (.displaybar-style @current-config*))

(defn enable-pp []
  (.enable-pp @current-config*))

(defn enable-pp! [flag]
  (.enable-pp! @current-config* flag))

(defn maximum-undo-count []
  (.maximum-undo-count @current-config*))

(defn maximum-undo-count! [n]
  (.maximum-undo-count! @current-config* n))

(defn warn-on-exit []
  (.warn-on-exit @current-config*))

(defn warn-on-exit! [flag]
  (.warn-on-exit! @current-config* flag))

(defn warn-on-file-overwrite []
  (.warn-on-file-overwrite @current-config*))

(defn warn-on-file-overwrite! [flag]
  (.warn-on-file-overwrite! @current-config* flag))

(defn warn-on-unsaved-data []
  (.warn-on-unsaved-data @current-config*))

(defn warn-on-unsaved-data! [flag]
  (.warn-on-unsaved-data! @current-config* flag))

(defn enable-tooltips []
  (.enable-tooltips @current-config*))

(defn enable-tooltips! [flag]
  (.enable-tooltips! @current-config* flag))

(defn enable-button-text []
  (.enable-button-text @current-config*))

(defn enable-button-text! [flag]
  (.enable-button-text! @current-config* flag))

(defn enable-button-icons []
  (.enable-button-icons @current-config*))

(defn enable-button-icons! [flag]
  (.enable-button-icons! @current-config* flag))

(defn config-path []
  (.config-path @current-config*))

(defn config-path! [p]
  (.config-path! @current-config* p))

(defn add-instrument! [descriptor]
  (.add-instrument! @current-config* descriptor))

(defn instruments []
  (.instruments @current-config*))

(defn instrument-descriptor [iname]
  (.instrument-descriptor @current-config* iname))

(defn create-instrument [iname mode & args]
  (.create-instrument @current-config* iname mode args))


; ---------------------------------------------------------------------- 
;                               Set Defaults
;
; Available Skins (case sensitive)
; "Autumn"
; "Business"
; "Business Black Steel"
; "Business Blue Steel"
; "Cerulean"
; "Challenger Deep"
; "Creme"
; "Creme Coffee"
; "Dust"
; "Dust Coffee"
; "Emerald Dusk"
; "Gemini"
; "Graphite"
; "Graphite Aqua"
; "Graphite Glass"
; "Magellan"
; "Mariner"
; "Mist Aqua"
; "Mist Silver"
; "Moderate"
; "Nebula"
; "Nebula Brick Wall"
; "Office Black 2007"
; "Office Blue 2007"
; "Office Silver 2007"
; "Raven"
; "Sahara"
; "Twilight"

(load-gui! true)
(initial-skin! "Twilight")
(displaybar-style! nil)    ; nil -> use lnf
(enable-pp! false)
(maximum-undo-count! 10)
(warn-on-exit! true)
(warn-on-file-overwrite! true)
(warn-on-unsaved-data! true)  ;; ISSUE not honored
(enable-tooltips! true)
(enable-button-text! true)
(enable-button-icons! true)
