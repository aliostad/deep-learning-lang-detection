(ns practical-clojure.6-state-management)

;; States are immutable values.
;; An identity is a link to each state which describes the thing.
;; Thus a _thing_ is a _complex_ formed by an identity and every state linked with it.

;; States are any Clojure's immutable data types.
;; Identities can be modeled using a reference type:
;; - refs manage synchronous, coordinated state
;; - agents manage asychronous, independent state
;; - atoms manage synchronous, independent state
;; - (vars ? Dunno, need some search)

;; Coordinated updates have to manage the states of several interdependent identities
;; to ensure that they are all updated at the same time and that none are left out.
;;
;; Independent identities stand on their own and an have their state updated without concern for other identities.

;; Sychronous updates to the values identities occur immediately, in the same thread from which they are invoked.
;; The execution of the code does not continue until the update has taken place.
;;
;; Asynchronous updates do not occur immediately, but at some unspecified point in the future, usually in another
;; thread. The code execution continues immediately from the point at which the update was invoked, without waiting
;; for it to complete.


;; Using refs
(def my-ref (ref 5))

(deref my-ref) ;; => 5

(+ 1 @my-ref) ;; => 6

;; refs can only be updated during a transaction.
(dosync (ref-set my-ref 2)) ;; => 2

;; The function passed to alter and commute MUST BE pure function.
;; This is because the function may be executed multiple times as the STM restries the transaction.
(dosync (alter my-ref + 3 10 100 1000)) ;; => 1115

;; The function passed to commute MUST BE a commutative function.
(dosync (commute my-ref * -1 10 100)) ;; => -1115000


;; listing 6-1. Bank accounts in STM
(def account1 (ref 1000))
(def account2 (ref 1500))

(defn transfer
  "transfer amount of money from a to b"
  [a b amount]
  (dosync
   (alter a - amount)
   (alter b + amount)))

(transfer account1 account2 300)
(transfer account2 account1 50)


;; listing 6-2. An adresse book in STM
(def my-contacts (ref []))

(defn add-contact
  "adds a contact to the provided contact list"
  [contacts contact]
  (dosync
   (alter contacts conj (ref contact))))

(defn print-contacts
  "prints a list of contacts"
  [contacts]
  (doseq [c @contacts]
    (println (str "Name:" (@c :lname) ", " (@c :fname)))))

(add-contact my-contacts {:fname "Luke" :lname "VanderHart"})
(add-contact my-contacts {:fname "Sam" :lname "Gamji"})
(add-contact my-contacts {:fname "John" :lname "Doe"})

(print-contacts my-contacts)


;; listing 6-3. Adding initials to the address book
 (defn add-initials
   "adds initials to a single contact and retuns it"
   [contact]
   (assoc contact :initials
     (str (first (contact :fname)) (first (contact :lname)))))

 (defn add-all-initials
   "adds initials to each of the contacts in a list of contacts"
   [contacts]
   (dosync
    (doseq [contact (ensure contacts)]
      (alter contact add-initials))))

 (defn print-contacts-and-initials
   "prints a list of contacts with their initials"
   [contacts]
   (doseq [c @contacts]
     (println "Name: " (@c :fname) ", " (@c :lname) " (" (@c :initials) ")")))

(add-all-initials my-contacts)
(print-contacts-and-initials my-contacts)


;; Using atoms
(def my-atom (atom 5))

(deref my-atom) ;; => 5

;; atom doesn't need a transaction to be updated
(swap! my-atom + 3) ;; => 8

(reset! my-atom 1) ;; => 1


;; Using agents
(def my-agent (agent 5))

(deref my-agent) ;; => 5

;; An agent value can be updated using send or send-off function.
;;
;; send return immediately the agent value. The action function will be applied
;; by another thread in the future.
(deref (send my-agent + 3)) ;; => 5

(deref my-agent) ;; => 8

;; send-off has an identical behavior. It is expected to be use for actions
;; spending time blocking on IO.

;; A dedicated error-handling mechanism exists to manage asynchronously updates in
;; separate thread.
;;
;; agents have one of two possible failure mode :fail or :continue.
;;
;; With the :continue mode, if an exception occurs, the agent executes an optional error-handler
;; function and continues as if the action which fails never happened.
;; While with the :fail mode the agent is put in a failed state and will not accept any more
;; actions until it is restarted.
;;
;; Default is :continue if an error-handler function exists, else it's :fail.
(error-mode my-agent) ;; => :fail
(set-error-mode! my-agent :continue)
(error-mode my-agent) ;; => :continue

(set-error-handler! my-agent (fn [agnt ex] (do (println (agent-error an-agent)))))

;; Managing agents failed state
(def an-agent (agent 5))

(deref an-agent) ;; => 5
(agent-error an-agent) ;; => nil
(send an-agent / 0) ;; 5
(send an-agent + 1) ;; java.lang.RuntimeException: Agent is failed, needs restart
(agent-error an-agent) ;; #<ArithmeticException java.langArithmeticException: Divide by zero>

;; Leave the failed state and clear the actions queue
(restart-agent my-agent @my-agent :clear-actions true)




;; To keep a track of states and identities two mechanism exist, validators and watches.
;;
;; validators are functions that can be attached to any identity and which validate any
;; update before it is committed. If a value is not approved the state of the identity
;; remains the same.
(def my-ref (ref 5))
(set-validator! my-ref (fn [x] (< 0 x)))

(dosync (alter my-ref - 10)) ;; #<CompilerException java.lang.IllegalStateException:
                             ;;   Invalid Reference State>

(dosync (alter my-ref - 10) (alter my-ref + 15)) ;; => 10

(set-validator! my-ref (fn [x] (== (rem x 5) 0)))
(get-validator my-ref) ;; => fn

(set-validator! my-ref nil)
(get-validator my-ref) ;; => nil

;; watches are functions called whenever a state changes.
(defn my-watch [key identity old-val new-val]
  (println (str "Old: " old-val))
  (println (str "New: " new-val)))

(def my-ref (ref 5))
(add-watch my-ref "watch-println" my-watch)
(dosync (alter my-ref inc)) ;; => 6

(remove-watch my-ref "watch-println")