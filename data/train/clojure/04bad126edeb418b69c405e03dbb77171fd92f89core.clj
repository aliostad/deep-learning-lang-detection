(ns pacman.core
  (:use [play-clj.repl])
  (:require [play-clj.core :refer :all]
            [play-clj.g2d :refer :all]
            [play-clj.ui :refer :all]))

(def background (atom nil))
(def pellet (atom nil))
(def dead (atom false))
(def key-pressed (atom {:up    false
                        :down  false
                        :right false
                        :left  false}))

(defn create-dot
  [x y]
  (assoc @pellet :type :pellet-small, :x x, :y y, :width 3, :height 3))

(defn create-all-dots
  []
  (-> []
      (conj (map create-dot (range 45 221 16) (repeat 475)))
      (conj (map create-dot (range 45 429 16) (repeat 410)))
      (conj (map create-dot (range 45 109 16) (repeat 362)))
      (conj (map create-dot (range 365 425 16) (repeat 362)))
      (conj (map create-dot (range 253 429 16) (repeat 475)))
      (conj (map create-dot (repeat 29) (range 362 481 16)))
      (conj (map create-dot (repeat 429) (range 362 481 16)))
      (conj (map create-dot (repeat 109) (range 74 469 16)))
      (conj (map create-dot (repeat 349) (range 74 469 16)))
      (conj (map create-dot (range 45 115 16) (repeat 170)))
      (conj (map create-dot (range 349 425 16) (repeat 170)))
      (conj (map create-dot (repeat 29) (range 122 172 16)))
      (conj (map create-dot (repeat 429) (range 122 172 16)))
      (conj (create-dot 45 122))
      (conj (create-dot 413 122))
      (conj (map create-dot (repeat 61) (range 90 130 16)))
      (conj (map create-dot (repeat 397) (range 90 130 16)))
      (conj (map create-dot (range 45 109 16) (repeat 74)))
      (conj (map create-dot (range 365 425 16) (repeat 74)))
      (conj (map create-dot (repeat 29) (range 42 90 16)))
      (conj (map create-dot (repeat 429) (range 42 90 16)))
      (conj (map create-dot (range 29 445 16) (repeat 26)))
      (conj (map create-dot (repeat 205) (range 426 459 16)))
      (conj (map create-dot (repeat 253) (range 426 459 16)))
      ))

(defn within?
  [num low high]
  (and (>= num low) (<= num high)))

(defn get-color-at [x y]
  (pixmap! @background :get-pixel x (- (game :height) y)))

(defn corridor?
  [x y]
  (within? (get-color-at x y) 0 1119215))

(defn valid-move-forward
  "Returns true if the next pixel in front of the entity is not a wall"
  [entity]
  (case (:direction entity)
    :down (corridor? (+ (:x entity) 13) (- (:y entity) 1))
    :up (corridor? (+ (:x entity) 13) (- (+ (:height entity) (:y entity)) -1))
    :right (corridor? (+ (:x entity) (:width entity) 1) (+ (:y entity) 13))
    :left (corridor? (- (:x entity) 2) (+ (:y entity) 13))
    :none false))

(defn spawn-clones
  [entities]
  (loop [entities entities i (dec (count entities))]
    (if (< i 2)
      entities
      (let [curr (nth entities i)]
        (cond
          (and (= (:x curr) 0) (= (:direction curr) :left)) (recur (conj entities (assoc curr :x (dec (game :width)))) (dec i))
          (and (= (:x curr) (- (game :width) 26)) (= (:direction curr) :right)) (recur (conj entities (assoc curr :x -25)) (dec i))
          :else (recur entities (dec i)))))))

(defn clear-clones
  [entities]
  (loop [return [] i 0]
    (if (= i (count entities))
      return
      (let [curr (nth entities i)]
        (if (and (>= (:x curr) -26) (<= (:x curr) (dec (game :width)))) ;;TODO make 26 adaptive (:width curr) in this and spawn functions
          (recur (conj return curr) (inc i))
          (recur return (inc i)))))))

(defn collision?
  [guy1 guy2]
  (let [x1 (:x guy1) x2 (:x guy2)
        y1 (:y guy1) y2 (:y guy2)
        width1 (dec (:width guy1)) width2 (dec (:width guy2))
        height1 (dec (:height guy1)) height2 (dec (:height guy2))]
    (and
      (< x1 (+ x2 width2))
      (> (+ x1 width1) x2)
      (< y1 (+ y2 height2))
      (> (+ height1 y1) y2))))

