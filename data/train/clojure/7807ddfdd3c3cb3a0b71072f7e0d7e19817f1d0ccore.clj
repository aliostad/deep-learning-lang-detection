(ns music.core)

(import 'javax.sound.midi.MidiSystem)

(def thread-collection (atom []))

(defn add-2-thread-collection [t]
  (swap! thread-collection (fn [v] (conj v t))))


(defn stop-all []
  (doseq [t @thread-collection] (.stop t) (reset! thread-collection [])))

(def synth (. MidiSystem getSynthesizer))

(. synth open)

(def mc (. synth getChannels))

(def instr (. (. synth getDefaultSoundbank) getInstruments))


;(def yy (. synth loadInstrument (aget instr 50)))

(defn play-midi-note [c f v] (. (aget mc c) noteOn f v))

(defn pause-play [ms] (Thread/sleep ms))

(defn note-on [c f v] (. (aget mc c) noteOn f v))
(defn note-off [c f] (. (aget mc c) noteOff f))

(defn play-line [midi-channel note-seq]
  (doseq [n note-seq]
    (play-midi-note midi-channel (:note n) (:velocity n))))  


(defn tune [f]
  (let [t (new Thread (fn [] (loop [] (f) (recur))))]
    (add-2-thread-collection t) (. t start)))







(def beats (fn [] (play-midi-note 9 38 1050) (Thread/sleep 100) (play-midi-note 9 42 1050) (Thread/sleep 100)))

(defn select-instrument [c i]
  (. (aget mc c) programChange (. (. (aget instr i) getPatch) getProgram)))

(def lead (fn [] (play-midi-note 0 40 550) (Thread/sleep 500)))
