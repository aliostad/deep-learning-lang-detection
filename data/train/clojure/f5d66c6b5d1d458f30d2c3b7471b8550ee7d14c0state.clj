(ns state
  (:require [clojure.set :as set]))

;;A state is the value of an identity at a point in time.

;; everything in clojure is a value. Clojure reference model seperates identites from state.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Almost everything in Clojure is a value. For identities, Clojure provides four reference types:                          ;;
;; • Refs manage coordinated, synchronous changes to shared state.                                                          ;;
;; • Atoms manage uncoordinated, synchronous changes to shared state. • Agents manage asynchronous changes to shared state. ;;
;; • Vars manage thread-local state.                                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; https://www.youtube.com/watch?v=cN_DpYBzKso concurrency is not paraellism

;concurrency : composition of independently executing processes.( dealing with lot of things at once) => gives a way to structure program

;parallelism : simultaneous execution of mutliple related/unrelated things.( doing many things at once.) =>


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; • A functional model that has no mutable state. Most of your code will nor- mally be in this layer, which is easier to read, easier to test, and easier to parallelize. ;;
;; • Reference models for the parts of the application that you find more con- venient to deal with using mutable state (despite its disadvantages).                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def name (ref "Phoenix"))

;;@ => reader macro
;;@name or (deref name) to access reference var
;; to change value to current reference use ref-set
(deref name)
;;use transcation/locks to protect the update:
;;clojure uses transcations : wrap in dosync

(dosync (ref-set name "foobar"))

;;STM  guarantee ACI properties (atomicity,consistency,isolation)

;; database transcations provide (ACID) durabiltiy . since clojure transcaitons are in-memory ,it does not guarantee durabiltiy

;for example


;;If you change more than one ref in a single transaction, those changes are all coordinated to “happen at the same time” from the perspective of any code outside the transaction.

(def current-track (ref "one day"))

(def current-composer (ref "kodaline"))


;;to make sure that update to current track & composition are co-ordinated we wrap the state change inside a dosync( transcation)

(dosync
 (ref-set current-track "Broken Arrows")
 (ref-set current-composer "Avicii"))

;;record
(defrecord Message [sender text])

(state.Message. "akshar" "foo" )

(def messages (ref ()))

;;add message to messages ref

(defn naive-message-add [msg]
  (dosync
   (ref-set messages (cons msg @messages))))


;; user alter to get+update

;;alter => (alter ref-name update-fn & args)
(defn add-message [msg]
  (dosync
   (alter messages conj msg)))


;;MVCC: multiversion concurrency control

;; http://sw1nn.com/blog/2012/04/11/clojure-stm-what-why-how/  READ THIS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Transcation A begins by taking a point which acts a uniqure time stamp in MVCC. it will get a sperate private copy of refs it need. (clojure prersistent data structure makes it cheap) ;;
;;                                                                                                                                                                                         ;;
;; during transcation ref works against the private copy of A.                                                                                                                             ;;
;;                                                                                                                                                                                         ;;
;; if at any point if STM detects that other transcation has set/altered a ref that transcation A wants to alter , it will force Transcation to retry.                                     ;;
;;                                                                                                                                                                                         ;;
;; alter is more cautious. what if we dont care about change made to ref and want to commit our changes..you can beat alter's performance with commute.                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;commute is a specialized variant of alter allowing for more concurrency

;;using commute updates can be any order.

;;prefer alter:

;; for a counter system, it is required that a new user gets a unique value everytime. commute reutrns the in-transcation value at any time that may be different from end transcation value.

;; always use alter in such cases.

(def counter (ref 0))


(defn next-counter []
  (dosync
   (alter counter inc)))


;; multiple ref updates are co-ordinated in a transcation while atom allows only one value to be updated..


;; signature similar to reference
;; (atom  initial-value)


(def track-name (atom "some crappy honeysingh/Badshah etc song"))

;; atoms does not participate in transcations and does not require dosync to update the value of atom use reset!

(reset! track-name "classic AmitTrivedi/KK/luckyali song")


;; can also update map

(def track-amp (atom {:composer "kodaline" :song "one day"}))


(reset! track-amp {:composer "kodaline" :song "all my friends"})

;; swap! updates an-atom by calling function f on the current value of an-atom, plus
;;any additional arg


(swap! track-amp assoc :song "random")


;;Agents  (agent intial-states)
;; same as ref. like ref you wrap agent with a initial state.

(def counter (agent 0))

;;once you have agent send a function to change the state. send queues an update-fn to run later, on a thread in a thread pool:

;;(send agent fn &args)

(send counter inc)

;;Sending to an agent is very much like commuting a ref. Tell the counter to inc
;; if you want agent to complete its exectuion you can call await (awaits forever) or (await-for timeout)

;;agents can also have validation function


(def counter (agent 0 :validator number?))


;; transcation should not have side efffects because clojure may retry transcations an aribitariy number of times.


;; however you want side effects when a transcation complete. Agents provide an solution
;;If you send an action to an agent from within a transaction, that action will be sent exactly once, if and only if the transaction succeeds.

(def messages (ref ()))
(def backup-agent (agent "output/messages-backup.clj"))


(defn add-message-with-backup [msg]
  (dosync
   (let [snapshot (commute messages conj msg)]
     (send-off backup-agent (fn [filename]
                              (spit filename snapshot)
                              filename))
snapshot)))



;;per-thread state with vars
;;When you call def or defn, you create a dynamic var, often called just a var


(def ^:dynamic foo 10)


(binding  [foo 42] foo)  ;; => 42  (thread local binding)

(defn print-foo [] (println foo)) ;; =>  10

(let [foo "let foo"] (println foo))


;; Memoization & dynamic binding


(defn ^:dynamic slow-double [n]
  (Thread/sleep 1000)
  (* n 2))

(defn calls-slow-double []
  (map slow-double [1 1 2 2 1 2]))

(time (dorun (calls-slow-double)))  ;; => time : 6019.74 ms

;;calling with dorun cuz map will return a lazy seq

;; as you can see we are doing the same function call (for values 1 ,2) memoization will help as it creates a map of previous input values to o/p values cached.

;;
(defn demo-meomize []
  (time
   (dorun
    (binding [slow-double (memoize slow-double)]
      (calls-slow-double)))))


(demo-meomize)  ;; => 2010 ms

;; rebinding functions such as slow-double also changes the behaviour of calls-slow-double
;;Functions that use dynamic bindings are not pure functions and can quickly lose the benefits of Clojure’s functional style.
