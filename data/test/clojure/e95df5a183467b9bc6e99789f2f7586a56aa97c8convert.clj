(ns noble.convert
  (:require [clojure.string :as str]
            [clojure.spec.test.alpha :as stest]
            [clojure.spec.alpha :as s]))

(defn vec->str
  "Convert a vector to a string conforming to a field-query in GraphQL."
  [vec]
  (let [strs (mapv name vec)]
    (str/join " " strs)))
;; (vec->str [:iamgroot])
;; (stest/instrument `vec->str)

(defn convert-type
  "Takes a map containing a definition of a type, which should be queried by
  GraphQL."
  [type-tuple]
  (let [nk (-> type-tuple keys first name)
        str-vec (-> type-tuple vals first vec->str)]
    (format "%s { %s }" nk str-vec)))
;; (convert-type {:foo [:bar]})
;; (stest/instrument `convert-type)

