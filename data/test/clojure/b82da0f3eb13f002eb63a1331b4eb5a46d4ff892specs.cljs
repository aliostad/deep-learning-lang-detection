(ns discuss.references.specs
  (:require [cljs.spec.alpha :as s]
            [clojure.spec.test.alpha :as stest]
            [discuss.references.lib]))

(s/fdef discuss.references.lib/split-at-string
        :args (s/cat :body string? :query string?)
        :ret (s/cat :first (s/? string?) :second (s/? string?))
        :fn #(cond
               (= 2 (-> % :ret count))
               (= (-> % :args :body) (str (-> % :ret :first) (-> % :args :query) (-> % :ret :second)))
               (<= 0 (-> % :ret count) 1) true))

;; (stest/instrument 'discuss.references.lib/split-at-string)
;; (s/exercise-fn `discuss.references.lib/split-at-string 50)
