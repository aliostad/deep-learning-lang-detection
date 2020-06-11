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

(ns net.slothrop.csound
  (require [net.slothrop.csound [parse :as csp]
                                [opcode :as oc]]
           [clojure.contrib [shell-out :as sh]]
           [clojure [walk :as w]])
  (import [java.io File]))

(defn csound [orc sco out]
  (let [of (File/createTempFile "clj" "orc")
        sf (File/createTempFile "clj" "sco")]
    (spit of orc)
    (spit sf sco)
    (sh/sh "csound" "-W" "-o" out (.getAbsolutePath of) (.getAbsolutePath sf))))

(def tables (atom {}))

(defmacro deftable [tname params]
  `(defn ~tname []
     (swap! tables assoc ~(keyword tname) ~params)
     ~(first params)))

(def instruments (atom {}))
(def instrument-number (atom 1))

(defmacro definstrument [iname params body]
  (let [key-body (w/postwalk #(if (some #{%} params) (keyword %) %) body)
        inum (swap! instrument-number inc)
        idef [:instrument inum key-body]
        all-params (apply vector 'start 'duration params)]
    `(defn ~iname ~all-params
       (swap! instruments assoc ~inum ~idef)
       (apply vector :note ~inum ~all-params))))

(defmacro make-orc-and-sco [& notes]
  (let [note-bindings (map #(vector (gensym) %) notes)]
    `(do
       (reset! instruments {})
       (let ~(into [] (apply concat note-bindings))
         (let [orc# (csp/orchestra (vals @instruments))
               sco# (csp/score (vals @tables) ~(into [] (map first note-bindings)))]
           (csound orc# sco# "/tmp/Bosh.wav"))))))

(comment

  (deftable sine [1 0 4096 10 1])
  (deftable sawtooth [2  0 4096 10 1  0.5 0.333 0.25 0.2 0.166 0.142 0.125 0.111 0.1 0.09 0.083 0.076 0.071 0.066 0.062])
  (deftable envelope [3 0 4097 20   2  1])
  (deftable sing [4 0 0    1   "sing.aif" 0 4 0])
  
  (definstrument i101 [] (oc/oscil 10000 440 (sine)))
  (definstrument i102 [] (oc/foscil 10000 440 1 2 3 (sine)))
  (definstrument i103 [] (oc/buzz 10000 440 10 (sine)))
  (definstrument i104 [] (oc/pluck 10000 440 440 (sawtooth) 1))
  (definstrument i105 [] (oc/grain 10000 440 55 10000 10 0.5 (sine) (envelope) 1))
  (definstrument i106 [] (oc/loscil 10000 440 (sing)))
  
  (make-orc-and-sco
   (i101 0 3)
   (i102 4 3)
   (i103 8 3)
   (i104 12 3)
   (i105 16 3)
   (i106 20 3))

  (cse/emit-tables (vals @tables))
  
)