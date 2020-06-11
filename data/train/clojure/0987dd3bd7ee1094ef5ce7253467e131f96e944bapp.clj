(ns herald.handlers.app
  (:require
    [herald.tmpls :as tmpl]
    [taoensso.timbre :as log]
    [ring.middleware.anti-forgery :as anti-forgery]
    [herald.db :as db]
    [herald.use-cases.manage-user :refer [authorize-or-signup]]
    [blancas.morph.monads :refer [either]]
    [environ.core :refer [env]]))


;;TODO: helpers
(defmacro authorized-resource
  [req auth-body]
  `(if-not (nil? (get-in ~req [:session :uid]))
     (do ~auth-body)
     {:status 302
      :headers {"Location" "/401"}
      :body "Not authorized access."}))

(defn show-workspace
  [{:keys [params session] :as req}]
  (log/debug "User session:" session)
  (if-not (nil? (:uid session))
    (tmpl/workspace {:title "Herald"})
    {:status 302
     :headers {"Location" "/401"}}))

(defn show401
  [req]
  (tmpl/page401 {:title "Knock-knock!."}))

(defn show404
  [req]
  (tmpl/page404 {:title "Ouch! Herald."}))

(defn show-landing
  [req]
  (tmpl/landing {:title "Herald"
                 :csrf-token (str anti-forgery/*anti-forgery-token*)}))

(defn show-settings
  [req]
  (authorized-resource
    req
    (tmpl/settings {:title "Settings"
                    :csrf-token (str anti-forgery/*anti-forgery-token*)})))

;;TODO: finish authorization
(defn authorize
  [{:keys [params session] :as req}]
  (log/debug "User initialized authorization.")
  (db/with-connection (env :herald-env)
    (either [user (authorize-or-signup (:email params) (:password params))]
      (do
        (log/error "User login failed: " user)
        {:status 302
         :headers {"Location" "/401"}})
      ;;after successful login/signup redirect to workspace
      {:status 302
       :headers {"Location" "/workspace"}
       :session (assoc session :uid (:id user))})))

(defn log-out
  [{:keys [session] :as req}]
  (log/debug "User loggin out")
  {:status 302
   :headers {"Location" "/"}
   :session (dissoc session :uid)})

