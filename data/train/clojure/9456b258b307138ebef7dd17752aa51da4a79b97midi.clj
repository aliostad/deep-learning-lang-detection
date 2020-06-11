(ns diatonic.midi
  (:import
    [javax.sound.midi MidiEvent MidiSystem MetaMessage Sequence ShortMessage]))

(defonce sequencer (MidiSystem/getSequencer))

(defn- short-message [command channel data1 data2]
  (let [msg (ShortMessage.)]
    (.setMessage msg command channel data1 data2)
    msg))

(defn- midi-event [message tick]
  (MidiEvent. message tick))

(defn- tempo-event [bpm]
  (let [message (MetaMessage.)
        mpq (Math/round (/ 60000000.0 bpm))
        data (byte-array 3)]
    (aset-byte data 0 (bit-and (Byte/MAX_VALUE) (bit-shift-right mpq 16)))
    (aset-byte data 1 (bit-and (Byte/MAX_VALUE) (bit-shift-right mpq 8)))
    (aset-byte data 2 (bit-and (Byte/MAX_VALUE) mpq))
    (.setMessage message 0x51 data (alength data))
    (midi-event message 0)))

(defn- channel-event [channel instrument]
  (let [channel-msg (short-message (ShortMessage/PROGRAM_CHANGE)
                                   channel instrument 0)]
    (midi-event channel-msg 0)))

(defn- note-on-event [channel pitch velocity tick]
  (let [on-msg (short-message (ShortMessage/NOTE_ON) channel pitch velocity)]
    (midi-event on-msg tick)))

(defn- note-off-event [channel pitch tick]
  (let [off-msg (short-message (ShortMessage/NOTE_OFF) channel pitch 64)]
    (midi-event off-msg tick)))

(defn midi-sequence [bpm tracks]
  (let [sequence (Sequence. (Sequence/PPQ) 8)]
    (doseq [track-data tracks]
      (let [track (.createTrack sequence)
            track-type (:type track-data)
            notes (:notes track-data)
            channel (if (= track-type :drums) 9 0)]
        (cond (= track-type :chord) (.add track (channel-event channel 0))
              (= track-type :drums) (.add track (channel-event channel 36)))
        (doseq [note notes]
          (doto track
            (.add (note-on-event channel
                                 (:pitch note)
                                 (:velocity note)
                                 (:offset note)))
            (.add (note-off-event channel
                                  (:pitch note)
                                  (+ (:offset note)
                                     (:length note))))))))
    (.add (first (.getTracks sequence)) (tempo-event bpm))
    sequence))

(defn play-sequence [sequence]
  (.start
   (Thread.
    (fn []
      (locking sequencer
        (with-open [s sequencer]
          (doto sequencer
            (.setSequence sequence)
            (.open)
            (.start))
          (loop []
            (when (.isRunning sequencer)
              (Thread/sleep 100)
              (recur)))
          (Thread/sleep 200)))))))
