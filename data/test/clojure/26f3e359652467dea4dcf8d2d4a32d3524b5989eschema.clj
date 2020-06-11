(ns spc.api.users.schema
  (:require [schema.core :as s]))

(def allowed-order-by #{:created_at :name :company_name :team_name :email :can_edit_projects :is_business_partner :can_see_not_assigned_realizations :can_edit_users :superior_agent_id})
(def allowed-order-by-directions #{"ASC" "DESC"})

(def allowed-filter-operators #{})
(def allowed-filter-fields #{});(into #{} (map name allowed-order-by)))

(def FilterRow {:field (s/conditional allowed-filter-fields String)
                :operator (s/conditional allowed-filter-operators String)
                :value String})

(def OrderAndFilter {:order_by (s/conditional allowed-order-by s/Keyword)
                     :order_by_direction (s/conditional allowed-order-by-directions String)
                     :filter [FilterRow]})

(def UserRoles {:admin 1
                :owner 2
                :boss 3
                :care 4
                :salesman 5})

(def User {:id s/Num
           :name String
           :email String
           :active Boolean

           :is_developer Boolean
           :is_admin Boolean
           :is_project_manager Boolean
           :is_sales_manager Boolean
           :is_agent Boolean
           :is_business_partner Boolean
           :is_external_realizator Boolean

           :can_see_all_users_data Boolean
           :can_edit_all_users_data Boolean
           :can_delete_all_users_data Boolean

           :can_add_users Boolean
           :can_edit_users Boolean
           :can_delete_users Boolean

           :can_add_companies Boolean
           :can_edit_companies Boolean
           :can_delete_companies Boolean

           :can_see_contacts Boolean
           :can_add_contacts Boolean
           :can_edit_contacts Boolean
           :can_delete_contacts Boolean

           :can_see_todos Boolean
           :can_add_todos Boolean
           :can_edit_todos Boolean
           :can_delete_todos Boolean

           :can_see_opportunities Boolean
           :can_add_opportunities Boolean
           :can_edit_opportunities Boolean
           :can_delete_opportunities Boolean

           :can_see_projects Boolean
           :can_add_projects Boolean
           :can_own_projects Boolean
           :can_edit_projects Boolean
           :can_delete_projects Boolean

           :can_manage_realizations Boolean
           :can_manage_realization_requests Boolean
           :can_see_not_assigned_realizations Boolean
           :can_modify_project_to_dohled Boolean
           :can_modify_project_to_crm Boolean
           :can_modify_project_protokol Boolean

           :can_see_reports Boolean

  ; opt
           :companies_id s/Num
           :member_of_team (s/maybe s/Num)
           :company_name String
           :team_name (s/maybe String)
           :superior_agent_id (s/maybe s/Num)
           :salt String
           :created_at (s/maybe org.joda.time.DateTime)
           :password String
           :g_credentials (s/maybe String)})
