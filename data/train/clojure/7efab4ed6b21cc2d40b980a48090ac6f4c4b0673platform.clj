;; ajure.util.platform
;;
;; Should:
;;  - Manage any OS-level or platform-level differences

(ns ajure.util.platform
  (:import (org.eclipse.swt SWT)
           (org.eclipse.swt.widgets Display)
           (org.eclipse.swt.graphics Font FontData))
  (:use ajure.util.other))

(def is-mac-os
     (not= (System/getProperty "mrj.version") nil))

(def is-windows-os
     (.startsWith (System/getProperty "os.name") "Windows"))

;;  mod    win    mac
;;  ---    ---    ---
;;   1      C     Cmd
;;   2      S      S
;;   3      A      A
;;   4     ???     C
(def mod1-string
  (if is-mac-os "\u2318" "Ctrl+"))
(def mod2-string
  (if is-mac-os "\u21e7" "Shift+"))
(def mod3-string
  (if is-mac-os "\u2325" "Alt+"))

(def ctrl-string
  (if is-mac-os "\u2303" "Ctrl+"))
(def alt-string
  (if is-mac-os "\u2325" "Alt+"))
(def shift-string
  (if is-mac-os "\u21e7" "Shift+"))
(def command-string
  (if is-mac-os "\u2318" "\u2318"))

(def home-dir
  (System/getProperty "user.home"))
(def file-separator
  (System/getProperty "file.separator"))

(defn get-default-font-data []
  (cond
    is-mac-os 
      (FontData. "Monaco" 12 SWT/NORMAL)
    is-windows-os 
      (FontData. "Courier New" 12 SWT/NORMAL)
    :else
      (first (.. Display getDefault getSystemFont getFontData))))