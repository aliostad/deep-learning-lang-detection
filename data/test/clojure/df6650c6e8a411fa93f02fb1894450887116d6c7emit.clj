;; This file is part of CSound-Clojure.

;;     CSound-Clojure is free software: you can redistribute it and/or modify
;;     it under the terms of the GNU General Public License as published by
;;     the Free Software Foundation, either version 3 of the License, or
;;     (at your option) any later version.

;;     CSound-Clojure is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;     GNU General Public License for more details.

;;     You should have received a copy of the GNU General Public License
;;     along with CSound-Clojure.  If not, see <http://www.gnu.org/licenses/>.

(ns net.slothrop.csound.emit
  (:require [clojure [walk :as w]]))

(def orc-header
  "sr        =     44100
   kr        =     4410
   ksmps     =     10
   nchnls    =     1\n\n")

(defn emit-orchestra [instruments]
  (str orc-header (apply str (interleave instruments (repeat "\n\n")))))

(defn emit-score [tables notes]
  (str tables "\n\n" notes))

(defn emit-const [const]
  (str const))

(defn emit-table [params]
  (apply str "f " (interleave (map #(if (string? %) (str \" % \") %) params) (repeat " "))))

(defn emit-tables [tables]
  (apply str (interleave (map emit-table tables) (repeat "\n"))))

(defn emit-note [[_ instr start duration & params]]
  (apply str "i " instr " " start " " duration " " params))

(defn emit-notes [& notes]
  (prn notes)
  (apply str (interleave (map emit-note notes) (repeat "\n"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Code to flatten nested opcodes and
;; emit a serialized forms where each
;; nested opcode is given a name.

(defn get-var-name [opcode c]
  (symbol (str (cond
                (some #(= :k %) opcode) "k"
                (some #(= :i %) opcode) "i"
                :else "a")
               c)))

(defn name-sub-opcodes [opcode]
  (let [count (atom 0)]
    (w/postwalk
     #(if (vector? %) [(get-var-name % (swap! count inc)) %] %)
     opcode)))

(defn get-named-sub-opcodes [named]
  (filter #(and (vector? %) (symbol? (first %))) named))

(declare flatten-nested-opcode)

(defn process-sub-opcodes [named-opcode]
  (let [extracted (get-named-sub-opcodes named-opcode)]
    (if (seq extracted)
      (into [] (mapcat flatten-nested-opcode extracted))
      [])))

(defn replace-named-sub-opcodes-with-names [named-opcode]
  (letfn [(do-replace [oc] (if (and (vector? oc) (symbol? (first oc))) (first oc) oc))]
    (map do-replace named-opcode)))

(defn flatten-nested-opcode [[name named-opcode]]
  (conj (process-sub-opcodes named-opcode)
        (let [replaced (replace-named-sub-opcodes-with-names named-opcode)]
          (if (= 'out (first replaced))
            replaced
            (cons name replaced)))))

(defn opcode->str [flattened-opcode]
  (apply
   str
   (interleave
    (repeat "\n")
    (map #(apply str (butlast (interleave % (concat (repeat 2 " ") (repeat ", ")))))
         flattened-opcode))))

(defn remove-rate-specs [flattened-opcode]
  (map #(filter (fn [x] (not (some #{x} [:k :a]))) %) flattened-opcode))

(defn emit-opcode [opcode-form]
  (->> opcode-form
       (vector 'out) 
       name-sub-opcodes
       flatten-nested-opcode
       remove-rate-specs
       opcode->str))

(defn emit-instrument [[_ inum opcode]]
  (str "instr " inum
       (emit-opcode opcode)
       "\nendin"))

(comment
  (replace-named-sub-opcodes-with-names (second (name-sub-opcodes  '[:oscil 10000 :p2 [:oscil 3000 :p1]])))

  (emit-instrument '[:instrument :i101 [oscil :a 10000 [oscil :k 2000 4 [oscil :a 33 44]] 4]])
  (get-named-sub-opcodes (second (name-sub-opcodes '[oscil :a 10000 4 [oscil :k 23 33] 4])))


  (emit-table '[1 0 4096 10 1])
  )



