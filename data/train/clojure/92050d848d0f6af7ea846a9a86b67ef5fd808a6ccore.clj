(ns evo-images.core
  (:gen-class)
  (:require [clojure.spec.test :as stest]
            [evo-images.drawing :refer [dominant-color draw setup-sketch!]]
            [evo-images.evolution :refer [evolve init-state]]
            [quil.core :as q]
            [quil.middleware :as m]))

(defn setup [img-src]
  (fn []
    (setup-sketch! img-src)
    (init-state (dominant-color img-src))))

(defn start [img-src]
  (q/defsketch evo-images
    :title "Evolving images"
    :size [800 300]

    :setup  (setup (or img-src "botw.jpg"))
    :update evolve
    :draw   draw

    ;; :features [:keep-on-top]
    :middleware [m/fun-mode]))

(defn -main [& args]
  (start (first args)))


;; (stest/unstrument)
;; (stest/instrument)
