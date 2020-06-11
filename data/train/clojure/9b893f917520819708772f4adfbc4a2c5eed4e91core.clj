(ns threads-and-memory.core)

(defn -main
  "I don't do a whole lot."
  [& args]
  (println  "Hello, World!"))



;;;;;;;;;;;;;;;;;;;;;
; Delay and Threads
;;;;;;;;;;;;;;;;;;;;;

(def later (do [] (prn "Addition") (+ 1 10))) ; "Addition" => #'syntaxe.core/later
later ; => 11
(def later (delay (do [] (prn "Adding") (+ 1 10)))) ; #'syntaxe.core/later
(force later) ; "Adding" => 11
(force later) ; => 11
; evaluated once and caches the result

(do
  (Thread/sleep 3000)
  (println "hello")) ; wait 3sec .... => hello

; future create a new thread and let the current thread moved forward.
; here we wait 3 sec in the new thread
(do
  (future
    (Thread/sleep 3000)
    (println "after sleep"))
  (println "hello"))

; get the value returned by future by dereferencing
(let [new-inc (future (inc 1))]
  (println new-inc)) ; => #object[clojure.core$future_call$reify__6962 0x6fca04b3 {:status :ready, :val 2}]
(let [new-inc (future (inc 1))]
  (println (deref new-inc))) ; => 2
(let [new-inc (future (inc 1))]
  (println @new-inc)) ; => 2

; deals with time out in defer
(deref (future (Thread/sleep 1000) "Good job") 2000 "Timeout") ; => "Good job"
(deref (future (Thread/sleep 3000) "Good job") 2000 "Timeout") ; => "Timeout"

; launch multi threads
(let [result
      (map (fn [time]
             (Thread/sleep time)
             (println (str "time :" time)))
           (map #(* %1 10)
                (range 1 10)))]
  (doall result))



(def x 0)
; thread safe
(repeatedly 10
            (fn [] (def x (inc x))))
x
; not thread safe
(repeatedly 10
            (fn [] (future (def x (inc x)))))
x


;;;;;;;;;;;;;;;;;;;;;
; Atom
;;;;;;;;;;;;;;;;;;;;;
; Store a value

(def my-atom-int (atom 0))
(deref my-atom-int) ; => 0
@my-atom-int
(def my-atom-str (atom ""))
(deref my-atom-str)
(def my-atom-vec (atom [1 2 3]))
(deref my-atom-vec)

; reset! updates the value. No consideration of type
(def my-atom (atom 0))
(reset! my-atom 10)
(reset! my-atom [1 2 3])
(reset! my-atom {:a 1 :b 2})
(def my-atom (atom 0))

; swap! updates an atom with a fct
(swap! my-atom #(inc %))
(swap! my-atom (fn [atom] (+ atom atom)))

(defn mult
  [atom n]
  (* atom n))
(swap! my-atom mult 10)


; Thread Safe !!!
(def x (atom 0))
(repeatedly 10
            (fn [] (future (swap! x inc))))
@x


;;;;;;;;;;;;;;;;;;;;;
; Ref
;;;;;;;;;;;;;;;;;;;;;
; Atom manages the consistence of one element
; ref ensure consistence of myltiple states
; I manage transactions !

(def y (ref 0))
(deref y)

; do-sync update value and return last ref
; ref-set equivalent of reset!. Apply a value
(dosync
  (ref-set y 1)
  (ref-set y 2))
(deref y)
;(ref-set y 3) ; CompilerException java.lang.IllegalStateException: No transaction running, compiling:

; alter equivalent of swap!. update thanks to a function
(dosync
  (alter y (fn [ref] (inc ref) )))


(def ref1 (ref 0))
(def ref2 (ref 2))
(dosync
  (ref-set ref1 10)
  (alter ref2 #(* 5 %)))
(deref ref1)
(deref ref2)

; transaction
(def user (ref {}))
(deref user)
(dosync
  (alter user merge {:name "Kim"})
  (throw (Exception. "Something went wrong"))
  (alter user merge {:tel "+19000000000"}))
(deref user)


