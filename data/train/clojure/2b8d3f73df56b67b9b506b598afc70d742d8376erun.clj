(ns calabash-script.clj.run
  (:require [clojure.java.io :as io]))


(def trace-template "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate")

(defn run-test
  "Launch UIA via instruments."
  [& kwargs]
  (let [options (apply hash-map kwargs)
        udid (:udid options)
        app-id-or-path (:app options)
        script (:test options)
        instruments-udid (if udid ["-w" udid] [])
        instruments-cmd (apply conj
                               ["instruments"]
                               (conj instruments-udid
                                     "-t" trace-template
                                     app-id-or-path
                                     "-D" "run/trace"
                                     "-e" "UIARESULTSPATH" "run"
                                     "-e" "UIASCRIPT"
                                     script))]

    (println instruments-cmd)
    (let [process (.start (ProcessBuilder. instruments-cmd))]
      {:input (io/reader (.getInputStream process))
       :process process})))
