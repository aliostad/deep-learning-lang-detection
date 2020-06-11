(ns pietro.midi
  (:import [java.io ByteArrayOutputStream File]
           [javax.sound.midi MidiSystem Sequencer ShortMessage SysexMessage])
  (:use pietro.tuning))

(defn base-key
  [freq]
  (->> (map #(- freq %) standard-freqs)
       (take-while (comp not neg?))
       count
       dec))

(defn cents->byte-vec
  [cents]
  (let [tuning (int (/ (* cents 16384) 100))
        byte-1 (bit-and (bit-shift-right tuning 7) 0x7f)
        byte-2 (bit-and tuning 0x7f)]
    [byte-1 byte-2]))

(defn send-tuning-change
  ([receiver channel bank preset]
   (doseq [msg [(ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x64 04)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x65 00)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x06 bank)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x60 0x7f)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x61 0x7f)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x64 03)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x65 00)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x06 preset)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x60 0x7f)
                (ShortMessage. ShortMessage/CONTROL_CHANGE channel 0x61 0x7f)]]
     (.send receiver msg -1))))

(defn single-note-tuning-change-msg
  [freqs bank preset]
  (let [base-keys (map base-key freqs)
        tunings   (map #(cents-between (standard-freq (nth base-keys %))
                                       (nth freqs %))
                       (range 128))
        stream    (doto (ByteArrayOutputStream.)
                    (.write 0xf0)
                    (.write 0x7f)
                    (.write 0x7f)
                    (.write 0x08)
                    (.write 0x07)
                    (.write bank)
                    (.write preset)
                    (.write 128)
                    (#(dotimes [n 128]
                        (let [[byte-1 byte-2] (cents->byte-vec (nth tunings n))]
                          (.write % n)
                          (.write % (nth base-keys n))
                          (.write % byte-1)
                          (.write % byte-2))))
                    (.write 0xf7))
        data      (.toByteArray stream)]
    (SysexMessage. data (alength data))))

(def synthesizer (doto (MidiSystem/getSynthesizer) (.open)))
(def receiver (.getReceiver synthesizer))

(def sequencer (doto (MidiSystem/getSequencer false)
                 (.open)
                 (.setLoopCount Sequencer/LOOP_CONTINUOUSLY)))
(.setReceiver (.getTransmitter sequencer) receiver)

(defn retune
  [freqs]
  (dotimes [channel 16]
    (send-tuning-change receiver channel 0 0))
  (.send receiver (single-note-tuning-change-msg freqs 0 0) -1))

(def sounding-notes (atom #{}))

(defn play-note
  ([midi-key velocity]
   (.noteOn (first (.getChannels synthesizer)) midi-key velocity)
   (swap! sounding-notes conj {:midi-key midi-key}))
  ([midi-key]
   (play-note midi-key 127)))

(defn stop-note
  [midi-key]
  (.noteOff (first (.getChannels synthesizer)) midi-key)
  (swap! sounding-notes disj {:midi-key midi-key}))

(defn silence []
  (doseq [note @sounding-notes]
    (stop-note (:midi-key note))))

(defn set-midi-sequence
  [file-name]
  (.setSequence sequencer (MidiSystem/getSequence (File. file-name))))

(defn get-instrument
  []
  (inc (.getProgram (first (.getChannels synthesizer)))))

(defn change-instrument
  [instrument]
  (dotimes [channel 16]
    (.programChange (nth (.getChannels synthesizer) channel) (dec instrument))))

;; (set-midi-sequence "/home/kdp/share/midi/wtc/bwv846.mid")

(defn play []
  (.start sequencer))

(defn pause []
  (.stop sequencer))

(defn stop []
  (.stop sequencer)
  (.setTickPosition sequencer 0))

(defn cleanup []
  (.close sequencer)
  (.close synthesizer))

(defn load-soundbank
  [synth soundbank]
  (doto synth
    (.unloadAllInstruments (.getDefaultSoundbank synth))
    (.loadAllInstruments soundbank)))

(def soundbank (MidiSystem/getSoundbank
                (File. "/usr/share/soundfonts/FluidR3_GM2-2.sf2")))

(future (load-soundbank synthesizer soundbank))
