(ns starburst.wrapper
  (:require [starburst.convert :refer :all]
            [clojure.data :refer [diff]]))

(defn optional-args
  [properties required]
  (->> (into #{} required)
       (diff (into #{} properties))
       first
       (remove nil?)))

(defn add-function-signature
  [file-struct name properties required]
  (let [optional (mapv symbol
                       (optional-args properties required))]
    (-> file-struct
        (assoc-in [:function-name] (symbol name))
        (assoc-in [:function-signature]
          (symbol ((comp str vec concat) (mapv symbol required) ['& (into {} [[:keys optional]])]))))))

(defn add-function-body
  [file-struct properties]
  (assoc-in file-struct
            [:function-body]
            `(into {}
                   (remove (comp nil? second)
                           ~(mapv (comp vec list)
                                  (map str->short-ns-kword properties)
                                  (map symbol properties))))))

(defn add-function-spec
  [file-struct name properties required]
  (let [optional (set (mapv keyword
                            (optional-args properties required)))]
    (assoc-in file-struct
              [:function-spec]
              `(clojure.spec/fdef ~(symbol name)
                                  :args ~(concat (reduce concat
                                                         `(clojure.spec/cat)
                                                         (map (comp vec list)
                                                              (map keyword required)
                                                              (map str->short-ns-kword required)))
                                                 `(:optional (clojure.spec/* (clojure.spec/cat :kw ~optional
                                                                                               :val identity))))
                                  :ret ~(str->short-ns-kword name)))))

(defn add-function-instrument
  [file-struct name]
  (assoc-in file-struct
            [:function-instrument]
            `(clojure.spec.test/instrument ~(symbol (str \` name)))))

(defn add-function-with-spec
  [file-struct def-name properties required]
  (if (seq properties)
    (-> (add-function-signature file-struct def-name
                                (map reformat-name (keys properties))
                                (if-let [required required]
                                  (map reformat-name required)
                                  []))
        (add-function-body (map reformat-name (keys properties)))
        (add-function-spec def-name
                           (map reformat-name (keys properties))
                           (if-let [required required]
                             (map reformat-name required)
                             []))
        (add-function-instrument def-name))
    file-struct))

