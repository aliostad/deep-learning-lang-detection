(ns canverse.core
  (:require [canverse.grid :as grid]
            [canverse.timeline :as timeline]
            [canverse.input :as input]
            [canverse.square :as square]
            [canverse.point :as point]
            [canverse.nodes :as nodes]
            [canverse.time :as time]
            [canverse.synths :as synths]
            [canverse.drums :as drums]
            [canverse.helpers :as helpers]
            [canverse.screen :as screen]
            [canverse.inst.envelopeinput :as envelope-input]
            [canverse.changeinst :as changeinst]
            [canverse.loop-toggles :as loop-toggles]

            [quil.core :as q]
            [overtone.core :as o])
  (:gen-class :main true))

(o/stop)
(def WINDOW_WIDTH 400)

(def synth-definition (atom nil))
(def frame-counter (atom 0))

(defn swap-state! [state function]
  (swap! (q/state state) function))

(defn reset-state! [state value]
  (reset! (q/state state) value))

(defn update-state! [state & args]
  (let [namespace-symbol (symbol (str "canverse." (name state)))
        update-fn (intern `~namespace-symbol 'update)
        partial-args (concat [update-fn] args)]
    (swap-state! state (apply partial partial-args))
    @(q/state state)))

(defn setup-instrument-window []
  (q/smooth)
  (q/no-stroke)
  (q/frame-rate 30)

  (q/set-state! :message (atom "Value")
                :time (atom (time/create (o/now)))
                :input (atom (input/create))))

(defn update-instrument! []
  (swap-state! :time (partial time/update (o/now)))
  (def elapsed-time (:elapsed-time @(q/state :time)))

  (swap-state! :input (partial input/update elapsed-time))
  (def user-input @(q/state :input))

  (swap! envelope-input/instance (partial envelope-input/update user-input elapsed-time)))

(defn draw-instrument []
  ; Quil has no update function that we can pass into
  ; the sketch, so we have to do it at the top of the
  ; draw call.
  (update-instrument!)
  (q/background 0)
  (envelope-input/draw @envelope-input/instance))

(defn setup []
  (q/smooth)
  (q/frame-rate 30)

  (screen/initialize WINDOW_WIDTH 400)
  (q/set-state! :grid (atom (grid/create 7 7))
                :timeline (atom (timeline/create (point/create 0 350)
                                                 (point/create WINDOW_WIDTH 45)
                                                 30000))
                :nodes (atom (nodes/create))
                :time (atom (time/create (o/now)))
                :loop-toggles (atom (loop-toggles/create (point/create (- WINDOW_WIDTH 50) 0)
                                                         (point/create 50 400)))
                :input (atom (input/create))))


(defn update! []
  (update-state! :time (o/now))
  (def elapsed-time (:elapsed-time @(q/state :time)))

  (update-state! :input elapsed-time)
  (def user-input @(q/state :input))

  (def previous-update-toggles @(q/state :loop-toggles))
  (update-state! :nodes elapsed-time user-input
                 @(q/state :grid) @(q/state :timeline) previous-update-toggles
                 @envelope-input/instance)
  (def current-nodes @(q/state :nodes))

  (update-state! :loop-toggles user-input (:loops current-nodes))

  (update-state! :grid (:active current-nodes))
  (update-state! :timeline user-input elapsed-time (nodes/get-all current-nodes))

  (reset! screen/instance (screen/update elapsed-time @screen/instance)))

(defn mouse-wheel [rotation]
  (comment 'TODO (switch-instrument rotation)))

(defn draw []
  ; Quil has no update function that we can pass into
  ; the sketch, so we have to do it at the top of the
  ; draw call.
  (update!)

  (q/background 0)
  (q/with-graphics
   (:graphics @screen/instance)

   (q/background 255 0)
   (grid/draw @(q/state :grid))
   (changeinst/draw (:elapsed-time @(q/state :time)) @(q/state :input)))

  (loop-toggles/draw @(q/state :loop-toggles))
  (timeline/draw @(q/state :timeline))
  (screen/draw @screen/instance))

(defn -main [& args]
  (q/sketch :title "Canverse"
            :setup setup
            :draw draw
            :size [WINDOW_WIDTH 400]
            :mouse-wheel mouse-wheel))

(drums/metro :bpm 50)

;(o/recording-start "~/alex1.wav")
;(o/recording-stop)

(o/stop)


