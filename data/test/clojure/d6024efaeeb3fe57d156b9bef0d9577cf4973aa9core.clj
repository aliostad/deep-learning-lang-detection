(ns fizzbuzz.core)

(defn divisible-by [value n]
  (integer? (/ value n)))

(defn manage-divisible-by [value]
  (apply str (map #(if (divisible-by value (key %)) (val %) "") {3 "Fizz", 5 "Buzz", 7 "Wazz"})))

(defn manage-contains [value]
  (apply str (map #(cond
                    (= % \3) "Fizz"
                    (= % \5) "Buzz"
                    (= % \7) "Wazz"
                    :else "")
                  (.toString value))))

(defn fizzbuzz
  ([value] (let [for-divisible-by (manage-divisible-by value)
                 for-contains (manage-contains value)
                 result (str for-divisible-by for-contains)]
             (if (empty? result)
               (.toString value)
               result)))
  ([] (map fizzbuzz (iterate inc 1))))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))
