(ns quantum.audio.midi
  (:refer-clojure :exclude
    [map map-indexed butlast last for partition-all reduce remove drop cat])
  (:require
    [clojure.core.match
      :refer [match]]
    [quantum.core.fn
      :refer [<- fn-> fn->> fn1 fnl]]
    [quantum.core.logic
      :refer [fn-and whenc whenf whenf1 xor cond-let]]
    [quantum.core.collections :as coll
      :refer [ffilter filter+ remove+ remove partition-all+ keys+ partition-all lpartition-all
              cat lcat concatv
              map+ map lmap map-indexed kw-map index-of index-of-pred
              cat each popl popr slice butlast last drop ldrop
              while-let lfor doseqi for fori red-for join reduce zip lzip]]
    [quantum.core.async       :as async
      :refer [go <! <!! >! put! timeout]]
    [quantum.core.data.validated :as dv]
    [quantum.core.spec           :as s
      :refer [validate]]
    [quantum.core.error       :as err
      :refer [catch-all ->ex TODO]]
    [quantum.core.log         :as log]
    [quantum.core.resources   :as res]
    [quantum.core.string      :as str]
    [quantum.core.convert.primitive     :as pconv]
    [quantum.core.convert     :as conv]
    [quantum.measure.convert
      :refer [convert]]
    [quantum.core.type        :as t
      :refer [val?]]
    [quantum.core.async.pool  :as pool]
    [quantum.db.datomic.core  :as dbc]) ; TODO just for the spec
  (:import
    (javax.sound.midi MidiSystem MidiDevice MidiMessage ShortMessage MidiDevice$Info Receiver)
    (uk.co.xfactorylibrarians.coremidi4j
      CoreMidiDeviceProvider CoreMidiDeviceInfo CoreMidiNotification CoreMidiException
      CoreMidiDestination CoreMidiReceiver)))

; To be able to connect two applications over MIDI, virtual MIDI ports/buses are required using e.g. Audio MIDI Setup.
; In Audio Midi Setup application, Window > Show Midi Studio
; Then follow directions from:
; http://www.johanlooijenga.com/tools/12-virtual-ports.html
; See also:
; http://www.soundonsound.com/techniques/audio-midi-setup
; http://www.jsresources.org/faq_midi.html




; TODO much of this can be made .cljc! :D
; TODO componentize all of this

(def provider (CoreMidiDeviceProvider.))

(def device-name "Bus 2") ; TODO dynamic

