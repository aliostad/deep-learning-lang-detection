;;;; Programming Clojure, 2nd Ed.

;;; The special variables *1, *2, and *3 stores the three most recent
;;; expressions. *e holds the last exception

;;; (/ 1 0)

;;; p. 19
;;; (find-doc regexp) will search documentation that matches the given regexp
;;; It searches inside the contents so may return a lot of functions

;;; p. 20
;;; to view source code

(use 'clojure.repl)
(source identity)

;;; p. 29
;;; Because data structures are immutable, any data structure can be a key
;;; in a map

;;; p. 65
;;; Sets act as functions. #{\a\e\i\o\u} is the function that tests to see
;;; whether its argument is a vowel.

;;; p. 88
;;; Referential transparency is the ability to replace a function call with
;;; its result at any time.

;;; p. 96
;;; (set! *print-length* 12)  ;; set how many items the REPL printer prints
;;; ;; default is nil

;;; p. 104
;;; mutual recursion, odd calls even

;;; p. 107
;;; add # to any recursive tail calls when using trampoline

;;; p. 109
;;; to break a recursion, all you have to do is wrap the recursion with
;;; lazy-seq

;;; p. 111
;;; expose sequences, instead of functions
;;; (def f-seq (map f (iterate inc 0)))
;;; then use (nth f-seq n)

;;; p. 113
;;; Refs manage coordinated, synchronous changes
;;; Atoms manage uncoordinated, synchronous changes
;;; Agents manage asynchronous changes
;;; Vars manage thread-local state

;;; p. 121
;;; Refs are great for coordinated access, but for updating a single piece of
;;; isolated data, prefer an atom, which are lighter-weight
