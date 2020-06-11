(ns randomness.core)

(def rng (java.util.Random.))
(def delta 0.1)

(defn random-bit [p]
  (if (< (.nextDouble rng) p) 1 0))

(defn random-stream-fair []
  (repeatedly #(random-bit 0.5)))

(defn random-stream-unfair [p]
  (let [bit (random-bit p)
        prob (-> p
                 ((fn [p] (if (= bit 1) (- p delta) (+ p delta))))
                 (max 0.0)
                 (min 1.0))]
    (lazy-seq (cons bit (random-stream-unfair prob)))))

(defn random-stream-unfair2 [p]
  (let [bit (random-bit p)
        prob (-> p
                 ((fn [p] (if (= bit 0) (- p delta) (+ p delta))))
                 (max 0.0)
                 (min 1.0))]
    (lazy-seq (cons bit (random-stream-unfair prob)))))