(defn collision-list
  [entities]
  (remove false? (for [i (range 2 (count entities))
                       j (range 2 (count entities))]
                   (if (= (:type (nth entities i)) :player)
                     (case (:type (nth entities j))
                       :ghost (collision? (nth entities i) (nth entities j))
                       :pellet-small (if (collision? (nth entities i) (nth entities j))
                                       j
                                       false)
                       false)
                     false))))

(defn drop-nth
  [coll pos]
  (if (integer? pos)
    (vec (concat (subvec coll 0 pos) (subvec coll (inc pos))))
    coll))

(defn increment-score!
  "Totes broken"
  [entities]
  (do
    (label! (second entities) :set-text (str (+ (:score (second entities)) 10)))
    (assoc (second entities) :score (+ (:score (second entities))))))

(defn manage-collisions!
  [entities]
  (let [list (collision-list entities)]
    (do
      (reset! dead (= true (first (filter true? list))))
      ;(increment-score! (second entities))
      (drop-nth entities (first (filter integer? list))))))

(defn valid-turn
  [entity direction]
  (case direction
    :down (and
            (every? #(corridor? (:x entity) (- (:y entity) %)) (range 0 20))
            (every? #(corridor? (+ (:x entity) (:width entity)) (- (:y entity) %)) (range 0 20))
            (every? #(corridor? (+ (:x entity) (/ (:width entity) 2)) (- (:y entity) %)) (range 0 20)))
    :up (and
          (every? #(corridor? (:x entity) (+ (:y entity) (:height entity) %)) (range 0 20))
          (every? #(corridor? (+ (:x entity) (:width entity)) (+ (:y entity) (:height entity) %)) (range 0 20))
          (every? #(corridor? (+ (:x entity) (/ (:width entity) 2)) (+ (:y entity) (:height entity) %)) (range 0 20)))
    :right (and
             (every? #(corridor? (+ (:x entity) (:width entity) %) (:y entity)) (range 0 20))
             (every? #(corridor? (+ (:x entity) (:width entity) %) (+ (:y entity) (:height entity))) (range 0 20))
             (every? #(corridor? (+ (:x entity) (:width entity) %) (+ (:y entity) (/ (:height entity) 2))) (range 0 20)))
    :left (and
            (every? #(corridor? (- (:x entity) %) (:y entity)) (range 0 20))
            (every? #(corridor? (- (:x entity) %) (+ (:y entity) (:height entity))) (range 0 20))
            (every? #(corridor? (- (:x entity) %) (+ (:y entity) (/ (:height entity) 2))) (range 0 20)))
    false))

(defn move-entity
  "When called without parameters, moves the entity forward 1px"
  ([entity]
   (move-entity entity (get entity :direction)))
  ([entity direction]
   (if (valid-move-forward entity)
     (case direction
       :down (assoc entity :y (dec (:y entity)))
       :up (assoc entity :y (inc (:y entity)))
       :right (assoc entity :x (inc (:x entity)))
       :left (assoc entity :x (dec (:x entity)))
       nil)
     (assoc entity :direction :none))))

(defn change-direction
  [pacman]
  (let [direction (get (clojure.set/map-invert @key-pressed) true)]
    (if (valid-turn pacman direction)
      (case direction
        :down (-> pacman
                  (assoc :direction direction)
                  (assoc :angle 270))
        :up (-> pacman
                (assoc :direction direction)
                (assoc :angle 90))
        :right (-> pacman
                   (assoc :direction direction)
                   (assoc :angle 0))
        :left (-> pacman
                  (assoc :direction direction)
                  (assoc :angle 180)))
      pacman)))

(defn move-AI
  [ghost]
  (if (<= (:cooldown ghost) 0)
    (let [directions (atom [])]
      (do
        (when (and (valid-turn ghost :down) (not= (:direction ghost) :up))
          (swap! directions conj :down))
        (when (and (valid-turn ghost :up) (not= (:direction ghost) :down))
          (swap! directions conj :up))
        (when (and (valid-turn ghost :left) (not= (:direction ghost) :right))
          (swap! directions conj :left))
        (when (and (valid-turn ghost :right) (not= (:direction ghost) :left))
          (swap! directions conj :right))
        (when (valid-move-forward ghost)
          (swap! directions conj (:direction ghost)))

        (if (> (count @directions) 0)
          (let [index (rand-int (count @directions))]
            (if (not= (nth @directions index) (:direction ghost))
              (-> ghost
                  (assoc :direction (nth @directions index))
                  (assoc :cooldown 10)
                  (move-entity))
              (move-entity ghost)))
          ghost)))
    (if (valid-move-forward ghost)
      (-> ghost
          (assoc :cooldown (dec (:cooldown ghost)))
          (move-entity))
      (assoc ghost :cooldown (dec (:cooldown ghost))))))

(defscreen main-screen
           :on-show
           (fn [screen entities]
             (add-timer! screen :systick 1 0.01)
             (add-timer! screen :animation 1 0.075)
             (update! screen :renderer (stage))
             (reset! background (pixmap "background.png"))
             (reset! pellet (texture "pellet-small.png"))

             (let [background (assoc (texture "background.png") :type :ui, :x 1 :y 0)
                   score-text (assoc (label "Score: 0" (color :white)) :type :ui, :x 35, :y 485, :score 0)
                   pacman (assoc (texture "pacman-sheet.png") :id :pacman, :type :player, :x 208, :y 206, :width 26, :height 26, :direction :right)
                   ;(texture! pacman :set-region-x 64)
                   ;(texture! pacman :set-region-width 32)
                   blinky (assoc (texture "Adam-glow.png") :id :blinky, :type :ghost, :x 75, :y 350, :width 26, :height 26, :direction :none, :cooldown 0)
                   pinky (assoc (texture "Zach-small.png") :id :pinky, :type :ghost, :x 135, :y 350, :width 26, :height 26, :direction :none, :cooldown 0)
                   inky (assoc (texture "Kevin-small.png") :id :inky, :type :ghost, :x 195, :y 350, :width 26, :height 26, :direction :none, :cooldown 0)
                   clyde (assoc (texture "Jacob-small.png") :id :clyde, :type :ghost, :x 255, :y 350, :width 26, :height 26, :direction :none, :cooldown 0)
                   dots (create-all-dots)
                   ]
               (flatten [background score-text dots pacman blinky pinky inky clyde])))

           :on-render
           (fn [screen entities]
             (clear!)
             (render! screen entities))

           :on-key-down
           (fn [screen entities]
             (cond
               (= (:key screen) (key-code :dpad-up))
               (swap! key-pressed #(assoc-in % [:up] true))
               (= (:key screen) (key-code :dpad-down))
               (swap! key-pressed #(assoc-in % [:down] true))
               (= (:key screen) (key-code :dpad-right))
               (swap! key-pressed #(assoc-in % [:right] true))
               (= (:key screen) (key-code :dpad-left))
               (swap! key-pressed #(assoc-in % [:left] true)))
             entities)

           :on-key-up
           (fn [screen entities]
             (cond
               (= (:key screen) (key-code :dpad-up))
               (swap! key-pressed #(assoc-in % [:up] false))
               (= (:key screen) (key-code :dpad-down))
               (swap! key-pressed #(assoc-in % [:down] false))
               (= (:key screen) (key-code :dpad-right))
               (swap! key-pressed #(assoc-in % [:right] false))
               (= (:key screen) (key-code :dpad-left))
               (swap! key-pressed #(assoc-in % [:left] false)))
             entities)

           :on-touch-down
           (fn [screen entities]
             (cond
               (> (game :y) (* (game :height) (/ 2 3)))
               (println "up")
               (< (game :y) (/ (game :height) 3))
               (println "down")
               (> (game :x) (* (game :width) (/ 2 3)))
               (println "right")
               (< (game :x) (/ (game :width) 3))
               (println "left")))

           :on-timer
           (fn [screen entities]
             (case (:id screen)
               :systick
               (if (= @dead true)
                 (println "dead")
                 (let [new-entities (clear-clones (spawn-clones entities))]
                   (manage-collisions! (reduce (fn [coll e]
                                               (conj coll
                                                     (case (:type e)
                                                       :ghost (move-AI e)
                                                       :player (move-entity (change-direction e))
                                                       e)))
                                             []
                                             new-entities))))
               ;)
               :animation
               (reduce (fn [coll e]
                         (conj coll
                              (case (:id e)
                                 :pacman (if (not= (:direction e) :none)
                                           (do
                                             (texture! e :set-region-x (mod (+ (texture! e :get-region-x) 32) 96))
                                             (texture! e :set-region-width 32)
                                             e)
                                           e)
                                 :blinky (do
                                           (texture! e :set-region-x (mod (+ (texture! e :get-region-x) 26) 416))
                                           (texture! e :set-region-width 26)
                                           e)
                                 e)))
                       []
                       entities))))

(defgame pacman-game
         :on-create
         (fn [this]
           (set-screen! this main-screen)))

