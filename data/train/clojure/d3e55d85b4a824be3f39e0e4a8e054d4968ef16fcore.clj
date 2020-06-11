(ns tailrecursion.stoke.core
  (:require
    [tailrecursion.stoke.edit           :as e]
    [tailrecursion.stoke.term           :as t]
    [tailrecursion.stoke.mode.paredit   :as p]
    [tailrecursion.stoke.mode.command   :as c]
    [tailrecursion.stoke.mode.normal    :as n]
    [tailrecursion.stoke.mode.undo      :as u]))

(defn debug-point [_]
  (binding [*print-meta* true]
    (prn (e/get-point))))

(def key-bindings
  {:normal
   {:dispatch t/mult-dispatch
    \?        debug-point
    \q        (constantly :quit)
    \u        (constantly :undo)
    \d        (constantly :delete)
    \:        (constantly :command)
    \h        n/move-left
    \^        n/move-leftmost
    \l        n/move-right
    \$        n/move-rightmost
    \j        n/move-down
    \k        n/move-up
    \L        n/move-next
    \H        n/move-prev
    \x        n/delete-point
    \c        (t/enter-mode :paredit p/paredit-mode-edit)
    \r        (t/enter-mode :paredit p/paredit-mode-replace)
    \C        (t/enter-mode :paredit p/paredit-mode-rightmost-child)
    \i        (t/enter-mode :paredit p/paredit-mode-left)
    \I        (t/enter-mode :paredit p/paredit-mode-leftmost)
    \a        (t/enter-mode :paredit p/paredit-mode-right)
    \A        (t/enter-mode :paredit p/paredit-mode-rightmost)
    \O        (t/enter-mode :paredit p/paredit-mode-break-before)
    \o        (t/enter-mode :paredit p/paredit-mode-break-after)
    (char 12) t/repaint
    \m        p/paredit-kill-prefix}
   :delete
   {:dispatch t/mult-dispatch
    (char 27) (constantly :normal)
    \d        (t/modal n/delete-siblings) 
    \h        (t/modal n/delete-left)
    \l        (t/modal n/delete-right)}
   :undo
   {:dispatch t/mult-dispatch
    (char 27) (constantly :normal)
    \h        u/undo-left
    \^        u/undo-leftmost
    \l        u/undo-right
    \$        u/undo-rightmost
    \j        u/undo-down
    \k        u/undo-up
    \L        u/undo-next
    \H        u/undo-prev}
   :paredit
   {:dispatch p/paredit-dispatch
    (char 27) (constantly :normal)}
   :command
   {:dispatch c/command-dispatch
    (char 27) (constantly :normal)
    \e        c/read-file
    \w        c/write-file}})

(defn -main [f]
  (reset! t/key-bindings key-bindings)
  (t/start-loop f))
