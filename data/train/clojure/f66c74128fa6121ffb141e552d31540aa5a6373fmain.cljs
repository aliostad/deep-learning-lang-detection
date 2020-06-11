(ns game-of-life.containers.main
  (:require [game-of-life.components.grid :refer [grid-component]]
            [game-of-life.components.grid-controls :refer [grid-controls-component]]
            [re-frame.core :refer [subscribe
                                   dispatch]]))
(defn tick []
  (js/requestAnimationFrame
    (fn []
      (do
        (dispatch [:next-gen])
        (tick)))))

(defn main-container []
  (let [board (subscribe [:board])
        profiler (subscribe [:profiler])]
    (fn []
      [:div
       (grid-controls-component @profiler {:reset #(dispatch [:reset])
                                           :tick #(dispatch [:next-gen])
                                           :randomize #(dispatch [:randomize])})
       (grid-component @board {:toggle-cell #(dispatch [:toggle-cell %])})])))
