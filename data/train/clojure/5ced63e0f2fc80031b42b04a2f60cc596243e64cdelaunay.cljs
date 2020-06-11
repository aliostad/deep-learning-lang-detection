(ns view.delaunay
  (:require [delaunay.div-conq
             :refer [pt delaunay]]
            [edge-algebra.state.app-mutators
             :refer [reset-state! wrap-with-undo]]
            [instrument.decorators
             :refer [decorate]]))


(def deco-delaunay (decorate delaunay))


(defn make-sites
  [w h how-many]
  (vec (for [_ (range how-many)]
         (pt (rand-int w) (rand-int h)))))


(defn run-delaunay
  []
  ((wrap-with-undo reset-state!))
  (let [sites (make-sites 800 400 24)]
    (println sites)
    (deco-delaunay sites)))
