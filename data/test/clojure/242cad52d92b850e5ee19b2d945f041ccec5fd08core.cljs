(ns web-audio.core
  (:require [goog.net.XhrIo]
            [cljs.core.async :as async :refer [<! >! put! take! chan close!]]
            [clojure.string :as s])
  (:require-macros [cljs.core.async.macros :refer [go go-loop]]))

;from overtone
(defn scale-range
  "Scales a given input value within the specified input range to a
  corresponding value in the specified output range using the formula:

           (out-max - out-min) (x - in-min)
   f (x) = --------------------------------  + out-min
                    in-max - in-min
  "
  [x in-min in-max out-min out-max]
  (+ (/ (* (- out-max out-min) (- x in-min))
        (- in-max in-min))
     out-min))

; (scale-range 3 0 10 10 0)
  
(defn log [& args] (doseq [x args] (.log js/console x)))

(defn get-context []
  (let [AudioContext (or (.-AudioContext js/window)
                         (.-webkitAudioContext js/window))]
    (AudioContext.)))

(defn decode-audio-data
  [context data]
  (let [ch (chan)]
    (.decodeAudioData context
                      data
                      (fn [buffer]
                        (go (>! ch buffer)
                            (close! ch))))
    ch))
 
(defn get-audio [url]
  (let [ch (chan)]
    (doto (goog.net.XhrIo.)
      (.setResponseType "arraybuffer")
      (.addEventListener goog.net.EventType.COMPLETE
                         (fn [event]
                           (let [res (-> event .-target .getResponse)]
                             (go (>! ch res)
                                 (close! ch)))))
      (.send url "GET"))
    ch))

(defn buffer [context path]
  (go 
    (->> (get-audio path)
          <!
          (decode-audio-data context)
          <!)))

