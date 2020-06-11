(ns org.musicbox.genetic
  (:gen-class)
  (:import [java.util Random])
  (:require [org.musicbox.composer :as composer]
            [org.musicbox.instruments :as instruments]))

(def harmony-store (ref nil))
(def rhyme-store (ref nil))

(defstruct store-record :rating :gene)

(defn random-harmony 
  []
  (instruments/random-seq (range 4 5)  
                       (concat (take 15 (drop 14 composer/pitch-table)) 
                               ["R" "R"])))

(defn random-rhyme
  []
  (instruments/random-seq (range 2 4) (range 1 3)))

(defn populate
  [n]
  (do
    (dosync (ref-set harmony-store
                     (take n (repeatedly random-harmony))))
    (dosync (ref-set rhyme-store
                     (take n (repeatedly random-rhyme))))))

(defn evolve
  "Discard some genes in the store and add some new ones"
  [min-rating]
  (do
    (dosync (ref-set harmony-store
                     (let [new-store (filter #(> (:rating %) min-rating) @harmony-store)
                           dropped (- (count @harmony-store) (count new-store))]
                       (concat new-store
                               (take dropped (repeatedly random-harmony))))))
    (dosync (ref-set rhyme-store
                     (let [new-store (filter #(> (:rating %) min-rating) @rhyme-store)
                           dropped (- (count @rhyme-store) (count new-store))]
                       (concat new-store
                               (take dropped (repeatedly random-rhyme))))))))

(defn gen-pipe
  "Build a semi-random grammar"
  [depth children]
  (vector {:indices (instruments/random-seq (range 2 5) (range 1 4))
	   :rhyme  (nth @rhyme-store (rand-int (count @rhyme-store)))
	   :harmony (nth @harmony-store (rand-int (count @harmony-store)))
	   :emphasis (instruments/random-seq (range 2 4) (range 4 6))
	   :instrument false
	   :children (if (> depth 0)
		       (gen-pipe (dec depth) children)
		       children)}))

(defn gen-mask
  [density children]
  (vector {:indices (instruments/random-seq [1] (range 1 4))
	   :rhyme []
	   :harmony (instruments/random-seq (range 2 4) (cons "R" (take density (repeat "A0"))))
	   :emphasis []
	   :instrument false
	   :children children}))

(defn gen-voice
  "Gen a random voice, or partially random"
  [instrument octave children]
  (vector {:indices (instruments/random-seq (range 2 4) (range 1 4))
           :rhyme (nth @rhyme-store (rand-int (count @rhyme-store)))
           :harmony (nth @harmony-store (rand-int (count @harmony-store)))
           :emphasis (instruments/random-seq (range 2 4) (range 2 4))
           :instrument instrument
           :children children}))

(defn gen-bridge
  [children]
  (vector {:indices (instruments/random-seq [1] (range 1 5))
	   :rhyme []
	   :harmony ["A0"]
	   :emphasis []
	   :instrument false
	   :children children}))

(defn gen-song
  []
  (gen-pipe 0
   (vector (struct composer/grammar
                   (instruments/random-seq [4] [1 1 1 1 1 2 2 2 2 3 4])
                   []
                   (instruments/random-seq [4] ["A0" "C0" "E0"])
                   []
                   false
                   (gen-bridge 
                    (concat (gen-mask 2 
                             (gen-voice "Piano" 6 
                              (concat (gen-mask 3 
                                       (gen-voice "Piano" 7 []))
                                      (gen-mask 3 
                                       (gen-mask 2 
                                        (gen-voice "Piano" 7 []))))))
                            (gen-mask 2 
                             (gen-pipe 0 
                              (gen-mask 2 
                               (gen-voice "Piano" 5 []))))))))))
