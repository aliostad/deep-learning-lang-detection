
;; The four basic refercence types
;;  - Var  : Isolated changes within Thread
;;  - Atom : Shared + synchronous + autonomous
;;  - Agent: Shared + asynchronous + autonomous
;;  - Ref  : Shared + synchronous + co-orinated

;;  - Sharing       : Can changes be seen by more than one thread?
;;  - synchronicity : Does it happend now or some time later?
;;  - Coordination  : Do multiple changes happen automically?

;; Vars, Theads, and Binding
;; - Clojure binds valeus on a per-thread basis by default

(def ^:dynamic foo {:name "mohan" :age 22}) ;; example of a Var

(defn print-foo
  ([] (print-foo ""))
  ([prefix] (println prefix foo)))

(print-foo)

(binding [foo :some-values]
  (println foo))

(print-foo)

(use 'clojure.repl)
(doc binding)
(source binding)

(binding [foo :some-values]
  (print-foo))


(defn with-new-thread
  [f] (.start (Thread. f)))

(with-new-thread (fn [] (print-foo "new-thread:")))

(do
  (binding [foo :some-value]
    (with-new-thread
      (fn [] (print-foo "background: ")))
    (print-foo "foreground1: "))
  (print-foo "foreground2: "))

;; Mutable References

;; Atom
;; - Manage an independent value
;; - State change through swap! using ordinary function
;; - Change occurs synchronously on called thread
;; - Models compare-and-set (CAS) spin swap
;; - Function may be called more than once
;; - Guaranteed automic transition

(def foo (atom {:blah "this"}))

(class foo)
(class @foo)

(swap! foo (fn [old-value] :new-value))
(swap! foo (fn [old-value] 3))
foo
(swap! foo inc)

(pmap
 (fn [item]
   (println "item: " item)
   (swap! foo inc))
 (range 10000))

(def bar (atom 0))
(def call-counter (atom 0))

(defn slow-inc-with-call-count [x]
  (swap! call-counter inc)
  (Thread/sleep 100)
  (inc x))

(pmap
 (fn [bar-item] (swap! bar slow-inc-with-call-count))
 (range 100))

@bar
@call-counter

;; Agents
;; - Manage an independent value
;; - changes through ordinary function executed asynchronously
;; - Not actor: not distributed
;; - Use send or send-off to dispatch

(def my-agent
  (agent {:name "mohanraj" :favorites []}))

@my-agent

(defn slow-append-favorites [old-value new-fav]
  (Thread/sleep 2000)
  (assoc old-value :favorites
    (conj (:favorites old-value) new-fav)))

(do
  (send my-agent slow-append-favorites "food")
  (send my-agent slow-append-favorites "music")
  (send my-agent slow-append-favorites "books")
  (println @my-agent))

@my-agent

;; Agents and Errors
;; - Exceptions in agents cause agent to enter error state
;; - Interactions with agents in this state cause exception
;; - Errors can be examined with agent-error
;; - Error can be cleared with clear-agent-errors

(def erroring-agent (agent 3))

(defn modify-agent-with-error
  [current new]
  (if (= new 42)
    (throw (Exception. "Not 42!"))
    new))

(send erroring-agent modify-agent-with-error 42)
(agent-errors erroring-agent)

(clear-agent-errors erroring-agent)


;; Refs - to communicate with STM
;; - Allow for synchronous changes to Shared state
;; - Regs can only be changed within a transaction
;; - STM system
;; - Retries are automatic
;; - Therefore, there should be no side effects
;; - They do compose with agents, allowing for deferred side effects

(def foo (ref {:first "mohan" :last "raj" :children 1}))
@foo

(assoc @foo :blog :some-url)

@foo

(commute foo assoc :blog :some-url)
(alter foo assoc :blog :some-url)

(dosync
 (commute foo assoc :blog :some-url))

(dosync
 (alter foo assoc :blog-1 :some-url-1))

;; Macros

;; (defn with-new-thread
;;   [f] (.start (Thread. f)))

;; (with-new-thread (fn [] (print-foo "new-thread:")))

(defmacro with-new-thread [& body]
  `(.start (Thread. (fn [] ~body))))

(macroexpand-1 '(with-new-thread (print-foo "mac thread: ")))

(def r (ref 0))

(with-new-thread
  (dosync
   (println "tx1 initial:" @r)
   (alter r inc)
   (println "tx1 final:" @r)
   (Thread/sleep 5000)
   (println "tx1 done")))

(with-new-thread
  (dosync
   (println "tx2 initial:" @r)
   (Thread/sleep 1000)
   (alter r inc)
   (println "tx2 final:" @r)
   (println "tx2 done")))

(with-new-thread
  (dotimes [i 10]
    (Thread/sleep 1000)
    (dosync (alter r inc))
    (println "updated ref to" @r)))

(with-new-thread
  (dotimes [i 10]
    (println "ref is" @r)
    (Thread/sleep 1000)))

(dosync (ref-set r 0))

(with-new-thread
  (dotimes [i 10]
    (Thread/sleep 1000)
    (dosync (alter r inc))
    (println "updated ref to" @r)))

(with-new-thread
  (println "r outside is" @r)
  (dosync
   (dotimes [i 10]
     (println "iter " i)
     (println "r is " @r)
     (Thread/sleep 1000)))
  (println "r outside is" @r))

(def r1 (ref 0))
(def r2 (ref 0))

(with-new-thread
  (dotimes [i 10]
    (dosync
     (alter r1 inc)
     (Thread/sleep 500)
     (alter r2 inc))
    (println "updated ref1/2 to " @r1 " r2 = " @r2)))
(with-new-thread
  (dotimes [i 10]
    (println "r1=" @r1 "r2=" @r2)
    (Thread/sleep 500)))

;; Validatros

(def ^:dynamic thingy 17)
(set-validator! (var thingy) #(not= %1 16))

(binding [thingy 20]
  (println "thingy = " thingy))
(binding [thingy 16]
  (println "thingy = " thingy))
;; Clears it
(set-validator! (var thingy) nil)

;; Watchers

(defn my-watcher [key r old new]
  (println key r old new))

(def foo (atom 3))

(add-watch foo :my-key my-watcher)
(swap! foo inc)

(remove-watch foo :my-key)

;; Futures

(def my-future
  (future
    (Thread/sleep 5000)
    (println "Doing Stuff")
    (Thread/sleep 3000)
    17))

@my-future

;; Promises

(def my-promise (promise))

(future
  (println "Waiting for promise to be delivered...")
  (println "Delivered: " @my-promise))

(deliver my-promise :some-value)
(deliver my-promise :some-value-2)

@my-promise


;; Promise - deadlock
(def promise-1 (promise))
(def promise-2 (promise))

(future
  (println "Waiting for promise-2")
  (println @promise-2)
  (deliver promise-1 1))

(future
  (println "Waiting for promise-1")
  (println @promise-1)
  (deliver promise-2 2))


;; oscon-solve-concurrency

;; atom
(def couner (atom 0))

(defn inc-print [value]
  (println (str "---> " value))
  (inc value))

(swap! couner inc-print)

(let [n 5]
  (future (dotimes [_ n] (swap! couner inc-print)))
  (future (dotimes [_ n] (swap! couner inc-print)))
  (future (dotimes [_ n] (swap! couner inc-print))))

;; refs
(def ac1 (ref 100))
(def ac2 (ref 10))

(dosync )

