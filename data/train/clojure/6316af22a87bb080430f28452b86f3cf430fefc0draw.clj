(ns grid.draw
  (:require [bifocals.core :as bifocals]
            [grid.color-schemes :as color-schemes]
            [grid.draw-sensors :as draw-sensors]
            [grid.pixies :as pixies]
            [grid.sound :as dynamic-sound]
            [overtone.inst.drum :as drum]
            [quil.core :as qc])
  (:use [grid.setup :only [CW DEPTH_START_SECOND_LAYER DEPTH_FAR_THRESH DEPTH_MAX HEIGHT MARGIN NCOLS NROWS RH WIDTH]]
        [grid.state :only [grid-state k-col-width k-row-height tick]]))

(defn turn-on-at [col row depth]
  (when-not (@grid-state [col row])
    (swap! grid-state #(assoc % [col row] depth))
    (dynamic-sound/hit-at col row depth)
    (when (> 0.5 (rand))
     (pixies/add-pixie-at col row depth))))

(defn turn-off-at [col row]
  (if (@grid-state [col row])
    (swap! grid-state #(assoc % [col row] false))))

(defn is-on-at? [col row depth]
  (and (> depth DEPTH_START_SECOND_LAYER)
       (< depth DEPTH_FAR_THRESH)))

(defn turn-on-off-at [col row depth is-on?]
  (if is-on?
    (turn-on-at col row depth)
    (turn-off-at col row)))

(defn display-on-off-indicator-at
  [col row depth is-on?]
  ;; Draw on/off indicator square:
  (qc/push-matrix)
  (qc/push-style)
  (cond
   is-on? (qc/fill 0 255 0 80)
   :default (qc/fill 255 0 0 80))
  (let [x (* col CW)
        y (* row RH)]
    (qc/translate (+ 5 (- x (/ CW 2))) (+ 5 (- y (/ RH 2))) 0))
  (qc/no-stroke)
  (qc/box 2)
  (qc/pop-style)
  (qc/pop-matrix))

(defn simple-depth-at
  [col row k-depth-map]
  (let [kx (* col @k-col-width)
        ky (* row @k-row-height)
        n (int (+ kx (* ky (bifocals/depth-width))))]
    (nth k-depth-map n)))

;; Draw a single grid of the instrument
(defn display-at
  [k-depth-map [col row]]
  (let [depth (simple-depth-at col row k-depth-map)
        depth (qc/constrain-float depth 0.0 DEPTH_MAX)
        was-on? (boolean (@grid-state [col row]))
         is-on? (is-on-at? col row depth)]
    (turn-on-off-at col row depth is-on?)
    ;; (display-on-off-indicator-at col row depth is-on?)
    (draw-sensors/update-display-sensor-element-at col row depth was-on? is-on?)))

;; Draw an instrument
(defn draw-grid-instrument
  [k-depth-map]
  (let [col-row-keys (keys @grid-state)]
    (dorun
     (map (partial display-at k-depth-map) col-row-keys))))

(defn draw []
  (qc/frame-rate 60)
  (bifocals/tick)
  (swap! tick inc)

  ;; Lights!
  (qc/lights)

  ;; Perspective!
  (comment (let [fov (/ Math/PI 3.0)
         camera-z (/ (/ (qc/height) 2.0) (qc/tan (/ fov 2.0)))
         wh-ratio (/ (qc/width) (qc/height) )]
     (qc/perspective fov wh-ratio (/ camera-z 2.0) (* camera-z 2.0))))

  ;; Camera!
  (let [
        ;; Museum settings
        ;; eye-y: 967
        ;; zoom-factor: 0.5668403
        
        ;;eye-x (qc/mouse-x)
        eye-x 967.0 ;; museum
        ;;s (Math/sin (* @tick (/ qc/PI 360)))
        ;;eye-x (qc/map-range s -1 1 767 1167)
        ;; eye-x 339   ;; home
        ;; _ (println "eye-x:" eye-x)

        eye-y (/ (qc/height) 2.0)
        eye-z (/ (/ (qc/height) 2.0) (qc/tan (/ (* Math/PI 60.0) 360.0)))

        ;;zoom-factor (qc/map-range (qc/mouse-y) 0 (qc/height) 0 1.0)
        zoom-factor 0.59  ;; museum
        ;; zoom-factor 0.7
        ;; zoom-factor (qc/map-range s -1 1 0.4 0.84)
        ;; zoom-factor 0.83913934 ;; home
        ;;_ (println "zoom-factor:" zoom-factor)
        eye-z (* zoom-factor (* 2.0 eye-z))
        center-x (/ (qc/width) 2.0)
        center-y (/ (qc/height) 2.0)
        center-z 0
        up-x 0
        up-y 1
        up-z 0]
    (qc/camera eye-x eye-y eye-z center-x center-y center-z up-x up-y up-z))
  (qc/no-stroke)
  (qc/background 0 0 0 255)
  (let [k-depth-map (.depthMap (bifocals/kinect))]
    (draw-sensors/draw-sensor-grid)
    (draw-grid-instrument k-depth-map)
    (pixies/draw-all-pixies)))
