(ns proletariat.mocks
  "Utilties for mocking parts of a program for testing different scenarios.
  Should *only* be used in unit tests as we are mucking about under the hood."
  (:require [clojure.spec.alpha :as spec])
  (:import [clojure.lang MultiFn]))

(defn reset-methods
  "Resets all methods associated with the given Multimethod to match what
  is in the provided map of dispatch->fn."
  [multi m]
  (remove-all-methods multi)
  (doseq [[dispatch f] m]
    (.addMethod ^MultiFn multi dispatch f)))

(defn replace-method
  "Replaces the Multimethod with the given dispatch with the given function"
  [multi dispatch f]
  (remove-method multi dispatch)
  (.addMethod ^MultiFn multi dispatch f))

(spec/fdef multimock
  :args (spec/cat :multi    symbol?
                  :bindings (spec/and vector?
                                      #(even? (count %)))
                  :body     (spec/* any?))
  :ret any?)

(defmacro multimock
  "Creates a mock binding scope allowing a user to replace multimethod
  functionality for the given Multimethod.  Takes a MultiFn (defmulti) and a
  vector of [dispatch fn] bindings to replace.  The body is executed with
  the updated multimethods and the original multimethod definitions are
  replaced upon completion.  Returns the result of body.

  Example:

    (defmulti foo (fn [a b] a))

    (defmethod foo :bar [a b] [a b])

    (foo :bar 1)
    => [:bar 1]

    (multimock foo
      [:bar (fn [a b] [a (inc b)])]
      (foo :bar 1))
    => [:bar 2]
  "
  [multi bindings & body]
  `(let [orig# (methods ~multi)]
     (try
       (doseq [[dispatch# f#] (partition 2 ~bindings)]
         (replace-method ~multi dispatch# f#))
       ~@body
       (finally
         (reset-methods ~multi orig#)))))
