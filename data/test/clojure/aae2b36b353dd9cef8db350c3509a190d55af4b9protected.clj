(ns keycloak-demo.views.protected
  (:require [hiccup.form :refer :all]
            [hiccup.element :refer (link-to)]
            [environ.core :refer [env]]
            [clojure.tools.logging :as log]
            [cemerick.url :refer (url url-encode)])
  (:import [org.keycloak.common.util KeycloakUriBuilder]
           [org.keycloak.constants ServiceUrlConstants]))
 
(defn protected
  "View displayed on the /protected route."
  [token]
  (let [auth_url "http://localhost:8180" 
        base_url "http://localhost:8080" 
        realm "4clojure"
        logout_url (-> (KeycloakUriBuilder/fromUri (str auth_url "/auth"))
                       (.path ServiceUrlConstants/TOKEN_SERVICE_LOGOUT_PATH)
                       (.queryParam "redirect_uri" (into-array Object [(str base_url "/keycloak-demo")]))
                       (.build (into-array Object ["4clojure"]))
                       (.toString))
        account_url (-> (KeycloakUriBuilder/fromUri (str auth_url "/auth"))
                        (.path ServiceUrlConstants/ACCOUNT_SERVICE_PATH)
                        (.queryParam "referrer" (into-array Object [(str base_url "/keycloak-demo")]))
                        (.build (into-array Object ["4clojure"]))
                        (.toString))]
    [:div {:id "content"}
     [:p [:a {:href logout_url} "Logout"] " | "  [:a {:href account_url} "Manage account"]]
     [:h1 {:class "text-success"} "This route is protected by keycloak."]
     [:h2 {:class "text-success"} "Token: " token]
     (link-to {:class "btn btn-primary"} "/keycloak-demo" "Home")]))


