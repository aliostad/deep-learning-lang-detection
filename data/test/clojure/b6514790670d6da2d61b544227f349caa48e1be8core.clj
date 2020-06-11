(ns spelchekr.core
  (:require [clojure.set :as sets]
            [spelchekr.rules :as rules]
            [spelchekr.trainer :as trainer]))

;;; This module contains the API to our spell checker.
;;; Note that this is meant as a straightforward
;;; introduction to Clojure and not necessarily a solid
;;; example of an industrial strength spell checking algorithm...
;;;
;;; A possible extension is to wrap this code behind a REST API or
;;; perhaps use it in a simple web-app. Perhaps we'll look into that
;;; in future labs. For now, we'll invoke everything from the REPL to
;;; get a feeling for interactive development.

;;; Shared state by atoms
;;; =====================

;;; Atoms in Clojure are reference types. They're used to manage shared state.
;;; Our use case is to keep track of the state of  our spell checker
;;; as it improves by learning new words.
(def spelling-knowledge (atom rules/initial-knowledge))

(defn- known-words
  "Encapsulate the atom access.
   This allows us to replace the in-memory
   solution with another persistent mechanism."
  []
  @spelling-knowledge)

(defn- grow-knowledge!
  "Atoms can refer to new values by
   using swap. Since atoms are designed
   for a concurrent world, they're not
   swapped directly but by a function that
   we pass. This allows the STM to retry
   the operation in case of concurrent access.

   Note the trailing '!' used to
   indicate a mutable operation."
  [new-knowledge]
  (swap! spelling-knowledge
         #(sets/union % new-knowledge)))

(defn forget-everything!
  "Forgets every learned word.
   Intended in case we mess up the
   training of out checker and want
   to start over fresh again."
  []
  (swap! spelling-knowledge
         (fn [_] #{}))) ; note the idiomatic sign of ignorance

;;; Train the spellchecker by different input sources.
;;; ==================================================

(defn train-by
  "Trains the learner with all words given in
   the provided text. Note that this input may
   consist of raw sentences and we'll clean it
   before internalizing the new knowledge."
  [sentences]
  (->
   (trainer/words-from sentences)
   (trainer/teach rules/extend-knowledge (known-words))
   grow-knowledge!))
  
(defn train-by-file
  "Trains the learner with all the text from the
   given file-name."
  [file-name]
  (train-by (slurp file-name)))
  
;;; Entry point/usage.
;;; ==================

(defn spelling-errors-in
  "Identifies spelling errors in the given sentences.
   The errors are returned in a seq."
  [sentences]
  (->>
   (trainer/words-from sentences) ; perhaps we should re-localize this function?
   (remove #(rules/check % (known-words)))))
