(ns sltapp.routes.auth
  (:require [sltapp.layout :refer [render base-context-authenticated-access base-context-any-access error-page]]
            [compojure.core :refer [defroutes GET POST]]
            [sltapp.utils :refer [get-next-url perform-action-and-redirect]]
            [ring.util.response :refer [redirect]]
            [sltapp.db.core :as db]
            [sltapp.constants :refer [permissions]]
            [sltapp.validators :as validators]
            [sltapp.utils :as utils]
            [sltapp.service.auth :as auth]
            [sltapp.templates.auth :as auth-templates]
            [buddy.hashers :as hashers]
            [clojure.java.io :as io]))

(defn login-page [request next]
  (if (-> request :identity :id)
    (redirect "/")
    (render (auth-templates/login (merge
                                    (base-context-any-access request)
                                    {:next next
                                     :errors (-> request :flash :form_errors)})))))

(defn register-page [request]
  (render (auth-templates/register (merge
                                     (base-context-authenticated-access request)
                                     {:errors (-> request :flash :form_errors)
                                      :permissions (map #(-> [(utils/db-field-to-verbose-name %) %]) permissions)}))))

(defn profile-page [request]
  (render (auth-templates/profile (base-context-authenticated-access request))))

(defn manage-users-page [request]
  (render (auth-templates/manage-users (merge
                                         (base-context-authenticated-access request)
                                         {:user_list (db/get-user-list {:email (-> request :identity :email)})}))))

(defn modify-user [request id field value]
  (let [return-fn (partial perform-action-and-redirect "/manage-users")
        is_user (not (:admin (db/get-user {:id-field "id" :id-value id :cols ["admin"]})))]
    (cond
      (and (= field "role") is_user) (return-fn #(db/update-user {:id-field "id" :id-value id :col "admin" :value (= value "admin")}) {:class "success" :message "User role changed succesfully!"})
      (and (= field "is_active") is_user) (return-fn #(db/update-user {:id-field "id" :id-value id :col "is_active" :value false}) {:class "success" :message "User deleted successfully!"})
    :else
      (return-fn nil {:class "danger" :message "Invalid action"}))))

(defn change-permissions-page [request id]
  (let [is_admin (:admin (db/get-user {:id-field "id" :id-value id :cols ["admin"]}))
        user_perms (for [perm (db/get-user-permissions {:user_id id})] (:codename perm))]
    (if (or is_admin (nil? is_admin))
      (error-page {:status 404 :title "Not found"})
      (render (auth-templates/change-permissions (merge
                                                   (base-context-authenticated-access request)
                                                   {:user_id id
                                                    :current_perms (map #(-> [(utils/db-field-to-verbose-name %) %]) user_perms)
                                                    :new_perms (map #(-> [(utils/db-field-to-verbose-name %) %]) (filter #(empty? (some #{%} user_perms)) permissions))}))))))

(defn reset-password [request id]
  (let [user (db/get-user {:cols ["email" "admin"] :id-field "id" :id-value id})]
    (if (or (:admin user) (nil? user))
      (error-page {:status 404 :title "Not found"})
      (let [password (auth/generate-random-password 8)]
        (db/update-user {:id-field "id" :id-value id :col "password" :value (auth/encrypt-password password)})
        (render (auth-templates/reset-password (merge
                                                 (base-context-authenticated-access request)
                                                 {:alerts [{:class "success" :message "Password reset successfully"}]
                                                  :email (:email user)
                                                  :password password})))))))

(defn change-password [request]
  (let [form (validators/validate-change-password-form (:params request))]
    (let [valid_form (and
                       (utils/valid? form)
                       (validators/validate-change-password (:params request) (:password (db/get-user {:cols ["password"] :id-field "id" :id-value (-> request :identity :id)}))))]
      (if valid_form (db/update-user {:id-field "id" :id-value (str (-> request :identity :id)) :col "password" :value (auth/encrypt-password (-> request :params :new_password))}))
      (render (auth-templates/profile (merge
                                        (base-context-authenticated-access request)
                                        {:alerts [{:class (if valid_form "success" "danger")  :message (if valid_form "Password updated successfully" "Invalid")}]
                                         :errors (utils/get-errors form)}))))))

(defn add-permissions-to-user [user_id perms]
  (doall (for [perm (if (= java.lang.String (type perms)) [perms]  perms)]
    (db/insert-user-perms {:user_id user_id
                           :codename perm}))))

(defn remove-permissions-from-user [user_id perms]
  (doall (for [perm (if (= java.lang.String (type perms)) [perms]  perms)]
    (db/delete-user-perms {:user_id user_id
                           :codename perm}))))

(defn change-permissions [request id action]
  (cond
    (= action "add") (perform-action-and-redirect (str "/change-permissions/" id) #(add-permissions-to-user id (-> request :params :perms)) {:class "success" :message "Permissions added successfully!"})
    (= action "remove") (perform-action-and-redirect (str "/change-permissions/" id) #(remove-permissions-from-user id (-> request :params :perms)) {:class "success" :message "Permissions removed successfully!"})
    :else
      (error-page {:status 404 :title "Not found"})))


(defn create-user [details perms]
  (db/create-user details)
  (if-not (:admin details)
    (add-permissions-to-user (:id (db/get-user {:id-field "email" :id-value (:email details) :cols ["id"]})) perms)))

(defn register-user [request]
  (let [user (validators/validate-user-register (:params request))
        valid_user_perms (validators/valid-user-perms? (:params request))]
    (if (and (utils/valid? user) valid_user_perms)
      (let [user-fields (last user)]
        (let [password (auth/generate-random-password 8)
              unique (empty? (db/get-user {:id-field "email" :id-value (:email user-fields) :cols ["id"]}))]
          (if unique
            (create-user (merge user-fields {:password (auth/encrypt-password password)
                                             :admin (= "Admin" (:role user-fields))
                                             :is_active true})
                         (:permissions user-fields)))
          (render ((if unique auth-templates/register-success auth-templates/register)
                     (merge (base-context-authenticated-access request)
                            {:alerts [{:class (if unique "success" "danger") :message (if unique "User registerd successfully" "A user with this email already exists")}]
                             :email (:email user-fields)
                             :password password})))))
      (-> (redirect "/register")
          (assoc-in [:flash :form_errors] (merge
                                            {:permissions (if-not valid_user_perms ["Please select alteast one permission"] [])}
                                            (utils/get-errors user)))))))

(defn login-user [request next]
  (let [cleaned-user (validators/validate-user-login (:params request))]
    (if (utils/valid? cleaned-user)
      (let [user (db/get-user {:id-field "email" :id-value (:email (last cleaned-user)) :cols ["id" "email" "first_name" "last_name" "is_active" "password" "admin"]})
            password-match (hashers/check (:password (last cleaned-user)) (:password user))]
        (if (and user password-match  (:is_active user))
          (-> (redirect (if (clojure.string/blank? next) "/" next))
              (assoc-in [:session :identity] (merge (select-keys user [:id :email :admin :first_name :last_name])
                                                    {:permissions (for [perm (db/get-user-permissions {:user_id (:id user)})] (:codename perm))})))
          (-> (redirect (str "/login?next=" next))
              (assoc-in [:flash :alerts] [{:class "danger" :message (if password-match "User has been deactivated" "Invalid email/password" )}]))))
      (-> (redirect (str "/login?next=" next))
          (assoc-in [:flash :form_errors] (utils/get-errors cleaned-user))))))

(defn logout [request]
  (-> (redirect "/login")
      (assoc :session {})
      (assoc-in [:flash :alerts] [{:class "success" :message "Logged out successfully!"}])))

(defroutes auth-routes
  (POST "/login" [next :as r] (login-user r next))
  (GET "/register" [] register-page)
  (POST "/register" [] register-user)
  (GET "/logout" [] logout)
  (GET "/profile" [] profile-page)
  (GET "/manage-users" [] manage-users-page)
  (GET "/reset-password/:id{[0-9]+}" [id :as r] (reset-password r id))
  (GET "/modify-user/:id{[0-9]+}/:field{[a-z_]+}/:value{[0-9a-zA-Z]+}" [id field value :as r] (modify-user r id field value))
  (POST "/change-password" [] change-password)
  (GET "/change-permissions/:id{[0-9]+}" [id :as r] (change-permissions-page r id))
  (POST "/change-permissions/:id{[0-9]+}/:action{(add|remove)}" [id action :as r] (change-permissions r id action))
  (GET "/login" [next :as r] (login-page r next)))

