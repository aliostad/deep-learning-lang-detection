(ns drum-journal.core
    (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

;; Note parameters
(def instruments
  #{:SD :HH :BD})

(def dynamics
  #{:p :m :f})

(def articulations
  #{:drum :rimshot :cross-stick :open :closed :splash})

(def limbs
  #{:R :L :K :H})

(def grace-notes
  #{:flam :drag})

;; Instrument options
(def instrument-parameters 
  {:SD {:dynamics #{:p :m :f}
        :articulations #{:drum :rimshot :cross-stick}
        :limbs #{:R :H}
        :grace-notes #{:flam :drag}}
   :HH {:dynamics #{:p :m :f}
        :articulations #{:open :closed}
        :limbs #{:R :H}
        :grace-notes #{:flam :drag}}
   :BD {:dynamics #{:p :m :f}
        :articulations #{:drum}
        :limbs #{:H}
        :grace-notes #{}}})

;; 
