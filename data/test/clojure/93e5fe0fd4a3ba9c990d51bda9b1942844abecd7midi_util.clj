(ns composition-kit.music-lib.midi-util
  (:import (javax.sound.midi MidiSystem ShortMessage MidiDevice MidiDevice$Info Transmitter Receiver))
  (require [composition-kit.music-lib.logical-sequence :as ls])
  )

;; A set of functions to allow me to interact with javax.sound.midi in a slightly less painful way from clojure.


;; I keep a running global of the pipes I've opened so I can do an all-pipes-shutdown.
(def opened-recv (atom []))

(defn ^{:private true} get-opened-receiver-unmemo
  ([]  (get-opened-receiver-unmemo "Bus 1"))
  ([name]
   (let [device-info       (MidiSystem/getMidiDeviceInfo) 
         named-device-info (filter #(= (.getName ^MidiDevice$Info %) name) device-info)
         devices           (map #(MidiSystem/getMidiDevice ^MidDevice$Info %) named-device-info)
         receivables       (filter #(>= (.getMaxTransmitters ^MidiDevice %) 0) devices)
         _                 (when (empty? receivables)
                             (throw (ex-info "Unable to resolve midi device name"
                                             {:name name
                                              :devices (map #(.getName ^MidiDevice$Info %) device-info)
                                              })))
         receivable        (first receivables)
         result            (do 
                             (.open ^MidiDevice receivable)
                             (.getReceiver ^MidiDevice receivable))]
     (swap! opened-recv conj name)
     result)
   )
  )



(defn ^{:private true} get-opened-transmitter-unmemo
  ([]  (get-opened-transmitter-unmemo "Bus 1"))
  ([name]
   (as-> (MidiSystem/getMidiDeviceInfo) it
     (filter #(= (.getName ^MidiDevice$Info %) name) it)
     (map #(MidiSystem/getMidiDevice ^MidiDevice$Info %) it)
     (filter #(>= (.getMaxReceivers ^MidiDevice %) 0) it)
     (first it)
     (do (.open ^MidiDevice it) it)
     (.getTransmitter ^MidiDevice it)
     )
   )
  )


(def get-opened-receiver (memoize get-opened-receiver-unmemo))
(def get-opened-transmitter (memoize get-opened-transmitter-unmemo))

;; Wrappers for short message types
(defn ^:private gen-short-message-func
  ([msg] (gen-short-message-func msg 3))
  ([msg args]
   (case (int args)
     2   (fn [a b] (ShortMessage. msg a b 0))
     3   (fn [a b c] (ShortMessage. msg a b c))))) 

(def note-on (gen-short-message-func ShortMessage/NOTE_ON))
(def note-off (gen-short-message-func ShortMessage/NOTE_OFF 2))
(def control-change (gen-short-message-func ShortMessage/CONTROL_CHANGE))
(def pitch-bend (gen-short-message-func ShortMessage/PITCH_BEND))


(defn gen-send [^Receiver rcv msg] (fn [time] (.send rcv msg -1)))

(defn ^:private gen-send-message-func[msg]
  (fn gen-send-internal
    ([^Receiver rcv a b]   (gen-send-internal rcv a b 0))
    ([^Receiver rcv a b c] (let [msg (ShortMessage. msg a b c)]
                             (fn [time] (.send rcv msg -1))))))


(def send-note-on (gen-send-message-func ShortMessage/NOTE_ON))
(def send-note-off (gen-send-message-func ShortMessage/NOTE_OFF))
(def send-control-change (gen-send-message-func ShortMessage/CONTROL_CHANGE))
(def send-pitch-bend (gen-send-message-func ShortMessage/PITCH_BEND))

(defn message-to-map [^ShortMessage m]
  {:channel (.getChannel m)
   :command (.getCommand m)
   :data1   (.getData1 m)
   :data2   (.getData2 m)})

;; The transmitter API is a bit clunky if you want raw messages so lets abstract it away a little bit
(defn register-transmitter-callback [ ^Transmitter t f ]
  (.setReceiver t
                (reify javax.sound.midi.Receiver
                  (send [this msg time] (f msg time))))
  t
  )

;; Make a little abstraction for a midi instrument which we can use to pass around state later on.
(defn midi-port
  ([channel] (midi-port "Bus 1" channel))
  ([bus channel]
   {
    :receiver (get-opened-receiver bus)
    :channel  channel
    })
  )


;; Now make the instrument maps. Make an abstraction name to create it for now
(defn midi-instrument-map [] {})

(defn midi-instrument-from-name-and-port [name port] {:name name :port port})
(defn add-midi-instrument [m name port]
  (assoc m name (midi-instrument-from-name-and-port name port))
  )

(defn all-notes-off
  ([] (doseq [r @opened-recv] (all-notes-off r)))
  ([b]
   (let [r (get-opened-receiver b)
         ]
     (doall
      (map (fn [chan]
             ((send-control-change r chan 64 0) 0);; no pedal
             (doall (map #(do
                            (when (zero? (mod % 20)) (java.lang.Thread/sleep 1))
                            ((send-note-off r chan %) 0)) (range 128))))
           (range 16))))
   true
   )
  )





