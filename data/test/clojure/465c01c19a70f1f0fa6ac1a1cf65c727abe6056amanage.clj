(ns malbum.routes.manage
  (:require [compojure.core :refer :all]
            [malbum.views.layout :as layout]
            [malbum.models.db :as db]
            [noir.util.route :refer [restricted]]
            [noir.response :as resp]
            [noir.session :as session]))


(defn account-page []
  (layout/render "account.html"
    (if (db/is-admin? ((session/get :user) :user_id))
      {:admin true}
      {}
      )))

(defn manage-page []
  (layout/render "manage.html"
    {:photos (db/images-by-user-name ((session/get :user ) :uname))}))

(defn manage-user-photos-page []
  (layout/render "manage-user-photos.html"
    {:users (db/list-users)}))


(defn get-users-photos [userId]
  (let [photos (db/images-by-user-name (db/username-by-id (read-string userId)))]
    ;(println photos)
    (resp/json photos)))


(defroutes manage-routes
  (GET "/account" []
    (restricted (account-page)))
  (GET "/manage" []
    (restricted (manage-page)))
  (GET "/manage-user-photos" []
    (restricted (manage-user-photos-page)))
  (POST "/photos-for-user" [userId]
    (restricted (get-users-photos userId))))