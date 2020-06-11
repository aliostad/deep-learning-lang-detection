(ns scratch.cljinaction
  (:use [midje.sweet]))

;; ----------------------- chapter 11 - Scaling through messaging

(defn dispatch-fn
  [dispatch-class [name & body]]
  `(defmethod ~name ~dispatch-class ~@body))

(defmacro details-mo [mo-name dispatch-class & bodies]
  `(do
     ~@(map #(dispatch-fn dispatch-class %) bodies)))

;; ----------------------- chapter 12 - Data processing with clojure

(defn parse-line
  [l]
  (let [tokens (clojure.string/split l #" ")]
    (map #(vector % 1) tokens)))

(fact
  (parse-line "this is a a test") => [["this" 1] ["is" 1] ["a" 1] ["a" 1] ["test" 1]])

(defn combine
  [mapped]
  (->> (apply concat mapped)
       (group-by first)
       (map (fn [[k v]] {k (map second v)}))
       (apply merge-with conj)))

(fact
  (combine [[["this" 1] ["is" 1] ["a" 1] ["a" 1] ["test" 1]]
            [["this" 10] ["b" 5]]]) => (contains '{"this" (1 10)
                                                  "is"   (1)
                                                  "a"    (1 1)
                                                  "test" (1)
                                                  "b"    (5)}))

(defn sum
  [[k v]]
  {k (apply + v)})

(fact
  (sum [:a [1 2 3 4]]) => {:a 10})

(defn frequence
  [m]
  (apply merge (map sum m)))

(fact
  (frequence '{"this" (1 10)
               "is"   (1)
               "a"    (1 1)
               "test" (1)
               "b"    (5)}) => (contains '{"this" 11
                                           "is"   1
                                           "a"    2
                                           "test" 1
                                           "b"    5}))
