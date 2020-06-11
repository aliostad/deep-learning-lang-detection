(ns clanhr.auth.authorization-rules
  "This namespace receives some action and a list of roles, then will check if
   those roles can perform that given action. If yes, return a `result/success`
   otherwise returns a `result/forbidden`

   How do this namespace knows if some roles can perform the given action?

   Simple, we have the `rules` map that has that info. We are mapping the actions
   followed by the roles that can perform that specific action"
  (:require [result.core :as result]))

(def ^:const profile
  "Template role profiles for easy access"
  {:full-access ["admin" "hrmanager" "manager" "user" "" "staff"]
   :board-member-manager ["admin" "hrmanager" "manager" "staff"]
   :board-member ["admin" "hrmanager" "staff"]
   :developer-member ["developer"]
   :administrator-member ["admin" "hrmanager"]})

(def ^:const rules
  "Maps specific actions or zones to allowed roles"
  {:directory-access (:full-access profile)
   :notifications-access (:full-access profile)
   :reports-access (:board-member-manager profile)
   :can-manage-groups (:board-member-manager profile)
   :can-manage-absences (:board-member profile)
   :can-manage-roles (:board-member profile)
   :can-manage-settings (:board-member profile)
   :can-manage-alerts (:board-member profile)
   :can-manage-holidays (:board-member profile)
   :can-mark-account-as-paid (:developer-member profile)
   :change-absence-state (conj (:board-member profile) "approver")
   :change-expense-state (conj (:board-member profile) "approver")
   :can-auto-approve-expenses (conj (:board-member profile) "approver")
   :settings-access (:board-member profile)
   :can-see-full-user-info (:board-member profile)
   :delete-user (:board-member profile)
   :billing-actions-access (:administrator-member profile)})

(defn run
  "Check if role can perform action"
  [action roles]
  (let [roles (if (or (nil? roles) (empty? roles))
                [""]
                roles)]
    (if (some (set roles) (action rules))
      (result/success {:roles roles})
      (result/forbidden))))
