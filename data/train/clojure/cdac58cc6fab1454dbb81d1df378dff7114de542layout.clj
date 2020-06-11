(ns layout
  (:import
    [AvalonDock.Layout.Serialization XmlLayoutSerializer]
    [System.IO StreamWriter StreamReader])
  (:require 
    [wpf]))


(defn save-layout []
  (let [dockingManager (.FindName (wpf/get-app-main-window) "dockingManager")
        serializer (XmlLayoutSerializer. dockingManager)
        filename "layout.xml"
        stream (StreamWriter. filename)]
    (. serializer Serialize stream)
    (. stream Close)))

(defn load-layout []
  (let [dockingManager (.FindName (wpf/get-app-main-window) "dockingManager")
        serializer (XmlLayoutSerializer. dockingManager)
        filename "layout.xml"
        stream (StreamReader. filename)]
    (. serializer Deserialize stream)
    (. stream Close)))

(defn init []
  #_(load-layout)
  )

(prn "layout loaded")
