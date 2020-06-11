(ns bootcamp.stm)

; package clojure.lang;
;
; public interface IDeref {
;   Object deref();
; }
;
; things that implement IDeref: delay, future, promise, atom, agent, ref, var

; use function clojure.core/deref to call IDeref.deref

(def foo (atom 42))
(deref foo)                                                 ;=> 42

; Or reader-macro:

@foo                                                        ;=> 42

;;
;; Concurrency:
;; ------------------------------
;; - delay, future, promise

; delay:
; ------

#_
(def metosin-home-page (delay
                         (println "Loading page...")
                         (slurp "http://www.metosin.fi")))

; not loading yet...
#_
(deref metosin-home-page)
;stdout: Loading page...
;=> "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n...
#_
(deref metosin-home-page)
;=> "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n...
#_
@metosin-home-page
;=> "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n...

; future:
; -------

#_
(let [future-task (future
                    (println "Loading page...")
                    (slurp "http://www.metosin.fi"))]
  ; returns immediatelly
  (println "Realized immediatelly?" (realized? future-task))
  (println "Watin 1 sec...")
  (Thread/sleep 1000)
  (println "Now realized?" (realized? future-task))
  (println "Result:" (count (deref future-task))))

#_
(let [task (future
             (Thread/sleep 100)
             :done)]
  (deref task))
;=> :done (after 100ms)

#_
(let [task (future
             (Thread/sleep 100)
             :done)]
  (deref task 50 :timeout))
;=> :timeout (after 50ms)

; promise:
; --------

#_
(let [result (promise)]
  (future
    (println "Going to use the result...")
    (let [value (+ @result 42)]
      (println "Value is" value)))
  (future
    (println "Searching for result...")
    (Thread/sleep 1000)
    (println "Found result, delivering")
    (deliver result 42)))

; stdout:
;   Going to use the result...
;   Searching for result...
;   Found result, delivering
;   Value is 84

;;
;; Software transactional memory:
;; ------------------------------
;; - manage mutable state
;; - atoms, agents and refs
;;

(def game-status (atom {:player "Mr. Foo"
                        :score  42}))

@game-status                                                ;=> {:score 42, :player "Mr. Foo"}

(reset! game-status {:player "Mr. Foo", :score  142})       ;=> {:score 142, :player "Mr. Foo"}
@game-status                                                ;=> {:score 142, :player "Mr. Foo"}

(swap! game-status update-in [:score] + 500)                ;=> {:score 642, :player "Mr. Foo"}
@game-status                                                ;=> {:score 642, :player "Mr. Foo"}

#_
(let [events (atom [1 2 3])
      task1  (future
               (swap! events (fn [e]
                               (Thread/sleep 200)
                               (println "TASK1: Adding 4 to" e)
                               (conj e 4))))
      task2 (future
              (swap! events (fn [e]
                              (Thread/sleep 400)
                              (println "TASK2: Adding 5 to" e)
                              (conj e 5))))]
  (println "Waiting for tasks...")
  @task1
  @task2
  (println "All done")
  @events)

;=> [1 2 3 4 5]
; stdout:
;   Waiting for tasks...
;   TASK1: Adding 4 to [1 2 3]
;   TASK2: Adding 5 to [1 2 3]
;   TASK2: Adding 5 to [1 2 3 4]
;   All done
