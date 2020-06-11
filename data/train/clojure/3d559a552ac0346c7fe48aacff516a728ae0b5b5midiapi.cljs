(ns alder.audio.midiapi)

(defn alder-ns-obj []
  (aget js/window "Alder"))

(defn midi-dispatch-obj []
  (aget (alder-ns-obj) "MIDIDispatch"))

(defn has-midi-access []
  (boolean (aget js/navigator "requestMIDIAccess")))

(defn request-midi-access []
  (.call (aget js/navigator "requestMIDIAccess") js/navigator))

(defn add-midi-message-event-listener [device token callback]
  (.call (aget (midi-dispatch-obj) "addMIDIMessageEventListener")
         (midi-dispatch-obj)
         device
         token
         callback))

(defn remove-midi-message-event-listener [device token]
  (.call (aget (midi-dispatch-obj) "removeMIDIMessageEventListener")
         (midi-dispatch-obj)
         device
         token))

(defn midi-master-device []
  (aget (midi-dispatch-obj) "masterDevice"))

(defn get-current-midi-master-device []
  (.call (aget (midi-dispatch-obj) "currentMasterDevice")
         (midi-dispatch-obj)))

(defn set-current-midi-master-device! [device]
  (.call (aget (midi-dispatch-obj) "currentMasterDevice")
         (midi-dispatch-obj)
         device))

(defn node-device [node]
  (.call (aget node "device") node))

(defn event-data [event]
  (aget event "data"))

(defn emit-midi-master-device-event [e]
  (.call (aget (midi-dispatch-obj) "onMIDIMessage")
         (midi-dispatch-obj)
         (midi-master-device)
         (clj->js e)))
