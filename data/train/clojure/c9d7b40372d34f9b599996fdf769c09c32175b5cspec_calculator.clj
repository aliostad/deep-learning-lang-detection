(ns spec-provider.spec-calculator
  (:require [clojure.java.io :as io]
            [incanter.stats :as stats]
            [incanter.io :as inc-io]
            [clojure.string :as str]
            [clj-fuzzy.metrics :refer [levenshtein]]
            [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [clojure.spec.test :as stest]))

(def crime-data-file "lsoa.csv")
(def baby-names-file "baby-names/StateNames.csv")

(s/def ::csv-file-name (s/and string? #(str/ends-with? % ".csv")))
(def existing-csv-files
  (->> (file-seq (io/file "./resources"))
       (map str)
       (filter #(s/valid? ::csv-file-name %))
       (map #(str/replace-first % "./resources/" ""))
       set))
(s/def ::existing-csv-file existing-csv-files)
(s/def ::column-name (s/and string? #(not= "" %)))
(s/def ::csv-header (s/coll-of ::column-name :min-count 1))
(s/def ::csv-file-data
  (s/and
   (s/every (s/coll-of any? :min-count 1) :min-count 2)
   #(->> (first %) (s/valid? ::csv-header))
   #(apply = (map count %))))


(s/fdef read-csv!
        :args (s/cat :file-name ::csv-file-name)
        :ret ::csv-file-data)
(defn read-csv! [file-name]
  (->> (line-seq (io/reader (io/resource file-name)))
       (map #(str/split % #","))))
(stest/instrument `read-csv!)


(s/fdef get-header
        :args (s/cat :xs (s/coll-of ::column-name))
        :ret (s/coll-of keyword?)
        :fn #(= (-> % :ret count) (-> % :args :xs count)))
(defn get-header [xs]
  (->> (map #(str/replace % " " "-") xs)
       (map keyword)))
(stest/instrument `get-header)


(s/fdef informed-date-parser
        :args (s/cat :format (s/and string? #(not= "" %)))
        :ret (s/fspec
              :args (s/cat :date (s/and string? #(not= "" %)))
              :ret #(instance? java.util.Date %)))
(defn informed-date-parser [format]
  (fn [date]
    (.parse (java.text.SimpleDateFormat. format) date)))
(stest/instrument `informed-date-parser)


(s/fdef parse-int
        :args (s/cat :x string?)
        :ret int?)
(defn parse-int [x]
  (when (re-matches #"\d+" x)
    (Integer. x)))
(stest/instrument `parse-int)


(s/fdef csv-column-sets
        :args (s/cat :data ::csv-file-data)
        :ret (s/tuple keyword? set?))
(defn csv-column-sets [data]
  (let [column-names (get-header (first data))
        data-rows (drop 1 data)
        column-specs (repeat (count column-names) #{})]
    (loop [data-rows data-rows
           column-specs column-specs]
      (let [[row & rows] data-rows]
        (if (nil? row)
          (map (comp identity list) column-names column-specs)
          (let [column-specs* (map conj column-specs row)]
            (recur rows column-specs*)))))))
(stest/instrument `csv-column-sets)


(->> (read-csv! crime-data-file)
     (take 15)
     csv-column-sets)

;; (stest/check `my-func {:clojure.spec.test.check/opts {:seed 123456789}})

;;(def stuff "blabla,42")
;;(str/split stuff #",")
;;
;;(defn my-funA [x]
;;  (println "A " x)
;;  x)
;;
;;(defn my-funB [x]
;;  (println "B " x)
;;  x)
;;
;;(def test (eduction (comp (map my-funA) (map my-funB)) (range 3)))
;;
;;(take 2 test)
