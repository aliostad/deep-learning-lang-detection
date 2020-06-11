(ns clj-web-boot.routes.profiles
  (:use compojure.core)
  (:require [ring.util.response :refer [response]]
            [buddy.auth.accessrules :refer [restrict]]
            [clj-web-boot.models.profiles :as profiles]
            [clj-web-boot.security.auth :refer [user-can user-isa user-has-id authenticated-user unauthorized-handler]]))

(defn- get-profiles [_]
  {:status 200
   :body {:count (profiles/number-of)
          :results (profiles/find-all)}})

(defn- get-profile [{{id :id} :params {my-id :profile_id} :identity}]
  (response
    (profiles/find-by-id
      (if (= id "me") my-id id))))

(defn- delete-profile [{{my-id :profile_id} :identity}]
  (profiles/delete-profile-by-id my-id)
  {:status 204
   :body {:result "Profile deleted"}})

(defroutes profiles-routes

           ;; Profiles
           (context "/profiles" []
             (GET "/" []
               (restrict get-profiles {:handler {:and [authenticated-user (user-can "manage-profiles")]}
                                       :on-error unauthorized-handler}))
             (context "/:id" [id]
               (GET "/" []
                 (restrict get-profile {:handler {:and [authenticated-user {:or [(user-can "manage-profiles")
                                                                                 (user-has-id (read-string id))]}]}
                                        :on-error unauthorized-handler})))

             (DELETE "/" []
               (restrict delete-profile {:handler {:and [authenticated-user (user-can "manage-profiles")]}
                                         :on-error unauthorized-handler}))))
