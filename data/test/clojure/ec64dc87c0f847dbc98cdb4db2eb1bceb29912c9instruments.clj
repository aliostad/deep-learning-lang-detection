;; The instrument system is based on the extempore instrument lib found here:
;; https://github.com/digego/extempore/blob/master/libs/core/instruments.xtm

(ns frankentone.instruments
  (:use [frankentone ugens dsp utils])
  (:import [java.util.concurrent PriorityBlockingQueue]
           [java.lang Comparable]))


(def instruments
  "Map of all registered instruments."
  (atom {}))


(deftype InstNote
    [scheduled-time
     note]
  java.lang.Comparable
  (compareTo [this obj]
    (compare scheduled-time
             (.scheduled-time ^InstNote obj))))


(defprotocol PInstrument
  "An Instrument"
  (clear [this])
  (clear-queue [this])
  (kill-note [this id])
  (new-note [this start-time freq amp dur varargs])
  (play [this time])
  (setFunction [this function])
  (getFunction [this])
  (setEFXFunction [this function])
  (setVolume [this vol])
  (getVolume [this])
  (setNoteKernel [this function])
  (getNoteKernel [this]))


(defn- reduce-notes ^double [time coll]
  (reduce-kv (fn ^double [val _ func] (+ val (func time))) 0.0 coll))


(defn note-due? [note-starts time]
  (some-> ^InstNote (.peek ^PriorityBlockingQueue note-starts)
          .scheduled-time
          (<= time)))


(defn kernel-good? [note-kernel]
  (if-not (fn? note-kernel)
    (do (println "Bad note kernel! Is not a function!")
        false)                             
    (let [test-output (try
                        ((note-kernel 440.0 1.0 2.0 :test 42)
                         0.0)
                        (catch Exception e
                          (str "Caught exception: "
                               (.getMessage e))))]
      (if (has-bad-value? test-output)
        (do
          (if (string? test-output)
            (println "Bad note-kernel! "
                     test-output)
            (println "Bad note-kernel! "
                     "Function returns result of type "
                     (type test-output)))
          false)
        true))))


(deftype CInstrument
    [name
     ^PriorityBlockingQueue note-starts
     notes
     ^:volatile-mutable ^Double volume
     ^:volatile-mutable function
     ^:volatile-mutable efx-function
     ^:volatile-mutable note-kernel]

  frankentone.instruments/PInstrument
  (clear [_] 
    (reset! notes {})
    (.clear note-starts))
  (play ^double [_ current-time]
    (efx-function
     (reduce-notes
      current-time
      (if-not (note-due? note-starts current-time)
        @notes
        (swap! notes
               #(apply merge %
                       (.note ^InstNote (.poll note-starts))
                       (for [starts note-starts
                             :while (<= (.scheduled-time
                                         ^frankentone.instruments.InstNote starts)
                                        current-time)]
                         (.note ^frankentone.instruments.InstNote (.poll note-starts)))))))))
  (clear-queue [_] (.clear note-starts))
  (kill-note [_ id] (swap! notes dissoc id))
  (new-note [this start-time freq amp dur varargs]
    (let [new-id (keyword (gensym (str name "_")))
          kernel (apply note-kernel
                        freq amp dur varargs)]
      (.put note-starts
            (frankentone.instruments.InstNote. start-time
                       [new-id
                        (fn ^double [time]
                          (let [rel-time (- time start-time)]
                            (if (< rel-time dur)
                              (* volume (kernel rel-time))
                              (do
                                (swap! notes dissoc new-id)
                                0.0))))]))
      (into {:inst name
             :id new-id
             :freq freq
             :amp amp
             :dur dur
             :start-time start-time}
            (when varargs
              {:varargs varargs}))))
  (setFunction [_ f] (set! function f))
  (getFunction [_] function)
  (setEFXFunction [_ f] (when (fn? f)
                                (set! efx-function f)))
  (setVolume [_ vol] (when (number? vol)
                       (set! volume (double vol))))
  (getVolume [_] volume)
  (setNoteKernel [_ f]
    (when (kernel-good? f)
      (set! note-kernel f)))
  (getNoteKernel [_] note-kernel))


