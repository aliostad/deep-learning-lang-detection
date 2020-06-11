(ns elevator-fsa.core
  (:require [clojure.test :as t]))

;; 7.3.3 - Finite State Machines
;; Elevator has 4 states:
;;   first or second floor with doors open or closed.
;; 4 distinct commands:
;;   Open or close doors, and go up or down.
;; Each command is only valid in a context:
;;   close only when open, vice-versa
;;   can only go to first floor when on second, vice versa, and doors have to be closed for both.

(defn elevator [commands]
  (letfn ;; <-- letfn lets you call other fns defined at the same time, where let is executed serially.
    [(ff-open [[_ & r]] ;; Each function returns a function that returns a value so trampoline can manage the stack.
       "When the elevator is open on the 1st floor it can either close or be done."
       #(case _
          :close (ff-closed r)
          :done true
          :false))
     (ff-closed [[_ & r]]
       "When the elevator is closed on the 1st floor it can either open or go up."
       #(case _
          :open (ff-open r)
          :up (sf-closed r)
          false))
     (sf-closed [[_ & r]]
       "When the elevator is closed on the 2nd floor it can either go down or open."
       #(case _
          :down (ff-closed r)
          :open (sf-open r)
          :false))
     (sf-open [[_ & r]]
       "When the elevator is open on the 2nd floor it can either close or be done"
       #(case _
          :close (sf-closed r)
          :done true
          false))]
    (trampoline ff-open commands)))

(elevator [:close :open :close :open :close :down :up :down :open])
(elevator [:close :up :open :close :down :open :done])


(t/run-tests)
