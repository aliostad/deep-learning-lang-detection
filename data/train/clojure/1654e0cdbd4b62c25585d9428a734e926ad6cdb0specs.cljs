(ns discuss.utils.specs
  (:require [cljs.spec.alpha :as s]
            [clojure.spec.test.alpha :as stest]
            [discuss.utils.common]))

(s/fdef discuss.utils.common/trim-and-normalize
        :args (s/cat :str string?)
        :ret string?
        :fn #(<= (-> % :ret count) (-> % :args :str count)))

;; (stest/instrument 'discuss.utils.common/trim-and-normalize)
;; (s/exercise-fn `discuss.utils.common/trim-and-normalize)
;; (stest/abbrev-result (first (stest/check `discuss.utils.common/trim-and-normalize)))
