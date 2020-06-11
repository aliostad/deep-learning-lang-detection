(ns intro.fp_advantages)

;; Focus on results, not steps.
(println (reduce + (map #(* 2 %) (filter odd? (range 1 20)))))

;; Focus more on what the code does rather than how it does it.
(println (for [n (range 1 101) :when (= 0 (rem n 3))] n))

;; Allow the runtime to manage state.
(def counter
  (let [tick (atom 0)]
    #(swap! tick inc)))
(println (take 10 (repeatedly counter)))

;; function composition 1
(defn negated-sum-str-1
  [& numbers]
  (str (- (apply + numbers))))
(println (negated-sum-str-1 10 12 3.4))

(def negated-sum-str-2 (comp str - +))
(println (negated-sum-str-2 10 12 3.4))

;; function composition 2
(require '[clojure.string :as str])
(def camel->keyword (comp keyword
                      str/join
                      (partial interpose \-)
                      (partial map str/lower-case)
                      #(str/split % #"(?<=[a-z])(?=[A-Z])")))
(println (camel->keyword "CamelCase"))
(println (camel->keyword "lowerCamelCase"))

;; function composition 3
(defn print-logger
  [writer]
  #(binding [*out* writer]
     (println %)))
((print-logger *out*) "hello")

(require 'clojure.java.io)
(defn file-logger
  [file]
  #(with-open [f (clojure.java.io/writer file :append true)]
     ((print-logger f) %)))
((file-logger "messages.log") "hello, log file.")

(defn multi-logger
  [& logger-fns]
  #(doseq [f logger-fns]
     (f %)))
((multi-logger
   (print-logger *out*)
   (file-logger "messages.log")) "hello again")

(defn timestamped-logger
  [logger]
  #(logger (format "[%1$tY-%1$tm-%1$te %1$tH:%1$tM:%1$tS] %2$s" (java.util.Date.) %)))
((timestamped-logger
   (multi-logger
     (print-logger *out*)
     (file-logger "messages.log"))) "Hello, timestamped logger~")
