;; Concurrency
;; http://java.ociweb.com/mark/clojure/article.html#Concurrency

; primary concurrency challange - manage access to shared, mutable state
; lock - hard: whichh & when to lock
; problems: deadlocks, race conditions

; Clojure - try to solve that problems:
; all data is immutable
; mutable are reference types: Var, Ref, Atom, Agent -> provide safe ways to
; easy to run function in new thread
; Java Interop -> http://jcip.net/ Java Concurrency in practice book

; future - macro, runs body in different thread using thread pool, result arent neede immediately
(defn- polynomial
  "computes the value of a polynomial
   with the given coefficients for a given value x"
  [coefs x]
  ; For example, if coefs contains 3 values then exponents is (2 1 0).
  (let [exponents (reverse (range (count coefs)))]
    ; Multiply each coefficient by x raised to the corresponding exponent
    ; and sum those results.
    ; coefs go into %1 and exponents go into %2.
    (apply + (map #(* %1 (Math/pow x %2)) coefs exponents))))

(defn- derivative
  "computes the value of the derivative of a polynomial
   with the given coefficients for a given value x"
  [coefs x]
  ; The coefficients of the derivative function are obtained by
  ; multiplying all but the last coefficient by its corresponding exponent.
  ; The extra exponent will be ignored.
  (let [exponents (reverse (range (count coefs)))
        derivative-coefs (map #(* %1 %2) (butlast coefs) exponents)]
    (polynomial derivative-coefs x)))

(def f (partial polynomial [2 1 3])) ; 2x^2 + x + 3
(def f-prime (partial derivative [2 1 3])) ; 4x + 1

(println "creating future")
(def my-future (future (f-prime 2)))   ; f-prime is called in another thread
(println "created future")
(println "result is" @my-future)
(shutdown-agents)

; pmap - parallel map
; clojure.parallel: par, pdistinct, pfilter-dupes, pfilter-nils, pmax, pmin, preduce, psort, psummary, pvec