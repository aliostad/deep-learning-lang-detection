(ns
  clojure1_overview.concurrency)

; This file is condensed. For full section see:
; http://java.ociweb.com/mark/clojure/article.html#Concurrency

; FOLLOWING COPIED FROM "defining functions" FILE FOR FUNCTIONALITY AND NOT PART OF THE CONCURRENCY TUTORIAL
(defn- polynomial
  "computes the value of a polynomial
  with the given coefficients for a given value x"
  [coefs x]
  ; For example, if coefs contains 3 values then exponents is (2 1 0).
  (let [exponents (reverse (range (count coefs)))]
    ; Multiply each coefficient by x raised to the corresponding exponent
    ; and sum those results
    ; coefs go into %1 and exponents go into %2
    (apply + (map #(* %1 (Math/pow x %2)) coefs exponents))))

(defn- derivative
  "computes the value of the derivative of a polynomial
  with the given coefficients for a given value x"
  [coefs x]
  ; The coefficients of the derivative function are obtained by
  ; multiplying all but the last coefficient by its corresponding exponent.
  ; The extra exponent will be ignored.
  (println "derivative entered")
  (let [exponents (reverse (range (count coefs)))
        derivative-coefs (map #(* %1 %2) (butlast coefs) exponents)]
    (polynomial derivative-coefs x)))

(def f (partial polynomial [2 1 3])) ; 2x^2 + x + 3
(def f-prime (partial derivative [2 1 3])) ; 4x + 1

; Wikipedia has a great definition of concurrency: "Concurrency is a property of systems in which several computations
; are executing and overlapping in time, and potentially interacting with each other. The overlapping computations
; may be executing on multiple cores in the same chip, preemptively time-shared threads on the same processor, or
; executed on physically separated processors."
; The primary challenge of concurrency is managing access to shared, mutable state.

; Support for concurrency is one of the main reasons why many developers choose to use Clojure. All data is immutable
; unless explicitly marked as mutable by using the reference types Var, Ref, Atom and Agent. These provide safe ways
; to manage shared state and are described in the section titled "Reference Types".

; The `future` macro runs a body of expressions in a different thread using one of the thread pools (CachedThreadPool)
; that are also used by Agents. This is useful for long running expressions whose results aren't needed immediately.
; The result is obtained by dereferencing the object returned by `future`. If the body hasn't yet completed when its
; result is requested, the current thread blocks until it does. Since a thread from an Agent thread pool is used,
; `shutdown-agents` should be called at some point so those threads are stopped and the application can exit.

; To demonstrate using `future`, a `println` was added to the derivative function described at the end of the
; "Defining Functions" section. It helps identify when that function is executed. Note the order of the output
; from the code below:
(println "Creating future")
(def my-future (future (f-prime 2))) ; f-prime is called in another thread
(println "Created future")
(println "result is" @my-future)
(shutdown-agents)

; The `pmap` function applies a function to all the items in a collection in parallel. It provides better performance
; than the `map` function when the function being applied is time consuming compared to the overhead of managing the threads.

; The clojure.parallel namespace provides many more functions that help with parallelizing code.
; These include par, pdistinct, pfilter-dupes, pfilter-nils, pmax, pmin, preduce, psort, psummary and pvec.
