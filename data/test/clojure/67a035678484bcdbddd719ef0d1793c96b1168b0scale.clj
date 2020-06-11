(ns examples.scale
  (:require [clojure.spec.test :as spec-test]
            [clojure.spec :as spec]
            [fungl.application :as application]
            (flow-gl.gui [visuals :as visuals]
                         [animation :as animation])
            (fungl [layout :as layout]
                   [layouts :as layouts])))


(defn create-scene-graph [width height]
  (animation/swap-state! animation/start-if-not-running :zoom)
  (prn (animation/running? @animation/state-atom :zoom))
  (prn (animation/phase! :zoom
                         1000))
  #_(animation/swap-state! animation/set-wake-up 1000)
  (-> (layouts/scale 1 (+ 1
                          (* 2 (animation/ping-pong 10
                                                    (animation/phase! :zoom
                                                                      1000))))
                     (layouts/horizontally
                      (layouts/scale 1
                                     0.5
                                     (layouts/vertically
                                      (layouts/scale 3 2
                                                     (assoc (visuals/rectangle [255 255 255 255] 0 0)
                                                            :width 10
                                                            :height 10
                                                            :x 10
                                                            :y 10))
                                      (visuals/text "foo 1")))
                      (layouts/scale 1
                                     2
                                     (layouts/vertically
                                      (layouts/scale 2 2
                                                     (visuals/text "foo 2"))
                                      (visuals/text "foo 3")))))
      (application/do-layout width height)))

(defn start []
  (spec-test/instrument)
  (spec/check-asserts true)
  (application/start-window #'create-scene-graph :target-frame-rate 5)
  #_(.start (Thread. (fn []
                       (start-window)))))



