(ns rumahsewa141.routes.admin
  (:require [rumahsewa141.layout :as layout]
            [rumahsewa141.services.user :as user]
            [rumahsewa141.services.transaction :as transaction]
            [rumahsewa141.services.config :as site-config]
            [rumahsewa141.views :as views]
            [rumahsewa141.util :refer [parse-double]]
            [compojure.core :refer [defroutes GET POST]]
            [ring.util.http-response :as response]
            [ring.util.response :refer [redirect]]))

(defn update-registration
  "Update registration controller. Redirect to registration page
  afterwards."
  [{{action :action} :params}]
  (when-let [_ (site-config/update-registration-config action)]
    (redirect "/admin/settings/registration")))

(defn- add-transaction
  "Add transaction for selected users. Render success page when
  success."
  [users sign rent internet others]
  (when-let [_ (transaction/add-transactions-by-users users sign rent internet others)]
    (layout/render "success.html" {:title "Done!"
                                   :description (if (pos? (sign 1))
                                                  "Selected users billed successfully."
                                                  "Payment received.")})))

(defn do-transaction
  "Do transaction controller.

  If no user selected, render error page asking to select user.
  If bills requested is zero, render page saying it is no use.
  Else, do the transactions."
  [sign
   {{users           :users
     rent-string     :rent
     internet-string :internet
     others-string   :others  } :params}]
  (let [rent     (parse-double rent-string)
        internet (parse-double internet-string)
        others   (parse-double others-string)]
    (cond
      (nil? users) (layout/render "error_message.html" {:description "Please select a user."})
      (zero? (+ rent internet others)) (layout/render "error_message.html" {:description "No point if no money involved."})
      :else (add-transaction users sign rent internet others))))

(defn- manage-users
  "Manage selected users according to action. Redirect to management
  page afterwards."
  [users action]
  (when-let [_ (user/update-users users action)]
    (redirect "/admin/manage")))

(defn do-manage
  "Management controller.

  If no user selected, render page asking to select user.
  Else, manage selected users."
  [{{:keys [users action]} :params}]
  (if (nil? users)
    (layout/render "error_message.html" {:description "Please select a user."})
    (manage-users users action)))

(defn admin-page
  "Render admin page according to supplied section. The get-content-fn
  will supply the content for the section. The identity will determine
  whether to render page for admin or normal user. The subsection is
  optional since some of the page have more section, for example in
  page 'settings'."
  [section get-content-fn {{username :username} :identity} & [subsection]]
  (layout/render "member.html" (merge {:username username
                                       :admin true
                                       :section section
                                       :subsection subsection}
                                      (if (nil? get-content-fn)
                                        nil
                                        (get-content-fn)))))

(defn settings-page
  "Render settings page."
  [subsection req & [get-content-fn]]
  (admin-page "settings" get-content-fn req subsection))

(defroutes admin-routes
  (GET "/admin" req (admin-page "overview" user/all-users-summary req))
  (GET "/admin/billing" req (admin-page "billing" user/all-users req))
  (GET "/admin/payment" req (admin-page "payment" user/all-users req))
  (GET "/admin/manage" req (admin-page "manage" (user/other-users req) req))
  (GET ["/admin/history/:page" :page #"[1-9][0-9]*"] [page :as req]
       (admin-page "history"
                   (views/history-view (Long/parseLong page) transaction/transactions-count (transaction/latest-transactions req))
                   req))
  (GET "/admin/settings/profile" req (settings-page "profile" req (user/user-info req)))
  (GET "/admin/settings/account" req (settings-page "account" req))
  (GET "/admin/settings/registration" req (settings-page "registration" req site-config/registration-allowed?))
  (POST "/admin/billing" req (do-transaction + req))
  (POST "/admin/payment" req (do-transaction - req))
  (POST "/admin/manage" req (do-manage req))
  (POST "/admin/settings/registration" req (update-registration req)))
