(ns mozart.synth
  (:require [mozart.audio :as audio]
            [mozart.graph :as graph]))

;; Notes
;; =====

(defn note->freq
  "Converts a music MIDI note number to it's frequency"
  ([note] (note->freq note 440))
  ([note tuning]
   (* (/ tuning 32) (Math/pow 2 (/ (- note 9) 12)))))

;; Voices
;; ======

(defrecord Voice [vco vca]
  audio/IConnectable
  (connect* [this to]
    (audio/connect vca to)
    this))

(defn voice [ctx freq type]
  (let [vco (doto (audio/oscillator ctx type)
              (-> .-frequency (.setValueAtTime freq 0)))
        vca (audio/gain ctx 0)]
    (audio/connect {} vco vca)
    (->Voice vco vca)))

(defn start-voice [voice at env]
  (let [voice (update voice :vco audio/start at)]
    (if env (audio/trigger-on env (.-gain (:vca voice)) at))
    voice))

(defn stop-voice [voice at env]
  (if env (audio/trigger-off env (.-gain (:vca voice)) at))
  (update voice :vco audio/stop (+ at (-> env :r) 0.1)))

(defrecord Oscillator [type detune output]
  audio/IConnectable
  (connect* [this to]
    (assoc this :output to)))

(defn oscillator [type]
  (map->Oscillator {:type type}))

(defn start-osc
  "Creates a new oscillator voice, connects it to its output and returns it."
  [osc freq at env]
  (if-let [output (-> osc :output)]
    (let [voice (voice (.-context output) freq (:type osc))]
      (audio/connect voice (:output osc))
      (start-voice voice at env))
    (.error js/console "Synth Oscillators must be connected to an
    output before running.")))

;; A domain model for a playable instrument. The instrument will keep
;; track of it's voices and vca and can be connected to the rest of
;; the audio graph.
(defrecord Instrument [ctx vcos envelopes vca voices graph]
  audio/IConnectable
  (connect* [this to]
    (audio/connect vca to)))

(defn instrument
  "Returns a connectable Instrument node"
  [ctx] (map->Instrument {:ctx ctx
                          :vca (audio/gain ctx)}))

(defn- find-envelope-for-node
  "Looks through the connection graph and finds the envelope that's connected to that node"
  [inst node]
  (first
    (filter
      #(graph/connected? (:graph inst) % node)
      (:envelopes inst))))

(defn note-on
  "Creates and starts a vco for the given type and frequency. Returns
  a new instrument with that playing vco."
  ([inst note] (note-on inst note 0))
  ([inst note at]
   (if-not (get-in inst [:voices note])
     (let [time (+ at (-> inst :ctx audio/current-time))
           freq (note->freq note)
           voices (doall (map
                           (fn [osc]
                             [osc (start-osc osc freq time
                                    (find-envelope-for-node inst osc))])
                           (:vcos inst)))]
       (assoc-in inst [:voices note] voices))
     inst)))

(defn note-off
  "Stops the vco, returns a new instrument without the vco node."
  ([inst note] (note-off inst note (-> inst :vca .-context audio/current-time)))
  ([inst note at]
   (when-let [voices (get-in inst [:voices note])]
     (doall
       (for [[osc voice] voices]
         (stop-voice voice at (find-envelope-for-node inst osc)))))
   (update inst :voices dissoc note)))

(defn play!
  "Play a note on the instrument for the given duration"
  [inst note at duration]
  (let [time (-> inst :ctx audio/current-time)]
    (-> inst
      (note-on note (+ time at))
      (note-off note (+ time at duration)))))

(defn plug
  "Makes an internal connection between two nodes"
  [inst node1 node2]
  (update inst :graph audio/connect node1 node2))

(defn add-osc
  "Adds an oscillator to the synths vco's and connects it to the vca"
  [inst osc]
  (let [osc (audio/connect* osc (:vca inst))
        graph (audio/connect (:graph inst) osc (:vca inst))]
    (-> (assoc inst :graph graph)
      (update :vcos conj osc))))

(defn add-env
  "Adds an envelope record to the synth"
  [inst env]
  (update inst :envelopes conj env))
