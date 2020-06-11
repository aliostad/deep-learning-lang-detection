(ns org.musicbox.composer
  (:gen-class)
  (:import [java.util Random])
  (:use [clojure.contrib.test-is]
	[clojure.contrib.str-utils :only (str-join)]
	[clojure.contrib.test-is]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Common

(def note-table ["C" "C#" "D" "D#" "E" "F"
                 "F#" "G" "G#" "A" "A#" "B"])

(def note-harmonic-table ["C" "D" "E" "F" "G" "A" "B"])

(defstruct note :duration :pitch :emphasis)
(defstruct grammar :theme :rhyme :harmony :emphasis :instrument :children)
(defstruct voice :instrument :notes)

(defn pair-off
  [x y]
  (map #(apply vector %)
       (partition 2 (interleave x y))))

(def pitch-table
     (map #(apply str %) 
          (take 120 (pair-off (cycle note-table)
                              (map #(quot % 12) (iterate inc 0))))))

(def harmonic-table
     (map #(apply str %) 
          (take 70 (pair-off (cycle note-harmonic-table)
                              (map #(quot % 12) (iterate inc 0))))))

(def pitch-map 
    (into {} 
          (take 120 (pair-off pitch-table 
                              (iterate inc 0)))))

;;;; These are utility functions for mixing voices

(defn voice-length 
  "Determine the total duration of a vector of notes"
  [voice]
  (if voice
    (reduce + (map :duration (voice :notes)))
    0))

(defn resize-voice 
  "Modulate a list of notes to be a specific (longer) total duration"
  [voice length] 
  (assoc voice 
    :notes (if (zero? length) []
	       (let [notes (voice :notes)
		     head (first notes) 
		     tail (take (count notes) (rest (cycle notes)))]
		 (if (or (<= (count notes) 1)  
			 (>= (head :duration) length))
		   (vector (assoc (if (nil? head) {:pitch "R" :emphasis 1} head)  :duration length))
		   (cons head (:notes (resize-voice (assoc voice :notes tail) 
						    (- length (head :duration))))))))))

(defn longest
  "Determines the voice with the longest total duration"
  ([voices] 
     (longest nil voices))
  ([top voices] 
     (if (= (count voices) 0)
       top
       (if (< (voice-length top) 
              (voice-length (first voices)))
         (longest (first voices) (rest voices))
         (longest top (rest voices))))))

(defn- splice 
  "Join together a sequence of meters, which itself is a sequence of voices.  Each
   meter must share the same cardinality"
  [meters] 
  (reduce #(for [x (partition 2 (interleave %1 %2))] 
             (assoc (first x) 
               :notes (apply into (map :notes x)))) 
          meters))

(defn- harmonize
  [pitch offset]
  (if (or (= offset "R") (= pitch "R"))
    "R"
    (nth pitch-table 
	 (+ (rem (pitch-map pitch) 12)
	    (pitch-map offset)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Composition

(defmulti vary 
  "Pre-order manipulation of a grammar node, dispatch on key"
  (fn [_ _ [k _]] k))

(defmethod vary :harmony
  [modulus {harmony1 :harmony} [_ harmony2]] 
  [:harmony (for [pitch harmony1]
	      (harmonize pitch (nth (cycle harmony2) modulus)))])
                
(defmethod vary :rhyme
  [modulus {rhyme1 :rhyme} [_ rhyme2]]
  [:rhyme (take (count rhyme2)
		(drop modulus (cycle (concat rhyme2 rhyme1))))]) 

(defmethod vary :theme
  [modulus {theme1 :theme} [_ theme2]]
  [:theme (map #(rem (+ (nth (cycle theme1) modulus) %) 12) theme2)])

(defmethod vary :emphasis
  [modulus {emphasis1 :emphasis} [_ emphasis2]]
  [:emphasis (take (count emphasis2)
		   (drop modulus (cycle (concat emphasis2 emphasis1))))])

(defmethod vary :default [_ _ pair] pair)

(defn- synchronize
  "Synchronize a sequence of voices (they must be the same length)"
  [voices]
  (for [voice (filter #(-> % identity :notes empty? not) voices)]
    (resize-voice voice (voice-length (longest voices)))))

(defn compose
  "Does the actual work of composing a grammar tree into a vector of voices"
  [{:keys [theme children rhyme harmony emphasis instrument] :as grammar}]
  (splice (for [modulus theme] 
            (synchronize (conj (apply concat
                                      (for [child children]
                                        (compose (into {} (map (partial vary modulus grammar) child)))))
                               (if instrument 
                                 (struct voice 
                                         instrument
                                         [(into {} (map (fn [[k v]] [k (first (drop modulus (cycle v)))])
							(struct note rhyme harmony emphasis)))])))))))

