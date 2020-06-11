(ns clj-test.expound-test
  (:require [clojure.spec.alpha :as s]
            [expound.alpha :as expound]
            [orchestra.spec.test :as st]))

;; spec
(s/def :example.place/city string?)
(s/def :example.place/state string?)
(s/def :example/place (s/keys :req-un [:example.place/city :example.place/state]))

;; -------------------------
;; normal spec explain
;; -------------------------
(s/explain :example/place {})
; val: {} fails spec: :example/place predicate: (contains? % :city)
; val: {} fails spec: :example/place predicate: (contains? % :state)
; :clojure.spec.alpha/spec  :example/place
; :clojure.spec.alpha/value  {}

;; -------------------------
;; with expound
;; -------------------------
(expound/expound :example/place {})
; -- Spec failed --------------------
; {}
; should contain keys: `:city`,`:state`

(expound/expound :example/place {:city "Denver", :state :CO})
; -- Spec failed --------------------
; {:city ..., :state :CO}
;                    ^^^
; should satisfy
;   string?

;; -------------------------
;; with orchestra instrument
;; -------------------------
(set! s/*explain-out* expound/printer)
(st/instrument)

(let [a 1 b]
  (println "done"))
; Call to clojure.core/let did not conform to spec:
; -- Syntax error -------------------

;   ([a 1 b] ...)
;    ^^^^^^^

; should have additional elements. The next element is named `:args` and satisfies

;   any?