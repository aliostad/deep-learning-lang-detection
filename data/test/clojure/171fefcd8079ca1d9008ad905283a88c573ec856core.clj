(ns clojure-lunch-and-learn.core
  (:require [rhizome.viz :as viz]
            [clojure.spec :as s])
  (:gen-class))

;;; DATA

; Vector
["a" "b" "c"]

; List
'(1 2 3)

; Keyword (similar to symbols in Ruby)
:special-snowflake

; Map (Hash in Ruby)
{:name "Greenhouse" :city "New York"}

; Set
#{"fred" "ethel"}

; Composable (vector of maps)
[{:name "Greenhouse" :city "New York"}
 {:name "Dropbox" :city "San Francisco"}]










;;; EXAMPLES

; HTTP Headers
{:user-agent "Mozilla/5.0 (Macintosh)",
 :cache-control "max-age=0",
 :host "localhost:3000",
 :accept-encoding "gzip, deflate, sdch, br",
 :connection "keep-alive",
 :accept-language "en-US,en;q=0.8",
 :accept "text/html"}







; SQL (if that's your thing)
{:select [:a :b :c]
 :from [:foo]
 :where [:= :f.a "baz"]}




; HTML (Hiccup)
; <div id="hello" class="content"><p>Hello world!</p></div>
[:div {:id "hello" :class "content"}
 [:p "Hello world!"]]






; Onyx Directed Acyclic Graph (DAG)
(def graph {:in [:split-by-spaces]
            :split-by-spaces [:mixed-case]
            :mixed-case [:loud :question]
            :loud [:loud-output]
            :question [:question-output]})

(comment
  (viz/view-graph (keys graph) graph :node->descriptor (fn [n] {:label (name n)})))











;; FUNCTIONS

; Invoking functions
(+ 1 1)
(str "aa" "bb" "cc" "dd")

(+ (* 2 2) (* 3 2))

(defn welcome [name]
  (str "Hi " name "!"))

(comment
  (welcome "everyone!"))


















;; # IMMUTABLE DATA STRUCTURES

(def company {:name "Greenhouse"})

(assoc company :city "New York")

(dissoc company :name)

;; How does this work?
;;  - Structural sharing
;;  - implemented efficiently

;; Why would you want to do this?
;;  - knowing that your data structure
;;    is not going to change means
;;    it is shareable
;;  - eliminates an entire class of bugs

;; Other examples of immutability in the wild
;;  - Git
;;  - Logging











;; SO HOW DO YOU MANAGE CHANGE?
(def greenhouse-initial-state
  {:employees 200})

(def greenhouse (atom greenhouse-initial-state))

(comment
  (swap! greenhouse update :employees inc))

;; ~90% your code ends up being pure
;; functions that don't have side-effects.
;; And then there's a small part of your code
;; that deals with changing the world and
;; it is isolated













;; MACROS
(defmacro unless
  [pred then else]
  `(if (not ~pred) ~then ~else))

;; Macros are expanded at compile time

(comment
  (unless false "Return me" "Not me")

  (macroexpand '(unless false "Return me" "Not me")))

;; One of the benefits of LISP.
;; Because of this property, new
;; language features can be added
;; horizontally through libraries.
;
;; Core features of the language are
;; implemented this way
;;  - core.async (golang-like async processing)
;;  - core.match (pattern-matching)
;;  - clojure.spec (data specification)














;; BONUS!
;;
;; CLOJURE.SPEC

(s/def ::sourcing_strategy_key
  #{ "CANDIDATE_SEARCH"
     "COMPANY_MARKETING"
     "AGENCIES"})

(s/def ::strategies (s/coll-of ::sourcing_strategy_key))

(comment
  (s/valid? ::sourcing_strategy_key "blahblah")
  (s/explain ::strategies ["OTHER" "AGENCIES" "blahblah"])
  (s/explain-data ::sourcing_strategy_key "blahblah")
  (s/conform ::strategies ["CANDIDATE_SEARCH" "AGENCIES"]))