(defn working-devices []
  (->> (CoreMidiDeviceProvider/getMidiDeviceInfo)
       (filter+ #(instance? CoreMidiDeviceInfo %))
       (map+    #(.getDevice ^CoreMidiDeviceProvider provider %))
       (join)))

(def out
  (delay
    (let [out-device
           (->> (working-devices)
                (ffilter (fn-and #(instance? CoreMidiDestination %)
                                 #(-> ^MidiDevice % .getDeviceInfo .getName (= (str "CoreMIDI4J - " device-name))))))]
      (assert (val? out-device))
      (.getReceiver ^MidiDevice out-device))))

(defn out-position [] (-> ^CoreMidiReceiver @out .getMidiDevice .getMicrosecondPosition))

; TODO maybe these validations are more restrictive
#_(dv/def-map ^:db? event
  :conformer (fn [m] (if (-> m :this/chan nil?)
                         (assoc m :this/chan 0)
                         m))
  :req-un    [(def :this/action   (s/and :db/long #(<= -127 (do (println "%" %) %) 256)))
              ; the lowest and highest keys on the piano correspond to MIDI note numbers 21 and 108
              (def :this/pitch    (s/and :db/long #(<= 0    (do (println "%" %) %) 127)))
              (def :this/velocity (s/and :db/long #(<= 0    (do (println "%" %) %) 127)))
              (def :this/duration (s/and :db/long pos?))] ; yeah, maybe int...
  :opt-un    [(def :this/chan     (s/and :db/long #(<= 0    (do (println "%" %) %) 127)))])

(defonce volumes    (atom {}))
(defonce curr-times (atom {}))

(def ccs {:modwheel 1})

(defn modwheel! [^long chan ^long level ^long timestamp]
  (-> ^Receiver @out (.send (ShortMessage. ShortMessage/CONTROL_CHANGE (dec chan) (-> ccs :modwheel long) level   ) timestamp)))

(defn release! [^long chan ^long pitch ^long timestamp]
  (-> ^Receiver @out (.send (ShortMessage. ShortMessage/NOTE_OFF       (dec chan) pitch                   0       ) timestamp)))

(defn on! [^long chan ^long pitch ^long velocity ^long timestamp]
  (-> ^Receiver @out (.send (ShortMessage. ShortMessage/NOTE_ON        (dec chan) pitch                   velocity) timestamp)))

(defn off! [^long chan ^long pitch ^long velocity ^long timestamp]
  (-> ^Receiver @out (.send (ShortMessage. ShortMessage/NOTE_OFF       (dec chan) pitch                   velocity) timestamp)))

(defn release-all! [& [offset]]
  (doseq [chan (range 1 16)]  ; TODO determine dynamically from playback
    (-> ^Receiver @out (.send (ShortMessage. ShortMessage/CONTROL_CHANGE (dec chan) 123 100) (+ (out-position) (convert (or offset 0) :millis :micros))))
    #_(doseq [pitch (-> pitches vals sort)]
      (release! chan pitch 0))))

(defn test-message! [chan]
  ; TODO make it render the ops
  #_(gen-ops chan 60 127 1000 false))

(def scale [:c :c# :d :eb :e :f :f# :g :ab :a :bb :b])

; 21-108 is standard
; 60 is middle C
; goes till c9
(def pitches
  (zipmap
    (lcat
      (lfor [octave (range 0 (inc 9))]
        (->> scale
             (map (fn [k] (keyword (str (name k) octave)))))))
    (range 0 #_21 (inc 108))))

(def <-pitches (coll/invert pitches))

(defn str->music
  {:usage `{(str->music
                "|                | f |       |  • |
                 | 6 french horns | 6 | 4c    | 4c |
                 |                | f |       |  • |
                 | 6 french horns | 5 | 4g    | 4g |
                 |                | f |       |  • |
                 | 6 french horns | 5 | 1e 3f | 4e |
                 |                | f |       |  • |
                 | 6 french horns | 5 | 4c    | 4c |")
              [{:instrument "6 french horns",
                :expr-0 "f",
                :measures [[[nil [4 \c]]] [["•" [4 \c]]]],
                :octave 6}
               {:instrument "6 french horns",
                :expr-0 "f",
                :measures [[[nil [4 \g]]] [["•" [4 \g]]]],
                :octave 5}
               {:instrument "6 french horns",
                :expr-0 "f",
                :measures [[[nil [1 \e]] [nil [3 \f]]] [["•" [4 \e]]]],
                :octave 5}
               {:instrument "6 french horns",
                :expr-0 "f",
                :measures [[[nil [4 \c]]] [["•" [4 \c]]]],
                :octave 5}]}}
  [s]
  (validate s string?)
  (let [lines-then-measures
          (->> s (<- str/split #"\n")
                 (remove+ empty?)
                 (map+    (fn-> str/trim (str/split #"\|") popl))
                 join)
        ; TODO validate that no more than 1 empty measure is allowed
        initial-measure-ct 2
        start-measure (- (or (-> lines-then-measures first
                                 (index-of-pred empty?))
                             initial-measure-ct)
                         initial-measure-ct)
        lines-then-measures (->> lines-then-measures (mapv (remove empty?)))
        num-all-measures (-> lines-then-measures first count)]
    ; Ensure all lines have the same number of measures
    (doseqi [line lines-then-measures i]
      (validate (count line) (fn1 = num-all-measures)))
    ; Ensure all measures are the same width
    (dotimes [i-measure num-all-measures]
      (let [measure-width (-> lines-then-measures first (get i-measure) count)]
      (doseqi [line lines-then-measures i]
        (validate (-> line (get i-measure) count) (fn1 = measure-width)))))
    (let [music (->> lines-then-measures
                     (map+ (fn->> (mapv (fn-> popl popr))))
                     (partition-all+ 2)
                     (map+ (fn [[[_ expr-0 & measures-exprs] [label octave & measures-notes]]]
                             ; TODO more validation about shape based on e.g. instaparse
                             (let [measures-indices
                                     (->> measures-notes
                                          (mapv (fn1 coll/indices-of-matches #(not= % \space))))
                                   extract
                                     (fn [x f]
                                       (map-indexed
                                         (fn [i elem]
                                           (lfor [[from to] (get measures-indices i)]
                                             (-> (slice elem from to) str/trim (whenc empty? nil) f)))
                                         x))
                                   measures
                                     (mapv zip (extract measures-exprs identity)
                                               (extract measures-notes
                                                 (fn [x] ; TODO use core match here
                                                   (if (-> x last (= \>))
                                                       {:tie?              true
                                                        :relative-duration (-> x popr popr conv/->form)
                                                        :note              (-> x popr last)}
                                                       {:relative-duration (-> x popr conv/->form)
                                                        :note              (-> x last)}))))]
                                 {:instrument (-> label str/trim)
                                  :expr-0     (-> expr-0 str/trim)
                                  :measures   measures
                                  :octave     (-> octave str/trim pconv/->int)})))
                     join)
          _ (dotimes [i-measure num-all-measures]
              (let [count-this-measure (fn [line]
                                         (->> line :measures (<- get i-measure)
                                              (map+ (fn-> second :relative-duration))
                                              (reduce +)))
                    measure-duration (-> music first count-this-measure)]
                (doseq [line music]
                  (validate (count-this-measure line) (fn1 = measure-duration)))))]
      (assoc (kw-map music start-measure)
             :num-measures (- num-all-measures initial-measure-ct)))))

(def articulations->articulation-name
  {#{}   :normal
   #{\•} :staccato
   #{\-} :tenuto})

(def
  ^{:doc "According to the Apple Logic Pro 9 User Manual for MIDI Step Input Recording
          (http://documentation.apple.com/en/logicpro/usermanual/index.html#chapter=14%26section=30%26tasks=true)"}
  dynamics->volume
  {"ppp" 16
   "pp"  32
   "p"   48
   "mp"  64
   "mf"  80
   "f"   96
   "ff"  112
   "fff" 127})

; TODO move
(defn scale
  "Scales (<= x low high) to be between (<= x' low' high')."
  {:example `{(scale 55 5 105 7 27)
              17}}
  [x low high low' high']
  (+ low' (* (/ (- x low) (- high low)) (- high' low'))))

(def instrument-name->config
  {"6 French Horns"
   ; 6FH Sus
    {:normal   {:modwheel {:type :volume}}
     ; 6FH Shorts MOD SPEED
     :staccato {:velocity     {:type :volume}
                :max-duration 450
                :modwheel     {:type :duration
                               :fn   (fn staccato-duration [x]
                                        (cond
                                          (<= 0   x 150) (scale x 0   150 0  32 )
                                          (<= 150 x 250) (scale x 150 250 33 65 )
                                          (<= 250 x 350) (scale x 250 350 66 98 )
                                          (<= 350 x 450) (scale x 350 450 99 127)
                                          :else          nil))}}}
   "2nd Violins"
    {:normal   {:modwheel {:type :volume}}}})

; TODO spec this
(def instrument-name->chan
  (->> {}
       (#(reduce (fn [ret i]
                   (assoc ret (str "6 French Horns" " " "(" i ")")
                     (-> (get instrument-name->config "6 French Horns")
                         (assoc-in [:normal   :chan] (- (* i 2) 1))
                         (assoc-in [:staccato :chan] (- (* i 2) 0))))) % [1 2]))
       (#(reduce (fn [ret i]
                   (assoc ret (str "2nd Violins" " " "(" i ")")
                     (-> (get instrument-name->config "2nd Violins")
                         (assoc-in [:normal :chan] (+ i 10))))) % [1]))))

(def ^:static default-dynamic "mf")
(def ^:static default-volume  (get dynamics->volume default-dynamic))

(defn duration->apply-staccato [duration max-duration]
  (let [max-diminisher 1/2
        duration-cliff (/ max-duration max-diminisher)]
    (if (> duration duration-cliff)
        (* duration max-diminisher)
        (* duration (scale duration 0 duration-cliff 1 max-diminisher)))))

(defn set-up-measure [[expr {:keys [tie? relative-duration note]} :as note*]
                      {:keys [octave instrument normal-chan base-duration]}]
  (let [expr (frequencies expr)
        _    (validate expr #(not (and (contains? % \^)
                                       (contains? % \v))))
        [octave' expr']
        (cond-let [ups   (get expr \^)]
                  [(+ octave ups  ) (dissoc expr \^)]
                  [downs (get expr \v)]
                  [(- octave downs) (dissoc expr \v)]
                  [octave           expr])
        expr' (->> expr' keys+ (join #{}))
        found-articulation (-> (get articulations->articulation-name expr')
                               (validate keyword?))
        articulation  found-articulation ; TODO might be more complex logic here
        {:keys [chan max-duration] :as config
         :or   {max-duration Long/MAX_VALUE}}
          (or (get-in instrument-name->chan [instrument articulation])
              (get-in instrument-name->chan [instrument :normal     ])) ; TODO warn if articulation not found
        _             (validate chan (fn1 t/integer?))
        d             base-duration
        note-duration (* relative-duration base-duration)
        ; Switch to normal config if note is too long for e.g. staccato, etc.
        {:keys [chan] :as config}
          (if (> note-duration max-duration)
              (get-in instrument-name->chan [instrument :normal])
              config)
        _             (validate chan (fn1 t/integer?))
        duration      (case articulation
                            :staccato (duration->apply-staccato note-duration max-duration)
                            :tenuto   (* note-duration (+ 1 1/5))
                                      note-duration)
        volume-prev   (or (get @volumes chan)
                          (get @volumes normal-chan))
        volume        volume-prev ; TODO fix; currently can't change volume
        velocity      (case (-> config :velocity :type)
                            :volume volume
                            nil     1)
        modwheel      (case (-> config :modwheel :type)
                            :volume   volume
                            :duration (-> config :modwheel :fn
                                          (validate fn?)
                                          (#(% duration)))
                            nil       nil)
        pitch         (keyword (str note octave'))
        pitch-int     (delay (-> pitches (get pitch) (validate (fn1 t/integer?))))]
    (kw-map note note-duration duration relative-duration octave' pitch pitch-int modwheel chan velocity tie?)))

(defonce stop? (atom false))

(defn config-lines! [lines]
  (for [{:as   line
         :keys [instrument
                expr-0]} lines]
    (let [config      (get-in instrument-name->chan [instrument :normal])
          normal-chan (-> config :chan (validate (fn1 t/integer?)))
          volume-0    (-> (get dynamics->volume expr-0)
                          (validate (fn1 t/integer?)))]
      (swap! volumes assoc normal-chan volume-0)
      normal-chan)))

(defn stop! [& [offset]]
  (reset! stop? true)
  (res/stop-registered-system! ::system)
  (release-all! offset))

(defn gen-ops-for-note [{:keys [chan pitch velocity duration tie-on? measure-ties scheduler]}]
  (let [_          (validate measure-ties (fn1 t/+map?))
        tied       (get measure-ties chan)
        prev-tied? (= tied pitch)]
    (cond prev-tied?
          {:note-ties (if-not tie-on? (dissoc measure-ties chan) measure-ties)
           :note-ops
             (join
               [[:wait chan duration]]
               (when-not tie-on?
                 [[:off chan (long pitch) (long velocity)]]))}
          tie-on?
          {:note-ties (assoc measure-ties chan pitch)
           :note-ops
            [[:on    chan (long pitch) (long velocity)]
             [:wait  chan duration]]}
          :else
          {:note-ties measure-ties
           :note-ops
             [[:on   chan (long pitch) (long velocity)]
              [:wait chan duration]
              [:off  chan (long pitch) (long velocity)]]})))

(defn gen-ops-for-measure
  [measure
   {:as   line
    :keys [instrument expr-0 measures octave]}
   {:keys [base-duration scheduler normal-chan bar-ties]}]
  (validate bar-ties (fn1 t/+map?))
  (red-for [note* measure
            {:keys [measure-ties measure-ops]} {:measure-ties bar-ties :measure-ops []}]
    (let [{:keys [note note-duration duration relative-duration octave' pitch-int modwheel chan velocity tie?] :as setup}
          (set-up-measure note* (kw-map octave instrument normal-chan base-duration))]
      (if (= \- note) ; rest
          {:measure-ties bar-ties
           :measure-ops  (concatv measure-ops [[:wait chan duration]])}
          (let [note-genned (gen-ops-for-note (assoc (kw-map chan velocity duration tie? measure-ties scheduler) :pitch @pitch-int))
                note-duration-difference-op ; E.g. for staccatos
                 (let [diff (- duration note-duration)]
                   (cond (zero? diff)
                         nil
                         (neg? diff)
                         [[:wait chan (- diff)]]
                         (pos? diff)
                         (throw (TODO "Doesn't handle lengthening difference (e.g. tenuto)"))))
                note-ops
                  (concatv
                    (when modwheel [[:mod chan modwheel]])
                    (:note-ops note-genned)
                    note-duration-difference-op)]
            {:measure-ties (:note-ties note-genned) ; overwritten
             :measure-ops  (concatv measure-ops note-ops)})))))

(defn gen-ops-for-bar
  [{:keys [music base-duration scheduler normal-chans i-measure ties ops]}]
  (validate ties (fn1 t/+map?))
  (red-for [[i-line line] (coll/lindexed music)
            {:keys [bar-ties bar-ops]} {:bar-ties ties :bar-ops []}]
    (let [measure (-> line :measures (get i-measure))
          measure-genned
            (gen-ops-for-measure measure line
              (assoc (kw-map base-duration scheduler bar-ties)
                     :normal-chan (get normal-chans i-line)))]
      {:bar-ties (:measure-ties measure-genned) ; overwritten
       :bar-ops  (conj bar-ops (:measure-ops measure-genned))})))

(defn gen-ops
  "Creates the ops to schedule."
  [{:keys [music num-measures start-measure base-duration scheduler normal-chans]}]
  (:ops
    (red-for [i-measure (range start-measure num-measures)
              {:keys [ties ops]} {:ties {} :ops []}]
      (let [line-genned (gen-ops-for-bar (kw-map music base-duration scheduler normal-chans i-measure ties ops))]
        {:ties (:bar-ties line-genned) ; overwritten
         :ops  (conj ops (:bar-ops line-genned))}))))

; TODO fix ties

#_(let [^long micros (-> @out ^Receiver .getMidiDevice .getMicrosecondPosition)]

(-> ^Receiver @out (.send (ShortMessage. ShortMessage/NOTE_ON  (dec 1) 60 100) (+ micros (convert 1000 :millis :micros))))
  (-> ^Receiver @out (.send (ShortMessage. ShortMessage/NOTE_OFF  (dec 1) 60 100) (+ micros (convert 2000 :millis :micros)))))

(defn log-error [f]
  #(catch-all (f) e (log/pr :warn e)))

(def ops->with-pitches (map (map (whenf1 (fn-> first #{:off :on}) (fn1 update 2 <-pitches)))))

(defn render! [{:keys [music start-measure num-measures]} base-duration & [scheduler-type]]
  (stop! 0)
  (when scheduler-type (res/default-main ::system true {scheduler-type {:threads 1}}))
  (reset! stop? false)
  (swap! volumes    empty)
  (swap! curr-times empty)
  (let [normal-chans (config-lines! music)
        scheduler    (-> @res/systems ::system :sys-map (get scheduler-type))
        ops        (gen-ops (kw-map music num-measures start-measure base-duration scheduler normal-chans))
        start-time (if scheduler-type
                       (long (+ (convert 0.5 :sec :nanos) (System/nanoTime))) ; give 0.5 sec to insert opcodes just in case ; TODO this is buggy
                       (-> ^CoreMidiReceiver @out .getMidiDevice .getMicrosecondPosition))
        at         (atom {})] ; keys are lines
    (log/prl ::debug ops)
    (doseq [measure-ops ops]
      ; TODO lazily schedule measures
      (doseqi [line measure-ops i-line]
        (doseq [[opcode chan & args] line]
          (when @stop? (throw (->ex "Stopped" {::stopped? true})))
          (let [at-f (or (@at i-line) start-time)
                midi-timestamp (if scheduler 0 at-f)
                args (concat args [midi-timestamp])
                std-op  (fn [f]
                          (if scheduler-type
                              (pool/schedule! scheduler at-f (log-error #(apply f chan args)))
                              (apply f chan args)))]
            (case opcode :on   (std-op on!)
                         :off  (std-op off!)
                         :mod  (std-op modwheel!)
                         :wait (let [offset (if scheduler
                                                (-> args first (convert :millis :nanos ))
                                                (-> args first (convert :millis :micros)))]
                                 (swap! at update i-line (fn [x] (+ (or x start-time) offset))))))))) ; wait?
    ; No more things allowed to be scheduled
    ; Wait for everything to play
    (when scheduler-type (pool/await-termination! scheduler))
    (log/pr ::debug "Terminated scheduler.")
    (release-all! (if scheduler-type 1000 0)) ; TODO fix the 1000
    (reset! stop? false)
    (log/pr ::debug "Done rendering.")))

(defn render-async! [& args]
  (clojure.core.async/thread (apply render! args)))

(defn join-staves [& staves]
  (->> staves
       (map (fn->> (<- str/split #"\n")
                   (map+ str/trim)
                   (map+ (fn1 popl))
                   join))
       (apply (partial mapv (partial apply str)))
       (str/join "\n")))

