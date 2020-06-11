(ns examples.chorded
  (:require [clojure.spec.test :as spec-test]
            [clojure.spec :as spec]
            [fungl.application :as application]
            (flow-gl.gui [layouts :as layouts]
                         [keyboard :as keyboard]
                         [visuals :as visuals])

            (flow-gl.graphics [font :as font])))

(def font (font/create "LiberationSans-Regular.ttf" 15))

(def state (atom #{}))

(defn text-box [color text]
  (layouts/box 5
               (visuals/rectangle color
                                  5
                                  5)
               (visuals/text [0 0 0 255]
                             font
                             text)))

(defn handle-keyboard-event [scene-graph event]
  (prn event)
  (if (and (= :keyboard (:source event))
           (not (:is-auto-repeat event)))
    (if (= :key-pressed
           (:type event))
      (swap! state conj (:character event))
      (if (= :key-released
             (:type event))
        (swap! state disj (:character event)))))
  #_(prn event)
  (application/handle-event scene-graph event))

(defn create-scene-graph [width height]
  #_(keyboard/set-focused-event-handler! handle-keyboard-event)
  (-> (text-box [255 255 255 255] (prn-str @state))
      (application/do-layout width height)))

(defn start []
  (spec-test/instrument)
  (spec/check-asserts true)
  (application/start-window create-scene-graph
                            :handle-event handle-keyboard-event)
  #_(.start (Thread. (fn []
                       (start-window)))))

