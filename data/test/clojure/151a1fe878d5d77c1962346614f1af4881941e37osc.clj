(ns composer.osc
  (:require [overtone.osc :as osc]
            [clojure.core.async :refer [go >! <! chan put! close!]]))

(def ^:private toggle->scale
  {"/1/multitoggle1/1/1" :major-scale
   "/1/multitoggle1/1/2" :harmonic-minor-scale
   "/1/multitoggle1/1/3" :natural-minor-scale
   "/1/multitoggle1/1/4" :locrian-mode
   "/1/multitoggle1/1/5" :mixolydian-mode})

(def ^:private toggle->key
  {"/1/toggle1"  :C3
   "/1/toggle8"  :C#3
   "/1/toggle2"  :D3
   "/1/toggle9"  :D#3
   "/1/toggle3"  :E3
   "/1/toggle4"  :F3
   "/1/toggle10" :F#3
   "/1/toggle5"  :G3
   "/1/toggle11" :G#3
   "/1/toggle6"  :A3
   "/1/toggle12" :A#3
   "/1/toggle7"  :B3})

(def ^:private toggle->cadence
  {"/1/multitoggle2/1/1" :perfect
   "/1/multitoggle2/1/2" :plagal
   "/1/multitoggle2/1/3" :just-nice})

(defn instrument-state->osc-updates
  "Returns the OSC events for bringing an OSC device in sync with
  instrument-state."
  [instrument-state]
  (println instrument-state)
  (concat
   (for [[path key] toggle->key]
     [path (float (if (= key (:key instrument-state)) 1.0 0.0))])
   (for [[path scale] toggle->scale]
     [path (float (if (= scale (:scale instrument-state)) 1.0 0.0))])
   (for [[path key] toggle->cadence]
     [path (float (if (= key (:cadence instrument-state)) 1.0 0.0))])
   (for [gap (range 9)]
     [(str "/3/multifader2/" gap) (get-in instrument-state [:gaps gap] 0.5)])))

(defn- instrument-state-loop
  [instrument-state-ch connected-clients shutdown]
  (go
   (loop []
     (if-let [instrument-state (<! instrument-state-ch)]
       (do
         (doseq [[_ client] @connected-clients]
           (doseq [[path value] (instrument-state->osc-updates
                                 instrument-state)]
             (osc/osc-send client path value)))
         (recur))
       (shutdown)))))

(defn- add-touchosc-client
  [clients host]
  (if (get clients host)
    clients
    (assoc clients host (osc/osc-client host 9000))))

(defn start
  "Closes when instument-state-ch is closed."
  [port alias out-ch instrument-state-ch]
  (let [server (osc/osc-server port alias)
        connected-clients (atom {})
        register-client! (fn [msg]
                           (swap!
                            connected-clients
                            add-touchosc-client
                            (:src-host msg)))]
    (doseq [[path key] toggle->key]
      (osc/osc-handle
       server path
       (fn [msg]
         (put! out-ch [:key key])
         (register-client! msg))))
    (doseq [[path scale] toggle->scale]
      (osc/osc-handle
       server path
       (fn [msg]
         (put! out-ch [:scale scale])
         (register-client! msg))))
    (doseq [[path cadence] toggle->cadence]
      (osc/osc-handle
       server path
       (fn [msg]
         (put! out-ch [:cadence cadence])
         (register-client! msg))))
    (doseq [gap (range 9)]
      (osc/osc-handle
       server (str "/3/multifader2/" gap)
       (fn [msg]
         (put! out-ch [:gap gap (-> msg :args first)])
         (register-client! msg))))
    (osc/osc-handle
     server "/3/fader3"
     (fn [msg]
       (put! out-ch [:speed (-> msg :args first)])
       (register-client! msg)))
    (osc/osc-listen server
                    (fn [msg]
                      (println "osc" msg)
                      (register-client! msg)))
    (osc/zero-conf-on)
    (instrument-state-loop
     instrument-state-ch
     connected-clients
     (fn shutdown
       []
       (osc/zero-conf-off)
       (osc/osc-close server)))))
