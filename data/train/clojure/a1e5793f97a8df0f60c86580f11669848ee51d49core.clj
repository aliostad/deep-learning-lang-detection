(ns okcampkid.core
  (:require [okcampkid.types :refer [Camper Band]]
            [schema.core :as s])
  (:gen-class))

(def menu-banner-text (slurp (clojure.java.io/resource "menubanner.txt")))

(def Campers (atom []))

(s/defn add-camper
  [camper :- Camper]
  (swap! Campers conj camper))

(s/defn prompt-for-camper :- Camper
  []
  (print "Enter the camper's name: ")
  (flush)
  (let [name (read-line)]
    (print (format "Enter %s's age:" name))
    (flush)
    (let [age (read-line)]
      (print (format "What instrument does %s play? " name))
      (flush)
      (let [instrument (read-line)]
        (add-camper {:name name :age age :instrument instrument})))))

(defn list-campers
  []
  (prn @Campers))

(defn input-repl
  []
  (loop []
    (println "Please make a selection:\n")
    (println "1) Add a new camper")
    (println "2) View current campers")
    (println "3) Edit a camper")
    (println "4) Suggest band formations")
    (println "5) Exit")
    (let [choice (read-line)
          result (cond
                  (= choice "1") (prompt-for-camper)
                  (= choice "2") (list-campers)
                  (= choice "3") "edit not implemented"
                  (= choice "4") "suggest not implemented"
                  (= choice "5") "Bye!"
                  :else "invalid choice")]
         (prn result)
      (when (not= choice "5")  (recur)))))




(defn -main
  [& args]
  (println menu-banner-text)
  (println "Welcome to OkCampKid!\n\n")
  (input-repl))
