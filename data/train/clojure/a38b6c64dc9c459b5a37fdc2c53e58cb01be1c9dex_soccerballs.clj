(ns reactor.ex-soccerballs
  (:require [reactor.core :as r]
            [reactor.swing-support :as s]))


;; Demonstrates how to manage a bunch of things
;; that can independently react to events and are independently rendered
;; using a sampling

;; (start) starts the program


(def canvas-width 300)
(def canvas-height 300)


(defn transform
  [fn-key args t]
  (if-let [f (get t fn-key)]
    (apply (partial f t) args)
    t))

(defn step
  [ts]
  (map (partial transform :step-fn []) ts))


(defn render
  [ts]
  (s/make-shapes-map (map (partial transform :render-fn []) ts)))


(defn react
  [[ts me]]
  (map (partial transform :react-fn [me]) ts))


(defn neg
  [x]
  (* -1 x))

(defn drag
  [amount x]
  (cond
   (< x 0) (if (< x (neg amount)) (+ x amount) 0)
   (> x 0) (if (> x amount) (- x amount) 0)
   :else 0))


(defn limit
  [min max x]
  (cond
   (< x min) min
   (> x max) max
   :else x))


(defn scatter
  [amount x]
  (+ x (- amount (rand-int (inc (* 2 amount))))))


(defn move-or-bounce
  [x v size min max]
  (let [l (+ x v)
        r (+ l size)]
    (cond
     (> r max) [(- max size) (neg (drag (scatter 1 3) v))]
     (< l min) [min (neg (drag 2 v))]
     :else [l v])))


(def ball-image
  (s/load-image "ball.png"))


(defn ball-render
  [{:keys [x y w h]}]
  (s/make-image ball-image x y w h))


(defn ball-step
  [{:keys [x y w h vx vy] :as b}]
  (let [[x' vx'] (move-or-bounce x vx w 0 canvas-width)
        [y' vy'] (move-or-bounce y vy h 0 canvas-height)]
    (assoc b :x x' :y y' :vx vx' :vy vy')))


(defn ball-react
  [b me]
  (let [dx (- (:x me) (:x b))
        dy (- (:y me) (:y b))]
    (assoc b :vx (limit -15 15 dx) :vy (limit -15 15 dy))))


(defn create-balls
  [n]
  (->> (range n)
       (mapv (fn [i]
               (let [d (rand-int 50)]
                 {:x (rand-int canvas-width)
                  :y (rand-int canvas-height)
                  :w d
                  :h d
                  :vx (rand-int d)
                  :vy (rand-int d)
                  :step-fn ball-step
                  :render-fn ball-render
                  :react-fn ball-react})))))

(defn start
  []
  (r/with
   (r/network)
   (let [things (r/behavior (create-balls 10) :label "things")
         shapes (r/behavior {} :label "shapes")
         p      (s/shapes-panel shapes)
         f      (s/frame "Soccerballs" p canvas-width canvas-height)
         mouse  (s/mouse-events p)]
     (->> things
          (r/sample 50)
          (r/map step)
          (r/into things)
          (r/map render)
          (r/into shapes)
          (r/subscribe (fn [_] (.repaint p))))
     (->> mouse
          (r/filter (fn [{:keys [trigger]}]
                      (= :clicked trigger)))
          (r/map vector things)
          (r/map react)
          (r/into things))
     (->> things
          (r/sample 2000)
          (r/map (fn [ts] (->> ts
                               (drop-last (scatter 1 1))
                               (concat (create-balls (scatter 1 1)))
                               vec)))
          (r/into things)))))

