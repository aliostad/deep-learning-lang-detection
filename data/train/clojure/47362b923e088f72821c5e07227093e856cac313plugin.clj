(ns lein-miditest.plugin
  (:require [leiningen.miditest :as midi]
            [leiningen.test :as test]
            [leiningen.core.main :as main]))

(defn ok-beep
  "The default beep for success: A timpani."
  []
  (midi/play-instrument "Timpani" 80))

(defn failure-beep
  "The default beep for failures: A french horn."
  []
  (midi/play-instrument "French Horn" 60))

(defn call-after
  "Returns a function, which takes a single function as input and returns a
  modified version which will call ok when no errors occur, and failure if an
  ExceptionInfo is thrown. Will not call ok or failure in recursive calls to f.
  If ExceptionInfo is thrown, will call leiningen.core.main/exit with
  the :exit-code from the ExceptionInfo map or 1 if it does not exist."
  [ok failure]
  (fn [f]
    (let [recursive-atom (atom 0)]
        (fn [& args]
          (let [exit-process? main/*exit-process?*
                this-recursive? (pos? @recursive-atom)]
            (try
              (swap! recursive-atom inc)
              (binding [main/*exit-process?* false]
                (let [call-result (apply f args)]
                  (when-not this-recursive?
                    (ok))
                  call-result))
              (catch clojure.lang.ExceptionInfo e
                (if exit-process?
                  (let [exit-code (get (ex-data e) :exit-code 1)]
                    (when-not this-recursive?
                      (failure))
                    (main/exit exit-code))
                  (throw e)))
              (finally
                (swap! recursive-atom dec))))))))

(defn hooks
  "Hooks for Leiningen. Alters leiningen.test/test to play sounds whenever a
  test has finished. Once this one's called, there's no going back."
  []
  (alter-var-root #'test/test
                  (call-after ok-beep failure-beep)))

;; To avoid altering functions more than once, we'll just memoize to avoid
;; multiple beeps. Unfortunately we cannot use robert.hooke because it seems
;; hard/impossible to track recursion with it, and for some other reason it
;; isn't able to track exceptions and *exit-process?* correctly.
(alter-var-root #'hooks memoize)
