(ns sicp.streams)

(defn random-in-range
  "Returns a random number between a and b"
  [a b]
  (let [[a' b'] [(min a b) (max a b)]]
    (+ a' (rand (- b' a')))))

(defn rand-point-in-rect [[x1 x2 y1 y2]]
  [(random-in-range x1 x2) (random-in-range y1 y2)])

(defn rand-points-stream [rect]
  (cons (rand-point-in-rect rect)
        (lazy-seq (rand-points-stream rect))))

(defn satisfy-pred-stream [stream pred?]
  (map #(if (pred? %) 1 0) stream))

(defn avg-stream
  ([stream total cnt]
   (let [total' (+ total (first stream))
         cnt' (inc cnt)]
     (cons
       (/ total' cnt')
       (lazy-seq (avg-stream (next stream) total' cnt')))))
  ([stream]
   (let [val1 (first stream)]
     (cons val1
           (lazy-seq (avg-stream (next stream) val1 1))))))

(defn scale-stream [stream scalar]
  (map (partial * scalar) stream))

(defn area [[x1 x2 y1 y2]]
  (* (- (max x1 x2) (min x1 x2))
     (- (max y1 y2) (min y1 y2))))

(defn integral
  ([rect pred?]
   (integral (rand-points-stream rect) rect pred?))
  ([input rect pred?]
   (scale-stream
     (avg-stream (satisfy-pred-stream
                   input
                   pred?))
     (area rect))))

