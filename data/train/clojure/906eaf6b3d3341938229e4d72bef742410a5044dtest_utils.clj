(ns todo.test-utils
  (:require [todo.component.datomic :as datomic]
            [com.stuartsierra.component :as component]
            [datomic.api :as d]))

(def test-config {:transactor-uri "datomic:mem://todododo-test"})

(def ^:dynamic conn nil)

(defn wrap-manage-datomic
  [test]
  (let [datomic-component (-> (datomic/datomic test-config)
                              (component/start))]
    (binding [conn (:conn datomic-component)]
      (test)
      (d/delete-database (:transactor-uri test-config)))))
