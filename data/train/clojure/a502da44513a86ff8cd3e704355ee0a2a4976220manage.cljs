(ns centipair.user.manage
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [centipair.core.components.input :as input]
            [centipair.core.utilities.validators :as v]
            [centipair.core.utilities.ajax :as ajax]
            [centipair.core.ui :as ui]
            [centipair.admin.resources :refer [user-source]]
            [centipair.admin.url :refer [entity-url]]
            [centipair.admin.channels :refer [user-manager-form-channel
                                              user-manager-list-channel
                                              site-settings-id
                                              set-active-channel]]
            [centipair.core.components.table :refer [data-table
                                                     generate-table-rows
                                                     per-page]]
            [cljs.core.async :refer [put! chan <!]]
            [reagent.core :as reagent]))


(def user-id (reagent/atom {:id "user-id" :type "hidden" :label "User id"}))
(def email (reagent/atom {:id "email" :type "text" :label "Email"
                          :validator v/email-required}))

(def password-subheading (atom {:id "password-subheading" :label "Password not required. If provided, password will be changed to new" :type "description"}))
(def password (reagent/atom {:id "password" :type "password" :label "Password"}))
(def is-admin (reagent/atom {:id "is-admin" :type "checkbox" :label "Give admin privileges"}))
(def active (reagent/atom {:id "active" :type "checkbox" :label "Activate this user"}))
(def user-manager-form (reagent/atom {:id "user-manage-form" :title "Manage user" :type "form"}))

(defn delete-user [user-id]
  (.log js/console (user-source user-id))
  (ajax/delete
   (user-source user-id)
   (fn [response]
     (put! user-manager-list-channel (:value @site-settings-id)))))

(defn user-list-headers
  []
  [:tr
   [:th "Email"]
   [:th "Active"]
   [:th "Action"]])

(def user-data (reagent/atom {:page 0
                              :id "admin-user-table"
                              :url "/user"
                              :total 0
                              :rows [:tr [:td "Loading"]]
                              :headers (user-list-headers)
                              :create {:entity "user"} 
                              :delete {:action (fn [] (.log js/console "delete"))}
                              :site-settings-id nil
                              :id-field "user_account_id"}))


(defn user-row [row-data]
  [:tr {:key (str "table-row-" ((keyword (:id-field @user-data)) row-data))}
   [:td {:key (str "table-column-1-" ((keyword (:id-field @user-data)) row-data))} (:email row-data)]
   [:td {:key (str "table-column-2-" ((keyword (:id-field @user-data)) row-data))} (str (:active row-data))]
   [:td {:key (str "table-column-3-" ((keyword (:id-field @user-data)) row-data))}
    [:a {:href (str "#/site/" (:value @site-settings-id) "/user/edit/" (:user_account_id row-data))
         :key (str "row-edit-link-" ((keyword (:id-field @user-data)) row-data))} "Edit "]
    [:a {:href "javascript:void(0)" :on-click (partial delete-user (:user_account_id row-data))
        :key (str "row-delete-link-" ((keyword (:id-field @user-data)) row-data)) } " Delete"]]])


(defn save-user []
  (ajax/form-post
   user-manager-form
   (user-source (:value @user-id))
   [user-id
    email
    password
    active
    is-admin]
   (fn [response]
     (ajax/data-saved-notifier response)
     (entity-url "/user/edit" (:user_account_id response)))))


(def save-user-button (reagent/atom {:id "save-user" :type "button" :label "Save" :on-click save-user}))

(defn create-user-manager-form []
  (input/form-aligned user-manager-form [email
                                         password-subheading
                                         password
                                         active
                                         is-admin] save-user-button))

(defn render-user-manage-form []
  (ui/render create-user-manager-form "content"))




(defn map-user-manager-form [response]
  (input/update-value user-id (:user_account_id response))
  (input/update-value email (:email response))
  (input/update-check active (:active response))
  (input/update-check is-admin (:is_admin response)))


(defn fetch-user-list [site-id]
  (swap! user-data assoc :site-settings-id site-id)
  (ajax/get-json
   (user-source)
   {:page (:page @user-data)
   :per per-page}
   (fn [response]
     (generate-table-rows response user-data user-row))))



(defn render-user-edit-form [user-id]
  ;;(swap! user-data assoc :site-settings-id site-id)
  (ajax/get-json
   (user-source user-id)
   nil
   (fn [response]
     (render-user-manage-form)
     (map-user-manager-form response))))


(defn reset-user-manage-form []
  (input/reset-inputs [user-id
                       email
                       password
                       is-admin]))

(defn render-user-create-form []
  (reset-user-manage-form)
  (render-user-manage-form))



(defn init-user-manager-list-channel []
  (go (while true
         (fetch-user-list (<! user-manager-list-channel)))))



(defn create-user-data-list []
  (data-table user-data))


(defn render-user-list []
  (ui/render create-user-data-list "content"))


(defn activate-user-list [page-number]
  (set-active-channel user-manager-list-channel)
  (swap! user-data assoc :page (js/parseInt page-number))
  (if (not (nil? (:value @site-settings-id)))
    (put! user-manager-list-channel (:value @site-settings-id)))
  (render-user-list))

