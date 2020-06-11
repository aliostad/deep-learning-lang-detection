(ns sltapp.service.auth
  (:require [sltapp.layout :refer [error-page]]
            [buddy.auth :refer [authenticated? throw-unauthorized]]
            [buddy.auth.backends.session :refer [session-backend]]
            [buddy.auth.accessrules :refer [error]]
            [buddy.hashers :as hashers]
            [ring.util.response :refer [redirect]]))

(defn unauthorized-handler [request metadata]
  (cond
    (authenticated? request)
    (error-page {:status 403
                 :title "Permission denied"
                 :message (or metadata "You dont have access!")})
    :else
    (redirect (format "/login?next=%s" (:uri request)))))

(defn authenticated-user [request]
  (if (:identity request)
    true
    (error "Only authenticated users allowed")))

(defn admin-access [request]
  (if (-> request :identity :admin)
    true
    (error "Only authenticated users allowed")))

(defn on-error [request value]
  (unauthorized-handler request value))

(def auth-backend
  (session-backend {:unauthorized-handler unauthorized-handler}))

(def rules [{:pattern #"^/$"
             :handler authenticated-user}
            {:pattern #"^/profile$"
             :handler authenticated-user}
            {:pattern #"^/(?:disc|c)onnected-circuits$"
             :handler authenticated-user}
            {:pattern #"^/new-circuit-connecting$"
             :handler authenticated-user}
            {:pattern #"^/edit-circuit/[0-9]+$"
             :handler authenticated-user}
            {:pattern #"^/manage-users$"
             :handler admin-access}
            {:pattern #"^/app-settings$"
             :handler admin-access}
            {:pattern #"^/import-data$"
             :handler admin-access}
            {:pattern #"^/reset-password/[0-9]+$"
             :handler admin-access}
            {:pattern #"^/modify-user/[0-9]+/[a-z_]+/[A-Za-z0-9]+$"
             :handler admin-access}
            {:pattern #"^/change-permissions/[0-9]+"
             :handler admin-access}
            {:pattern #"^/register$"
             :handler admin-access}])

; Auth Helpers

(def valid-chars
  (map char (concat (range 48 58)
                    (range 65 91)
                    (range 97 123))))

(defn generate-random-password [length]
  (apply str (take length (repeatedly #(rand-nth valid-chars)))))

(defn encrypt-password [password]
  (hashers/encrypt password {:alg :pbkdf2+sha256
                             :salt "wimo"}))

