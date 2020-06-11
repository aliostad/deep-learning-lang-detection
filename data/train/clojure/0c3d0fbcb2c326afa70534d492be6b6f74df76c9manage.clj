(ns hara.event.condition.manage
  (:require [hara.data.map :as map]
            [hara.event.common :as common]
            [hara.event.condition.data :as data]))

(defn manage-apply
  ""
  [f args label]
  (try
    (apply f args)
    (catch clojure.lang.ArityException e
      (throw (Exception. (str "MANAGE-APPLY: Wrong number of arguments to option key: " label))))))

(defn manage-condition
  ""
  [manager ex]
  (let [data (ex-data ex)]
    (cond (not= (:id manager) (:target data))
          (throw ex)

          (= :choose   (:hara.event.condition.data/condition data))
          (let [label  (:label data)
                f      (get (:options manager) label)
                args   (:args data)]
            (manage-apply f args label))

          (= :catch (:hara.event.condition.data/condition data))
          (:value data)

          :else (throw ex))))

