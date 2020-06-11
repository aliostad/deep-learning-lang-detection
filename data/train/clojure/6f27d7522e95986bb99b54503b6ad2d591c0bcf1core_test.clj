(ns ideamind.desktop.core-test
  (:require [clojure.test :refer :all]
            [ideamind.desktop.core :as core]
            [com.stuartsierra.component :as component]
            [ideamind.test-util :as tu]
            [clojure.test :as t]
            [clojure.spec :as s]))

(defn fixture [f]
  (tu/instrument-namespaces)
  (f))

(t/use-fixtures :once fixture)

(t/deftest setup-ui
  (t/is (tu/check 'ideamind.desktop.core/ideamind-system)))

(t/deftest system-start
  (let [system         (core/ideamind-system {:show-ui false})
        started-system (component/start system)]
    (t/is (s/valid? :ideamind.model.core/Model-started (:model started-system)))
    (t/is (s/valid? :ideamind.presentation.core/Presenter-started (:presenter started-system)))
    (t/is (s/valid? :ideamind.javafx.core/View-started (:view started-system)))))
