(ns mad-sounds.launchpad-mini
  (:use [slingshot.slingshot :only [throw+]])
  (:require [clojure.string :as s])
  (:require [overtone.live :refer :all])
  (:require [launchpad.device :as device])
  (:require [launchpad.grid :as grid])
  (:require [overtone.studio.midi :as midi])
  (:require [overtone.music.pitch :only [scale]]))

(defn find-launchpad
  []
  (let [launchpad-connected-receiver (first (midi/midi-find-connected-receivers "Launchpad"))
        launchpad-connected-device   (first (midi/midi-find-connected-devices "Launchpad"))
        launchpad-stateful-device    (device/stateful-launchpad launchpad-connected-device)]
    (device/map->Launchpad (assoc launchpad-stateful-device
                             :rcv launchpad-connected-receiver))))

(defonce launchpad-mini (find-launchpad))

(defn coordinate->note [y x]
  (-> device/grid-notes (nth y) (nth x)))

(defn gridseq
  "Seq of [note x y] triplets"
  []
  (for [x (range 8) y (range 8)]
    [(coordinate->note x y) x y]))

(defn controls-seq
  "Seq of [note n] triplets with n from 1 to 8"
  []
  (map (fn [note x] [note x]) (range 104 112) (range 1 9)))

(defn side-controls-seq
  "Seq of [note i n] triplets with i from 0 to 8 and n from :A to :H"
  []
  (for [i (range 8)]  [(+ 8 (* 16 i)) i (keyword (str (char (+ (int \A) 1))))]))

(defn setup-handlers [lp f key event buttons]
  (let [device     (:dev lp)
        interfaces (:interfaces lp)
        device-key (midi-full-device-key (:dev lp))]
    (doseq [[note & rest] buttons]
      (let [event-type (concat device-key [event note])
            handler (fn [_] (apply f (list* note rest)))
            key (str key "-" event "-" note)]
        ;(println event-type handler key)
        (on-event event-type handler key)))))

(defn remove-handlers
  [lp key event buttons]
  (doseq [[note & rest] buttons]
    (remove-event-handler (str key "-" event "-" note))))

(defn handle-grid
  "Setup a handler for every regular grid key, args [note x y]"
  [lp f key]
  (setup-handlers lp f (str key "grid") :note-on (gridseq)))

(defn handle-cell
  "Setup a handler for every regular grid key, args [note x y]"
  [lp x y f key]
  (setup-handlers lp f (str key "grid:" x ":" y) :note-on [[(coordinate->note x y) x y]]))

(defn handle-controls
  "Setup a handler for every top row control key, args [note n]"
  [lp f key]
  (setup-handlers lp f (str key "controls") :control-change (controls-seq)))

(defn handle-side-controls
  "Setup a handler for every side row control key, args [note i n]"
  [lp f key]
  (setup-handlers lp f (str key "side-controls") :note-on (side-controls-seq)))

(defn unhandle-grid
  [lp key]
  (remove-handlers lp (str key "grid") :note-on (gridseq)))

(defn unhandle-controls
  [lp key]
  (remove-handlers lp (str key "controls") :control-change (controls-seq)))

(defn unhandle-side-controls
  [lp key]
  (remove-handlers lp (str key "side-controls") :note-on (side-controls-seq)))

(defn lp-bind [instrument x y]
  (let [now-playing (atom nil)
        on-handler (fn [n x y] (let [inst (instrument)]
                                 (swap! now-playing (fn [_] inst))
                                 (println @now-playing)))
        off-handler (fn [n x y] (ctl @now-playing :gate 0))
        key (str "bind-" x "-" y)
        buttons [[(coordinate->note x y) x y]]]
    (println buttons)
    (setup-handlers launchpad-mini on-handler  key :note-on buttons)
    (setup-handlers launchpad-mini off-handler key :note-off buttons)))

(defn lp-bind-octave [instrument row]
  (let [now-playing (atom (vec (for [i (range 8)] nil)))
        on-handler (fn [n x y] (let [hz (midi->hz (nth (scale :C4 :major) y))
                                     inst (instrument hz)]
                                 (swap! now-playing #(assoc-in % [y] inst))
                                 (println @now-playing)
                                 ))
        off-handler (fn [n x y] (ctl (nth @now-playing y) :gate 0))
        key (str "octave-" row)
        buttons (filter (fn [[_ x _]] (= x row)) (gridseq))]
    (println buttons)
    (setup-handlers launchpad-mini on-handler  key :note-on buttons)
    (setup-handlers launchpad-mini off-handler key :note-off buttons)))


;; (comment
;;   (doseq [[x y note] (gridseq)]
;;     (println (str "x:" x ", y:" y ", note:" note)))
;;   (handle-grid launchpad-mini (fn [ & rest] (println (s/join ", " rest))) "testing")
;;   (handle-controls launchpad-mini (fn [ & rest] (println (s/join ", " rest))) "testing")
;;   (handle-side-controls launchpad-mini (fn [ & rest] (println (s/join ", " rest))) "testing")
;;   (setup-handlers launchpad-mini (fn [ & rest] (println (s/join ", " rest))) "testing" :note-on (gridseq))
;;   (do
;;     (unhandle-controls launchpad-mini  "testing")
;;     (unhandle-grid launchpad-mini "testing")
;;     (unhandle-side-controls launchpad-mini "testing"))
;; )
