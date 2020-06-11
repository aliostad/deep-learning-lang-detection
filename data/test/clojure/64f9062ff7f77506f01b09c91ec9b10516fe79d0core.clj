(ns makeyboard.core
  (:use     [overtone.live])
  (:require [seesaw.core :as ss]
            [overtone.inst.sampled-piano :as piano]
            [overtone.inst.synth :as synth]
            [record-and-playback.core :as rec])
  (:import  [java.awt.event KeyEvent]))

(comment
(defonce recording-atom (atom nil))

(defn stop-recording! []
  (swap! recording-atom rec/stop-recording!))

(defn start-recording! []
  (do
    (stop-recording!)
    (reset! recording-atom (rec/start-recording! 'play-note!))))

(defn playback! []
  (let [{start-time :begin-ns
         stop-time  :end-ns
         recording  :recording} @recording-atom]
    nil
    ))
)

(ss/native!)

(def key-map {"w" :C4, "a" :D4, "s" :E4, "d" :F4,
              "f" :G4, "g" :A4, "h" :B4, "j" :C5})

(defn make-note
  [^String ch]
  (note (get key-map (.toLowerCase ch) nil)))

(def instrument-to-play piano/sampled-piano) ; synth/ping

(defn play-note!
  [^String k]
  (instrument-to-play (make-note k)))

(defonce looper-threads (atom []))
(defn stop-all []
  (do
    (stop)
    (swap! looper-threads
           (fn [threads]
             (do
               (doseq [t threads] (.interrupt t))
               [])))))
(def is-recording (ref false))
(def recording (ref []))
(defn start-recording! []
  (do ;(println "starting...")
      (dosync
       (ref-set is-recording true)
       (ref-set recording [[nil (now)]]))))
(defn stop-recording! []
  (do ;(println "stopping...")
      (dosync
       (ref-set is-recording false)
       (alter recording conj [nil (now)]))))
(defn playback! []
  (let [[[_ t0] & rest] @recording
        notes           (drop-last rest)
        [_ tN]          (last rest)]
    ;(println t0 notes tN)
    (doseq [[note t] notes]
      (at (+ (now) (- t t0)) (play-note! note)))
    (let [delay (+ (- tN t0))]
      (doto
          (Thread. (fn [] (do (Thread/sleep delay) (playback!))))
        (#(swap! looper-threads conj %))
        (.start)))))

(defn handle-press
  [^KeyEvent e]
  (let [k (KeyEvent/getKeyText (.getKeyCode e))]
    (cond
      (= "O" k) (start-recording!)
      (= "P" k) (do (stop-recording!) (playback!))
      :otherwise
      (do
        (dosync
         (when @is-recording
           (alter recording conj [k (now)])))
        (play-note! k)))))

(def window
  (ss/frame :title    "The Amazing MaKeyboard"
            :size     [100 :by 100]
            :content  (ss/flow-panel
                       :items [(ss/text
                                :text "Press buttons!"
                                :editable? false
                                :listen [:key-pressed
                                         (fn [e] (handle-press e))])])
            :on-close :dispose))
