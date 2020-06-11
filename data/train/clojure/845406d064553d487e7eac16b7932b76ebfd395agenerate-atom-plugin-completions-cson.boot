#!/usr/bin/env boot

(comment
  "This script generates the `completions.cson` file used for autocompletions
   in the Alda language plugin for the Atom editor.

   This file contains instrument and attribute names.

   https://github.com/MadcapJake/language-alda/blob/master/completions.cson")

(set-env! :dependencies '[[alda "LATEST"]])

(require '[alda.lisp.model.instrument :as instrument]
         '[alda.lisp.model.attribute  :as attribute]
         '[alda.lisp.instruments.midi]
         '[alda.lisp.attributes]
         '[clojure.string             :as str])

(defn -main []
  (let [cson-format (fn [xs]
                      (->> (sort xs)
                           (map #(str "  '" % \'))
                           ((resolve 'str/join) \newline)))
        instruments (->> (resolve 'instrument/*stock-instruments*)
                         var-get
                         keys
                         cson-format)
        attributes  (->> (resolve 'attribute/*attribute-table*)
                         var-get
                         keys
                         (map name)
                         cson-format)]
    (println "'instruments': [")
    (println instruments)
    (println \])
    (println "'attributes': [")
    (println attributes)
    (println \])))
