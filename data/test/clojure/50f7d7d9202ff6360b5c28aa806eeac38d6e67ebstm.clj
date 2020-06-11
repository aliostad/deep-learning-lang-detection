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
(deref foo)            ;=> 42

; Or reader-macro:

@foo                   ;=> 42

;;
;; Concurrency:
;; ------------------------------
;; - delay, future, promise

; delay:
; ------

(def metosin-home-page (delay
                         (println "Loading page...")
                         (slurp "http://www.metosin.fi")))

; not loading yet...

(deref metosin-home-page)
;stdout: Loading page...
;=> "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n...

(deref metosin-home-page)
;=> "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n...

@metosin-home-page
;=> "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n...

; future:
; -------

(def future-task (future
                   (println "Loading page...")
                   (slurp "http://www.metosin.fi")))
; returns immediatelly
(realized? future-task)  ;=> false
(deref future-task)      ; blocks until page is loaded
                         ;=> "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n...
(realized? future-task)  ;=> true

(let [task (future
             (Thread/sleep 100)
             :done)]
  (deref task))
;=> :done (after 100ms)

(let [task (future
             (Thread/sleep 100)
             :done)]
  (deref task 50 :timeout))
;=> :timeout (after 50ms)

; promise:
; --------

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

@game-status                                            ;=> {:score 42, :player "Mr. Foo"}

(reset! game-status {:player "Mr. Foo", :score  142})   ;=> {:score 142, :player "Mr. Foo"}
@game-status                                            ;=> {:score 142, :player "Mr. Foo"}

(swap! game-status update-in [:score] + 500)            ;=> {:score 642, :player "Mr. Foo"}
@game-status                                            ;=> {:score 642, :player "Mr. Foo"}

(let [events (atom [1 2 3])
      task1  (future
               (swap! events (fn [e]
                               (Thread/sleep 200)
                               (println "Adding 4 to" e)
                               (conj e 4))))
      task2 (future
              (swap! events (fn [e]
                              (Thread/sleep 400)
                              (println "Adding 5 to" e)
                              (conj e 5))))]
  (println "Waiting for tasks...")
  @task1
  @task2
  (println "All done")
  @events)

;=> [1 2 3 4 5]
; stdout:
;   Waiting for tasks...
;   Adding 4 to [1 2 3]
;   Adding 5 to [1 2 3]
;   Adding 5 to [1 2 3 4]
;   All done
