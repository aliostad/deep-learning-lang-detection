(ns hundred-pushups.test-helper
  (:require [clojure.spec :as s]
            [clojure.spec.test :as st]
            [clojure.string :as str]
            [clojure.test :refer [assert-expr do-report]]
            [clojure.test.check.generators :as gen]
            [clojure.test.check.random :refer [IRandom]]
            [clojure.test.check.rose-tree :as rose])
  #?(:cljs
     (:require-macros hundred-pushups.test-helper)))

(defn instrument-all [f]
  (st/instrument)
  (f)
  (st/unstrument))

(defn check-asserts [f]
  (let [old-value (s/check-asserts?)]
    (s/check-asserts true)
    (f)
    (s/check-asserts old-value)))

#?(:clj
   (defmethod assert-expr 'conforms-to? [msg form]
     (let [args (rest form)]
       `(let [result# (s/valid? ~@args)]
          (if result#
            (do-report {:type :pass :message ~msg
                        :expected '~form :actual '~form})
            (do-report {:type :fail :message ~msg
                        :expected '~form :actual (s/explain-str ~@args)}))))))


(defrecord NonRandom []
  IRandom
  (rand-long [_] 0)
  (rand-double [_] 0)
  (split [rng] [rng rng])
  (split-n [rng n] (repeat n rng)))

(defn make [spec]
  (rose/root (gen/call-gen (s/gen spec) (->NonRandom) 1)))