(defn inst?->inst
  "Returns a keyword for an instrument function."
  [x]
  (if (keyword? x)
    x
    (when-let [inst (seq (filter #(= (getFunction ^PInstrument (val %))
                                     (if (var? x) @x x))
                                 @instruments))]
      (key (first inst)))))


(defn play-note
  "Plays a note at the specified time with the specified parameters"
  [time instrument frequency amplitude duration & args]
  (if-let [inst (get @instruments (inst?->inst instrument))]
    (new-note inst
           time
           frequency
           amplitude
           duration
           args)
    (println "no such instrument " instrument "!")))


(defn set-efx
  "Set effects function for the given instrument.

  Effects function takes one input (the current sample).

  Removes effects if not given a function"
  ([instrument] (set-efx instrument identity))
  ([instrument f]
     (if-let [inst (get @instruments (inst?->inst instrument))]
       (setEFXFunction inst
                       f)
       (println "no such instrument " instrument "!"))))


(defn set-vol
  "Set volume for the given instrument."
  [instrument v]
  (if-let [inst (get @instruments (inst?->inst instrument))]
    (setVolume inst v)
    (println "no such instrument " instrument "!")))


(defmacro definst
  "Construct an instrument out of a note-kernel.

  The note-kernel is a function that takes frequency, amplitude,
  duration and optional arguments as arguments and returns a
  function that takes relative time and produces sample values."
  ([name note-kernel]
     `(if-let [inst# (get @instruments (keyword '~name))]
        (do (.setNoteKernel ^frankentone.instruments.CInstrument inst# ~note-kernel)
            (def ~name (.getFunction ^frankentone.instruments.CInstrument inst#)))
        (when (kernel-good? ~note-kernel)
          (let [instrument# (frankentone.instruments.CInstrument. '~name
                                          ;; note-starts
                                          (PriorityBlockingQueue.) 
                                          ;; notes
                                          (atom {})
                                          ;; volume
                                          1.0
                                          ;; dsp-function
                                          nil
                                          ;; efx-function
                                          identity
                                          ~note-kernel)
                fn# (fn ^double [time#] (.play ^frankentone.instruments.CInstrument instrument# time#))]
            (.setFunction instrument# fn#)
            (def ~name fn#)
            (swap! instruments
                   assoc (keyword '~name)
                   instrument#))))))


(definst default 
  (fn [freq amp dur & _]
    (let [lpf (lpf-c)
          saw1 (sawdpw-c 0.0)
          saw2 (sawdpw-c 0.0)
          saw3 (sawdpw-c 0.0)
          saw-freq-add2 (rrand 0.4)
          saw-freq-add3 (rrand 0.4)
          line (line-c (rrand 4000 5000) (rrand 2500 3200) 1.0)
          asr (asr-c 0.01 (max 0.0 (- dur 0.11)) 0.6 0.1)]
      (fn ^double [time]
        (+ (*
            amp
            (asr)
            (lpf
             (+ (saw1 0.3 freq)
                (saw2 0.3 (+ freq saw-freq-add2))
                (saw3 0.3 (+ freq saw-freq-add3)))
             (line)
             1.0)))))))


(defn reduce-instruments
  "Convenience function to get the sum of a map of instruments.

E. g. get all instruments' output summed:
(reduce-instruments @instruments t)

Sum all instruments except the :bd instrument:
(reduce-instruments (dissoc @instruments :bd) t)
"
  [coll t]
  (reduce-kv
   (fn [val _ inst]
     (+ val
        (.play ^frankentone.instruments.CInstrument inst t)))
   0.0 coll))


(def global-efx
  "Effects function used in instruments->dsp!.

  Effects function takes one input (the current sample)."
    (atom identity))

(defn instruments->dsp!
  "Resets the dsp function to play all registered instruments."
  []
  (reset-dsp!
   (dup!
    (fn [t]
      (@global-efx
       (reduce-instruments @instruments t))))))
