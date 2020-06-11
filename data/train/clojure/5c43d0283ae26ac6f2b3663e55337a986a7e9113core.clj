(ns codebreaker.core
  (:require [clojure.spec.alpha :as s]
            [clojure.spec.test.alpha :as stest]
            [clojure.spec.gen.alpha :as gen])
  (:gen-class))
;; Use namespaced keywords for specs!

;; -----------------------------------------------------------------------------
;; Spec-Warmup

(s/def ::hello-world (s/and string? not-empty))
(s/exercise ::hello-world)
(s/valid? ::hello-world "Hello, World!")
(s/valid? ::hello-world "")

;; Let's spec a function. The fn does not need to exist yet.
(s/fdef add
        :args (s/cat :a int? :b int?) ;; Define the arguments
        :ret int?                     ;; and the return value
        :fn (fn [{:keys [args ret]}]   ;; Now, add a verification-function. fn
              (let [a (:a args)       ;; can access arguments and return-values.
                    b (:b args)]      ;; Often inverse functions can be applied.
                (= ret (+ a b)))))

;; Get sample-values for the definition of the arguments
(s/exercise (:args (s/get-spec `add)))

;; Provide a sample input for add and check if it conforms to the spec
(s/conform (:args (s/get-spec `add))
           [4 2])

;; Now we have the definition and we can define the function itself
(defn add
  "My awesome add function."
  [a b]
  (+ a b))

;; You can enable instrumentation for functions to get runtime-information about
;; wrong arguments in your function (for use in dev-mode).
(comment
  (stest/instrument `add)
  (add 4 :foo)
  )

;; You can turn off instrument to have normal behavior as you'd expect it in
;; production mode.
(comment
  (stest/unstrument `add)
  (add 4 :foo)
  )

;; Generate 1000 tests for our function. Re-run this function multiple times.
(stest/check `add)
;; Q: Sometimes you can get an integer overflow. Why?

;; Try to modify the return value of :fn in our spec to see an error described
;; by the spec, e.g. change `=` to `not=` and re-run the tests, but summarize
;; the results for better readability.
(stest/summarize-results (stest/check `add))

;; Specs appear in the docs!
(comment
  (use 'clojure.repl)
  (doc add)
  )


;; -----------------------------------------------------------------------------
;; Now it's your turn. Start with codebreaker!
