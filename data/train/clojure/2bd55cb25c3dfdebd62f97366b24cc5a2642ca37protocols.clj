(ns jjamppong.protocols
  (:refer-clojure :exclude [load]))

;;TODO(kep): need to manage this
(defonce +ONCE+ (javafx.embed.swing.JFXPanel.))

(defprotocol IWatcher
  (run [this])
  (stop [this]))

(defprotocol IMainWindow
  (init [this])
  (get-table [this])
  (update-predicate [this filter-list])
  (load [this fpath])
  (update-status-message [this message])
  )

(definterface IMainWindowFX
  (close [])
  (^{:tag void} on_btn_scan [^javafx.event.ActionEvent event])
  (^{:tag void} on_btn_start [^javafx.event.ActionEvent event])
  (^{:tag void} on_btn_clear [^javafx.event.ActionEvent event])
  (^{:tag void} on_btn_stop [^javafx.event.ActionEvent event])
  (^{:tag void} on_btn_filter [^javafx.event.ActionEvent event])

  (^{:tag void} on_check_lvl [^javafx.event.ActionEvent event])
  (^{:tag void} on_txt_filter_changed [^javafx.scene.input.KeyEvent event])
  (^{:tag void} on_check_ignorecase [^javafx.event.ActionEvent event])
  (^{:tag void} on_check_regex [^javafx.event.ActionEvent event])
  )

(definterface ItmHighlightFX
  (update1 [item])
  (^{:tag void} on_check [^javafx.event.ActionEvent event])
  )

(definterface IHighlightWindowFX
  (hello [])
  (^{:tag void} on_btn_new [^javafx.event.ActionEvent event])
  (^{:tag void} on_btn_remove [^javafx.event.ActionEvent event])
  (^{:tag void} on_btn_up [^javafx.event.ActionEvent event])
  (^{:tag void} on_btn_down [^javafx.event.ActionEvent event])
  )


(defrecord FilterItem
    [is-selected
     filter-string
     color-background
     color-foreground
     is-regex])
