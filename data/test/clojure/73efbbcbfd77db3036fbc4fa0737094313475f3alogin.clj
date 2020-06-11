(ns note.dispatch.login
  (:require (note (database :as db_)
                  (html :as html_))
            (note.dispatch (common :as common_)
                           (path :as path_))))

(defn make-body
  []
  [:div
   [:form {:method "POST"}
    [:fieldset
     (html_/input "Username" :username)
     (html_/password "Password" :password)
     (html_/button "Enter")]]
   (html_/link "No account yet?" (path_/get :create-user))])

(defn get-dispatch
  [request]
  {:body (make-body)})

(defn post-dispatch
  [request]
  (let [{:keys [username password]} (:params request)
        user (db_/get-user username)]
    (if user
      (-> (common_/redirect :task-list)
          (common_/update-session assoc :username username))
      {:body (make-body)
       :message [{:text "No such user." :type :error}]})))
