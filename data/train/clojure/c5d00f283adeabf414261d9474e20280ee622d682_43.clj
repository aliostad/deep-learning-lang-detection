;; Exercise 2.43
;; Louis Reasoner is having a terrible time doing exercise 2.42.  His queens
;; procedure seems to work, but it runs slowly.  (Louis never does manage to
;; wait long enough for it to solve even the 6 x 6 case.)  When Louis asks Eva
;; Lu Ator for help, she points out that he interchanged the order of the nested
;; mappings in the flatmap, writing it as
;;
;; (flatmap
;;  (lambda (new-row)
;;          (map (lambda (rest-of-queens)
;;                       (adjoin-position new-row k rest-of-queens))
;;               (queen-cols (- k 1))))
;;  (enumerate-interval 1 board-size))
;;
;; Explain why this interchange makes the program run slowly.  Estimate how long
;; it will take Louis's program to solve the eight-queens puzzle, assuming that
;; the program in exercise 2.42 solves the puzzle in time T.

;; The bulk of the work is carried out by the internal procedure queen-cols.  In
;; the original implementation of exercise 2.42, each invocation of queen-cols
;; can trigger at most one recursive call, with the procedure ultimately being
;; called once per column of the chessboard.
;; In Louis Reasoner's solution, the interchange of the order of the nested
;; mappings in the flatmap results in queen-cols being invoked once for each row
;; of the chessboard.  Each of these invocations may in turn trigger a recursive
;; call per row of the chessboard, resulting in a tree recursive process where
;; for any given column, queen-cols is computed multiple times.
;; The transformation of the linear recursive process to a tree recursive
;; process, results in an exponential growth of T, and in particular T^n.
