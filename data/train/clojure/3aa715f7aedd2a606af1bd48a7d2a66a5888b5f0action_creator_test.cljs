(ns rex.ext.action-creator-test
  (:require [rex.ext.action-creator :as sut]
            [cljs.test :refer-macros [deftest testing is are]]
            [rex.core :as cr]
            [rex.reducer :as rd]
            [rex.middleware :as mw]
            [rex.core-helpers :as h]))

(defn setup! []
  (h/reset-core!)

  (mw/defmiddleware
    sut/action-creator-middleware)

  (rd/defreducer
    (fn [state action]
      (let [old-field-value (get state :field [])
            event-value (get action :value :no-value)]
        (assoc-in state [:field] (conj old-field-value event-value))))))

(deftest composite-action-test
  (setup!)

  (cr/dispatch
   (fn [dispatch-fn get-store]
     (dispatch-fn {:value :value1})
     (dispatch-fn {:value :value2})))

  (is (= [:value1 :value2] (:field (cr/get-store)))))

(deftest composite-action-can-get-store-state
  (setup!)

  (let [before (atom nil)
        middle (atom nil)
        after (atom nil)]
    (cr/dispatch
     (fn [dispatch-fn get-store]
       (reset! before (get-store))
       (dispatch-fn {:value :value1})
       (reset! middle (get-store))
       (dispatch-fn {:value :value2})
       (reset! after (get-store))))

    (is (= {} @before))
    (is (= {:field [:value1]} @middle))
    (is (= {:field [:value1 :value2]} @after))))

(deftest dispatch-fn-returns-final-state-does-not-depends-on-action-creator-result
  (setup!)

  (is (= {:field [:value1 :value2]}
         (cr/dispatch
          (fn [dispatch-fn get-store]
            (dispatch-fn {:value :value1})
            (dispatch-fn {:value :value2})
            nil))))

  (is (= {:field [:value1 :value2]} (cr/get-store))))

(deftest action-creator-can-have-another-action-creator-inside
  (setup!)

  (cr/dispatch
   (fn [dispatch-fn get-store]
     (dispatch-fn {:value :value1})
     (dispatch-fn (fn [d s]
                    (d {:value :value2})))))

  (is (= [:value1 :value2] (:field (cr/get-store)))))