;;helpers
;------------------------------------------
(defn path->kw [p]
  (let [with-ext (last (clojure.string/split p #"/"))]
    (first (clojure.string/split with-ext #"\."))))

(defn get-in! [obj vc] 
  (reduce aget obj (map name vc)))

(defn set-in! [obj vc val]
  (aset (get-in! obj (butlast vc)) (name (last vc)) val)
  obj)

;;app
;----------------------------------------------------------------------

(def buffers (atom {}))
(def instruments (atom {}))
(def channels (atom {})) 
(def sources (atom {})) ;active buffer-sources

(def context (atom (get-context)))
(def out (.-destination @context))

(defn now [] (.-currentTime @context))

(defn buffer-source [] 
  (.createBufferSource @context))

(defn gain-node []
  (.createGainNode @context))

(defn load-buffers [& paths]
  (doseq [p paths]
    (take! (buffer @context p) 
           #(swap! buffers assoc (keyword (path->kw p)) %1))))

(defn load-samples [{:keys [type name samples-path]}]
  (doseq [path (map #(str samples-path "/" %1 "." type) (range 128))
          :let [file-name (keyword (path->kw path))]] ;this should be paralelized
    (take! (buffer @context path)
           #(swap! instruments assoc-in [name :samples file-name] %1))))

(def default-instrument
  {:name (keyword (gensym "inst"))
   :channel 1
   :attack 0 
   :decay 0
   :sustain 1
   :fade 10000
   :release 0.2
   :range [0 127]
   :type "ogg"
   :samples {}})

(defn add-instrument 
  [opts]
  (let [inst (merge default-instrument opts)]
    (swap! channels assoc (:channel inst) (:name inst))
    (swap! instruments assoc (:name inst) inst)
    (load-samples inst)))

(comment (add-instrument {:name :glass :samples-path "sounds/glass_harmo"})
  @instruments)

(defn get-instrument [midi-channel] 
  ((get @channels midi-channel) @instruments))

(defn play-sound 
  ([name] (play-sound name 0))
  ([name timeout]
  (doto (.createBufferSource @context)
    (aset "buffer" (name @buffers))
    (.connect (.-destination @context))
    (.start timeout))))

(comment 
 (load-buffers 
  "sounds/woohoo.wav" 
  "sounds/doh.wav" 
  "sounds/oct.wav")
 
 (play-sound :woohoo 1000)
 (play-sound :doh)
 (play-sound :oct))

(comment 
  (apply load-buffers 
    (for [x (range 46 78)]
      (str "sounds/glass-harmo/" x "p1.ogg"))))

;;connection
;-------------------------------------------------------------------

  (declare connect)

  (defn node-group [nodes]
    (apply connect nodes)
    (with-meta {:in (first nodes) :out (last nodes) :nodes nodes} 
               {:type 'NodeGroup}))

  (defn node-group? [x] 
    (= 'NodeGroup (:type (meta x))))

  (defn do-groups [els]
    (map #(cond 
            (vector? %1) (node-group (do-groups %1)) 
            (set? %1) (set (do-groups %1))
            :else %1) 
         els))

  (defn connect [& els]
    (let [els (do-groups els)]
     (doseq [[from to] (partition 2 1 els)]
      (cond 
        (vector? from)
          (do (apply connect from) (connect (last from) to))
        (vector? to)
          (do (apply connect to) (connect from (first to)))
        (node-group? from) 
          (connect (:out from) to)
        (node-group? to) 
          (connect from (:in to))
        (set? from)
          (doseq [f from] (connect f to))
        (set? to)
          (doseq [t to] (connect from t))
        :else (do #_(println (str "connecting " from " to " to))
                  (.connect from to))))))

  (comment 
    (connect "a" "b" ["c" "d"])
    (connect "a" #{"b1" "b2" "b3"} "c")
    (connect "a" #{"b1" "b2" "b3"} ["c1" "c2" "c3"] "d")
    (connect "a" #{"b1" "b2" ["b3-1" "b3-2"]} ["c1" "c2" "c3"] "d")
    (connect "in" ["b1" #{"b2-1" "b2-2"}] "out")
    (connect ["in" ["b1" #{"b2-1" "b2-2"}] "out"]))

;;synth
;---------------------------------------------------------------------

  (defn set-freq! [osc val]
    (set! (.-frequency osc) -value val))

  (defn set-detune! [osc val]
    (set! (.-detune osc) -value val))

  (defn set-type! [osc val]
    (set! osc -type val))

  (defn osc 
    ([type freq] (osc type freq 0))
    ([type freq detune] 
     (doto (.createOscillator @context)
       (set-freq! freq)
       (set-detune! detune)
       (set-type! type))))

  (def midi->freq-chart 
   (let [a 440]
    (apply vector 
     (for [x (range 128)]
      (* (/ a 32) (js/Math.pow 2 (/ (- x 9) 12)))))))

  (defn midi->freq [midi-num]
    (nth midi->freq-chart midi-num))

  (defn play-maj-chord [root]
    (doseq [x [0 4 7]]
      (let [o (osc "sine" (midi->freq (+ root x)))]
        (connect o out)
        (.start o 0))))
  
  (defn with-envelope 
    "play an osc note with envelope"
    [pitch vel dur [attack decay sustain fade release]]
    (let [o (osc "sine" (midi->freq pitch))
          gain-node (gain-node)
          gain (.-gain gain-node)
          now (now)
          gain-val (/ vel 127)]
      (.linearRampToValueAtTime gain 0 now) ;handle attack
      (.linearRampToValueAtTime gain gain-val (+ now attack)) ;handle attack
      (.linearRampToValueAtTime gain (* sustain gain-val) (+ now attack decay)) ;handle attack
      (.linearRampToValueAtTime gain 0 (+ now attack decay fade)) ;handle attack
      (when release 
        (.cancelScheduledValues gain (+ now dur))
        (.linearRampToValueAtTime gain 0 (+ now dur release)))
      (connect o gain-node out)
      (.start o now)
      ))
  
  ; (with-envelope 60 127 10 [0.01 0.1 0.5 1 0.1])
  
;;play
;-----------------------------------------------------------------------

  (defn note-on [channel pitch vel delay]
    (let [inst (get-instrument channel)
          {:keys [attack decay sustain fade]} inst
          buffer (get-in inst [:samples (keyword (str pitch))])
          src (set-in! (buffer-source) [:buffer] buffer)
          gain-node (set-in! (gain-node) [:gain :value] 0)
          src (set-in! src [:gain-node] gain-node)
          gain (.-gain gain-node)
          start-time (+ (now) delay)
          vel (/ vel 127)]
      (.linearRampToValueAtTime gain vel (+ start-time attack)) ;handle attack
      (.linearRampToValueAtTime gain (* vel sustain) (+ start-time attack decay)) ;handle decay and sustain
      (.linearRampToValueAtTime gain 0 (+ start-time attack decay fade)) ;handle fade
      (connect src gain-node out)
      (swap! sources assoc-in [channel pitch] src)
      (.start src start-time)))
  
  (defn note-off 
    [channel pitch delay]
    (let [release (:release (get-instrument channel))
          src (get-in @sources [channel pitch])
          gain (get-in! src [:gain-node :gain])
          stop-time (+ delay (now))]
      (.cancelScheduledValues gain stop-time)
      (.linearRampToValueAtTime gain 0 (+ stop-time release))
      (.stop src (+ stop-time release 0.1))))
    
  (defn play-note [channel pitch vel dur at]
    (note-on channel pitch vel at)
    (note-off channel pitch (+ at dur)))
  
  (defn play-line [chan notes at]
    (loop [notes notes at at]
      (when (seq notes)
        (let [{:keys [pitch velocity duration]} (first notes)]
          (play-note chan pitch velocity duration at)
          (recur (next notes) (+ at duration))))))
  
  (defn note [pitch vel dur]
    {:pitch pitch :velocity vel :duration dur})
  
  (comment 
    (load-instrument :glass "sounds/glass_harmo" "ogg")
    @instruments)
  
  (comment

    (play-line 1
      (reduce (fn [acc _] (conj acc (note (+ 50 (rand-int 20)) 70 0.5))) [] (range 5))
      0)
    
    (play-line 1
      [(note 60 70 0.5) 
       (note 64 70 0.25) 
       (note 67 70 0.25) 
       (note 71 70 0.5) 
       (note 74 70 0.5)]
      0)
    
    (play-note 1 70 127 1 0)
    (do (note-on 1 70 70 0)
        (note-off 1 70 0.5)))


