(ns de.phenomdevel.money-control.handler.route
  (:require
   [re-frame.core :refer [reg-event-db dispatch reg-event-fx]]

   [de.phenomdevel.money-control.handler.interceptor.common :as ic]))


;; =============================================================================
;; Handler: Route

(reg-event-fx :route.current/set
  [ic/loading-false]
  (fn [{:keys [db]} [_ route]]
    (let [dispatch
          (case route
            :categories/show
            [:remote/read
             [:categories]]

            :expenses/show
            [:remote/read
             [:users
              :categories
              :accounting_entry/expenses]]

            :incomes/show
            [:remote/read
             [:users
              :categories
              :accounting_entry/incomes]]

            :dashboard/show
            [:remote/read
             [:users
              :categories
              :accounting_entry/incomes
              :accounting_entry/expenses]]

            ;; else
            [])

          db*
          (-> db
              (assoc-in [:app :route/current] route))]

      (cond-> {:db db*}
        (not-empty dispatch)
        (assoc :dispatch dispatch)))))
