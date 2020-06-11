;; settings
;; (Refactored for layering)
;;
;; Should:
;;  - Manage settings file
;;  - Store settings
;;  - Provide accessors for settings
;; 
;; Should not:
;;  - Interface with GUI components at all

(ns ajure.core.settings
  (:require (ajure.state [hooks :as hooks])
            (ajure.util [io :as io]
                        [info :as info]
                        [platform :as platform]))
  (:use ajure.util.other))

(def stored-settings-file-path (str platform/home-dir
                                    platform/file-separator
                                    "ajure-settings.clj"))

(defn load-settings! []
  (io!
   (io/create-empty-file-unless-exists! stored-settings-file-path)
   (let [content (io/read-text-file! stored-settings-file-path)]
     (when (str-not-empty? content)
       (let [loaded-object (read-string content)]
         (dosync
          (commute hooks/settings merge loaded-object)))))))

(defn save-settings! []
  (io!
   (io/write-text-file! stored-settings-file-path
                        (with-out-str
                          (println ";" info/application-name info/version-number-string)
                          (println "; Automatically generated file.  Modify with care.")
                          (println "{")
                          (doseq [pair @hooks/settings]
                            (pr (key pair) (val pair))
                            (println))
                          (println "}")))))