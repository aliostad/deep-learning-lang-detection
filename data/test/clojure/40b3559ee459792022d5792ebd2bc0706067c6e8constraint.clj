(ns misc.constraint
  (:refer-clojure :exclude [range repeat])
  (:use [clojure.core :as core :only []]))

;; Verdict Flags
(def Invalid   #{})                    ; Not matching and don't continue.
(def Continue  #{:continue})           ; Not matching but continue.
(def Matching  #{:matching})           ; Matching but don't continue.
(def Satisfied #{:matching :continue}) ; Matching and continue.

(defn instance
  "Create a new instance of the constraint and manage/hide the state."
  [constraint]
  (let [[state verdict] (constraint)
        wrapped (atom state)]
    [(fn wrapper [token]
       (let [[new-state verdict] (constraint @wrapped token)]
         (reset! wrapped new-state)
         verdict))
     verdict]))

;; Should this always return true/false?  Always :matching/nil? Or is this ok?
(defn match
  "Compare constraint against a list of tokens."
  [[init test] tokens]
  (loop [[state, verdict] (init), tokens tokens]
    (if (empty? tokens)
      (:matching verdict)
      (if (:continue verdict)
        (recur (test (first tokens)), (next tokens))
        ; The previous verdict indicated no continue so this
        ; token stream can never match.
        false))))


; Constraint Library.

; Trivial constraints.

(defn any []
  (fn any-fn
    ([]            [nil Satisfied])
    ([state token] [state Satisfied])))

(defn null []
  (fn null-fn
    ([]            [nil Matching])
    ([state token] [state Invalid])))

; Token value constraints.

(defn member
  "Matches tokens that are in elements."
  [input_elements]
  (let [elements (set input_elements)]
    (fn member-fn
      ([]            [nil Satisfied])
      ([state token] [
        state
        (if (contains? elements token) Satisfied Invalid)]))))

(defn between
  "Matches tokens where: min <= count <= max."
  [min max]
  (fn between-fn
    ([]            [nil Satisfied])
    ([state token] [state (if (<= min token max) Satisfied Invalid)])))

(defn ascending
  "Matches tokens so long the current is greater than the previous."
  []
  (fn ascending-fn
    ([] [nil Satisfied])
    ([state token] [token (if (or (nil? state) (<= state token))
      Satisfied Invalid)])))

(defn alternate
  "Matches tokens so long as they occur non-consecutively."
  []
  (fn alternate-fn
    ([] [nil Satisfied])
    ([state token] [token (if (= state token) Invalid Satisfied)])))

(defn unique
  "Matches tokens so long as there are no repeats."
  []
  (fn unique-fn
    ([] [#{} Satisfied])
    ([state token] [
      (conj state token)
      (if (contains? state token) Invalid Satisfied)])))

; Token number constraints.

(defn single []
  (fn single-fn
    ([] [Matching Continue])
    ([state token] [Invalid state])))

(defn repeat
  "Matches count tokens where: min <= count <= max."
  [min max]
  (fn repeat-fn
    ([] (repeat-fn 0 nil))
    ([count token]
     (cond
       (< count min) [(inc count) Continue]
       (nil? max)    [(inc count) Satisfied]
       (= count max) [(inc count) Matching]
       (> count max) [(inc count) Invalid]
       :else         [(inc count) Satisfied]))))


; Unit testing.

(defn assert-match [constraint tokens]
  (assert (match constraint tokens)))

(defn assert-nomatch [constraint tokens]
  (assert (not (match constraint tokens))))



;(defn test-null []
;  (assert-match (null) [])
;  (assert-nomatch (null) [1]))

(defn test-any []
  (let [c (any)]
    (assert-match c [])
    (assert-match c [1 2 3])
    (assert-match c (take 9 (cycle [1 2 3])))
    (assert-match c (core/range 100))
    (assert-match c "abcdef"))
  :okay)


