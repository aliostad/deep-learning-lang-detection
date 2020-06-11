(ns canverse.square
  (:require [canverse.synths :as synths]
            [canverse.helpers :as helpers]
            [canverse.point :as point]
            [canverse.input :as input]
            [canverse.inst.envelopeinput :as envelope-input]
            [canverse.drums :as drums]

            [overtone.core :as o]
            [overtone.at-at :as a]
            [quil.core :as q]))

(def SQUARE_SIZE 50)
(def COLUMN_COLORS [
                    [128 0 128]
                    [0 0 255]
                    [0 255 255]
                    [0 255 0]
                    [255 255 0]
                    [255 165 0]
                    [255 0 0]
                    ])

(def scale (concat (o/scale :Cb4 :minor) (o/scale :Ab4 :minor)))

(defn create [row col]
  {:row row
   :col col
   :synth @synths/current-instrument
   :drums @drums/current-drum-loop
   :alpha 0})

(defn get-x [square]
  (* SQUARE_SIZE (:col square)))

(defn get-y [square]
  (* SQUARE_SIZE (:row square)))

(defn get-position [square]
  (point/create (get-x square) (get-y square)))

(defn fill-color [square]
  (get COLUMN_COLORS (:col square)))

(defn inside-bounds? [square point]
  (let [square-pos (get-position square)
        square-size (point/create SQUARE_SIZE SQUARE_SIZE)]
    (helpers/is-point-in-rect? point square-pos square-size)))

(defn is-selected? [square]
  (let [mouse-pos {:x (q/mouse-x) :y (q/mouse-y)}]
    (and
     (= (q/mouse-button) :left)
     (inside-bounds? square mouse-pos))))

(defn update-alpha [actives square]
  (assoc square
    :alpha
    (if (and (seq? actives) (is-selected? square))
      (let [node (:node (first actives))]
        (* 100 (if-not (nil? node) (o/node-get-control node :amp) 1)))
      (helpers/push-towards (:alpha square) 0 2))))

(defn play [envelope square]
  (if (input/right-mouse-click?)
    (let [row (keyword (str (:row square)))]
      (drums/play-drum-at row)))
    (let [synth (:synth square)
          col (:col square)
          row (:row square)
          freq (nth scale col)
          synth-args (conj {:freq freq :amp 0.01} (envelope-input/get-params envelope))
          node (helpers/apply-hash synth synth-args)]
      node))

(defn update [actives square]
  (update-alpha actives square))

(defn update-square-synth [square]
  (assoc square :synth @synths/current-instrument))

(defn draw [square]
  (q/stroke 125 25)

  (if (nil? (get @drums/sched-jobs (keyword (str (:row square)))))
    (do
      (q/stroke 125 25)
      (q/stroke-weight 2))
    (do
      (apply q/stroke (conj (nth COLUMN_COLORS (:row square)) 25))
      (q/stroke-weight 5)))

  (apply q/fill (conj (fill-color square) (:alpha square)))
  (let [x (get-x square)
        y (get-y square)]
    (q/rect x y SQUARE_SIZE SQUARE_SIZE)))
